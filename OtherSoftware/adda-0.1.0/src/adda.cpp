//--------------------------------------------------------------------------------
// Project adda
//
// Copyright (C) 2003 Andreas Heger All rights reserved
//
// Author: Andreas Heger <heger@ebi.ac.uk>
//
// $Id$
//--------------------------------------------------------------------------------    

#include <math.h>

#include <iostream>
#include <fstream>
#include <iomanip>
#include <iterator>

// //added by Lee
// #include <cstring>
// #include <cstdlib>
// //added by Lee

#include <cstdio>

#include <string>
#include <map>
#include <vector>
#include <list>
#include <set>

#include "adda.h"

// #define DEBUG

using namespace std;

/** working with partitions

    during the flow of the algorithm, partitions get deleted and added.
    Usually partitions are split, which means the full partition is deleted
    and two new partitions are created.
    
    score changes, if
    a partition is deleted: 
	remove all pairwise scores between deleted partition
	and all other current partitions
    a partition is added:
	calculate pairwise scores between all new partitions.

    In order to do this in a fully incrementally manner, a matrix of all pairwise
    scores would have to be kept. The matrix would change in size continuously. I 
    think it impractical. 
    
    Instead the difference in score is calculated by summing over the differences
    between all pairwise scores for the deleted old and the added two new partitions.

    ranges are like python ranges, i.e. from:last_element+1
    
    - access links from file, do not keep in memory.
    - read tree from file
    
    have some troubles with streampos. Have to use unsigned long long, as 
    there is no input (<<) operator for streampos in sstream anymore (there
    was one in strstream).

    -> alternatively: prepares links file and build index on the fly.
 */



// use int for Residue, as sometimes the difference is
// taken between two Residues and unsigned int gives underflow
typedef int Residue;
typedef unsigned int Index;
typedef unsigned int Node;

typedef std::pair< Residue, Residue> Range;
typedef std::vector< Range > Ranges;

struct Partition {
  Partition( Node xnode, 
	     Residue xfrom, 
	     Residue xto) : 
    node(xnode), from(xfrom), to(xto) {};
  Node node;
  Residue from; 
  Residue to; 
};

typedef std::list< Partition > PartitionList;
typedef std::vector< PartitionList > Partitions;

struct Link {
  Link( Residue xquery_from, 
	Residue xquery_to, 
	Index xsbjct_index,
	Residue xsbjct_from, 
	Residue xsbjct_to) : 
    query_from(xquery_from), query_to(xquery_to), 
    sbjct_index(xsbjct_index),
    sbjct_from(xsbjct_from), sbjct_to(xsbjct_to) {};
  Residue query_from; 
  Residue query_to; 
  Index sbjct_index;
  Residue sbjct_from; 
  Residue sbjct_to; 
};

typedef std::list< Link > LinkList;
typedef std::vector< LinkList > Links;

typedef std::map<Nid,FileIndex> FileIndexMap;
typedef std::map<Nid,Index> IndexMap;
typedef std::vector<Nid> NidMap;

struct TreeNode {
  TreeNode( int p, int l, int r, Residue f, Residue t) :
    mParent(p), mLeftChild(l), mRightChild(r), mFrom(f), mTo(t) {}
  int mParent;
  int mLeftChild;
  int mRightChild;
  Residue mFrom;
  Residue mTo;
};
  

typedef std::vector< TreeNode > Tree;
typedef std::vector<Tree> Trees;

/* -----------------------------------> parse arguments <---------------------------------- */

/*------< global parameters set by command line options---------------*/
static unsigned int param_loglevel = 1;

/* file names */
static std::string param_file_name_trees = "trees";
static std::string param_file_name_neighbours = "neighbours.in";
static std::string param_file_name_index = "index.in";
static std::string param_file_name_nids = "nids.in";

/* various options */
static bool param_disallow_shortening = false;
static bool param_descend = false;
static int param_max_iterations = 10;
static bool param_use_file_nids = false;

/* function parameters for sigmoid */
static double param_resolution = 1.0;

static double param_real_k = 100;	// smooth sigmoid (has to incorporate the resolution (real k = resolution * k)
static double param_real_c = 10;	// average domain size of 100
static double param_real_max = 1.0;
static double param_real_min = 0.0;

static bool param_relative_overhang = false;
static double param_real_e = 0.05; // Probability of alignment ending directly in alignment is 5% 
static double param_real_f = 0.0;

static double param_e = param_real_e * param_resolution;	
static double param_c = param_real_c / param_resolution;	
static double param_k = param_real_k / param_resolution;

// safety threshold for small overlaps (should be in the range of the resolution);
static int param_threshold_overlap = (int)(10.0 / param_resolution);

static bool param_only_query = false;	// if true, calculate only score for query

/*--------------------------------------------------------------*/
#include <unistd.h>

const char * my_progname = "adda";
const char * SYSTEM_TYPE = "..";
const char * MACHINE_TYPE = "..";

static void print_version() {
  cout << my_progname << " Version $Id$ for  at ..." << endl;
}    

static void usage()
{
  print_version();
  cout << "Usage: " << my_progname << "[OPTIONS]\n" << endl;

  cout << "-v #		loglevel [" << param_loglevel		<< "]" << endl;
  cout << "-V		print version and exit."		<< endl;
  cout << "-h		print help and exit."			<< endl;

  cout << "-K #		parameter k (smoothness of sigmoid) [" << param_real_k	<< "]" << endl;
  cout << "-C #		parameter c (turning point of sigmoid) [" << param_real_c     << "]" << endl;

  cout << "-E #		exponential decay parameter: rate [" << param_real_e	        << "]" << endl;
  cout << "-F #		exponential decay parameter: factor [" << param_real_f		<< "]" << endl;
  
  cout << "-M #		maximum of sigmoid [" << param_real_max << "]" << endl;
  cout << "-N #		minimum of sigmoid [" << param_real_min << "]" << endl;

  cout << "-R		use relative overhang [" << param_relative_overhang << "]." << endl;
  cout << "-Q	        use only query overhang [" << param_only_query << "]." << endl;

  cout << "-n #		file of sorted neighbours [" << param_file_name_neighbours << "]" << endl;
  cout << "-f #		file of indices for neighbours [" << param_file_name_index << "]" << endl;
  cout << "-q #		file of list of nids [" << param_file_name_nids << "]" << endl;
  cout << "-t #		file of trees [" << param_file_name_trees << "]" << endl;

  cout << "-d		algorithm modifier: descend." << endl;
  cout << "-s 		disallow shortening of domains." << endl;
  cout << "-i #		maximum iterations [" << param_max_iterations << "]" << endl;
  cout << "-r #		resolution [" << param_resolution << "]" << endl;

}

void ParseArguments (int argc, char *argv[]) {

  int c;  
  
  extern char * optarg;

  while ((c=getopt(argc, argv, "Vhv:i:l:t:c:K:C:E:F:M:N:n:f:q:sdr:RQ")) != EOF) {
    switch(c) {
      /* connection parameters */
    case 'v':
      param_loglevel = atoi(optarg); break;
    case 'V':
      print_version(); exit(EXIT_SUCCESS);
    case 'h':
      usage(); exit(EXIT_SUCCESS);

      /* others */
    case 'i':
      param_max_iterations = atoi(optarg); break;
    case 's':
      param_disallow_shortening = true; break;
    case 'd':
      param_descend = true; break;
    case 't':
      param_file_name_trees = optarg; break;
    case 'n':
      param_file_name_neighbours = optarg; break;
    case 'f':
      param_file_name_index = optarg; break;
    case 'q':
      param_file_name_nids = optarg; param_use_file_nids = true; break;
    case 'K':
      param_real_k = atof(optarg); break;
    case 'E':
      param_real_e = atof(optarg); break;
    case 'F':
      param_real_f = atof(optarg); break;
    case 'C':
      param_real_c = atof(optarg); break;
    case 'M':
      param_real_max = atof(optarg); break;
    case 'N':
      param_real_min = atof(optarg); break;
    case 'R':
      param_relative_overhang = true; break;
    case 'Q':
      param_only_query = true; break;
    case 'r':
      param_resolution = atof(optarg); break;
    }
  }

  // set pointers to end of options
  (argc)-=optind;
  (argv)+=optind;

  if (argc > 0) {
    usage();
    exit(EXIT_FAILURE);
  }     

  param_e = param_real_e * param_resolution;	
  param_c = param_real_c / param_resolution;	
  param_k = param_real_k / param_resolution;

  if (param_real_f == 0) param_real_f = param_real_e;

  param_threshold_overlap = 10 / (int)param_resolution;
    
}

/*---------------------------> end of argument parsing <---------------------------------------*/

std::ostream & operator<<( std::ostream & output, const Partition & src) {
  output << " node=" << src.node << " from=" << src.from << " to=" << src.to;
  return output;
}

std::istream & operator>>( std::istream & input, Partition & target) {
  return input;
}

std::ostream & operator<<( std::ostream & output, const PartitionList & src) {
  std::copy( src.begin(), src.end(), std::ostream_iterator< Partition >( std::cout, "\n"));
  return output;
}

std::ostream & operator<<( std::ostream & output, const Link & src) {
  output << " sbjct_index=" << src.sbjct_index 
	 << " query_from=" << src.query_from << " query_to=" << src.query_to 
	 << " sbjct_from=" << src.sbjct_from << " sbjct_to=" << src.sbjct_to;
  return output;
}


std::ostream & operator<<( std::ostream & output, const LinkList & src) {
  std::copy( src.begin(), src.end(), std::ostream_iterator< Link >( std::cout, "\n"));
  return output;
}

std::ostream & operator<<( std::ostream & output, const Range & src) {
  output << "from=" << src.first << " to=" << src.second;
  return output;
}

std::ostream & operator<<( std::ostream & output, const TreeNode & src) {
  output << src.mParent << "\t" << src.mLeftChild << "\t" << src.mRightChild << "\t" << src.mFrom << "\t" << src.mTo;
  return output;
}

void PrintTrees( const Trees & trees, const NidMap & map_index2nid ) {
  Index index = 0;
  for (;index<trees.size();++index) {
    Nid nid = map_index2nid[index];
    Index ii = 0;
    for (; ii < trees[index].size(); ++ii) 
      std::cout << index << "\t" << nid << "\t" << ii << "\t" << trees[index][ii] << std::endl;
  }
}

void PrintPartitions( const Partitions & partitions, const NidMap & map_index2nid ) {
  Index index = 0;
  for (;index<partitions.size();++index) {
    Nid nid = map_index2nid[index];
    PartitionList::const_iterator it(partitions[index].begin()), end(partitions[index].end());
    for (;it!=end;++it) 
      std::cout << nid << "\t" << it->from << "\t" << it->to << "\t" << endl;
  }
}

inline void PrintSection() {
  std::cout << "##-------------------------------------------------------" << std::endl;
}

inline int convert(int x) { return (int)(floor( ( (x-1) / param_resolution) ) ); }

/** retrieve all links from nid using the table table_links starting at position
    index
 */
template< class OutputIter >
void fillLinks( FILE * infile,
		const FileIndex & index,
		const Nid & nid,
		const IndexMap & map_nid2index,
		OutputIter it) {
  
  fsetpos( infile, &index );

#ifdef DEBUG
  // check if you are correctly positioned
  {
    int query_nid, sbjct_nid;
    Residue query_from, query_to, sbjct_from, sbjct_to;
    float score;
    
    fscanf( infile,
	    "%d\t%d\t%f\t%i\t%i\t%*s\t%i\t%i\t%*s", 
	    &query_nid, 
	    &sbjct_nid, 
	    &score,
	    &query_from, &query_to,
	    &sbjct_from, &sbjct_to);
    
    if (query_nid != nid) {
      std::cerr << "# positioning error in fillLinks: " << nid << "\t" << query_nid << "\t" << index << std::endl;
      exit(EXIT_FAILURE);
    }
    fsetpos( infile, &index );    
  }
#endif

  char buffer[MAX_LINE_LENGTH+1];

  while (!feof(infile)) {
    int query_nid, sbjct_nid;
    Residue query_from, query_to, sbjct_from, sbjct_to;
    float score;

    fscanf( infile,
	    "%d\t%d\t%f\t%i\t%i\t%*s\t%i\t%i\t%*s", 
	    &query_nid, 
	    &sbjct_nid, 
	    &score,
	    &query_from, &query_to,
	    &sbjct_from, &sbjct_to);

    fgets( buffer, MAX_LINE_LENGTH, infile );
    
#ifdef DEBUG
    std::cout << "read the following: " << std::endl;
    std::cout << " " << query_nid << " " << sbjct_nid << " " << score << " " << query_from << " " << query_to << " " << " " << sbjct_from << " " << sbjct_to << " " << endl;;
#endif

    if (query_nid != nid) 
      break;

    if (query_nid == sbjct_nid)
      continue;

    IndexMap::const_iterator i;
    if ( (i = map_nid2index.find( sbjct_nid )) != map_nid2index.end()) {
      Index sbjct_index = i->second;
      *it = Link(convert(query_from), 
		 convert(query_to)+1, 
		 sbjct_index,
		 convert(sbjct_from), 
		 convert(sbjct_to)+1);
      ++it;
    }
  }

  // reset stream, move away from eof.
  if (feof(infile))
    rewind(infile);
  
}

template< class T>
inline void PrintMap( const T & index, const char * title = "" ) {
  typedef typename T::const_iterator iterator;
  std::cout << "# ";
  iterator it(index.begin()), end(index.end());

  std::cout << title ;

  for (; it != end; ++ it) 
    std::cout << it->first << "->" << it->second << ":";
  std::cout << std::endl;
}

//--------------------------------------------------------------------------------
/** read trees from file
    nodes are sorted by nid and node!
    input format of trees file is
    nid	node	parent	level	xfrom	xto
*/
void fillTrees( ifstream & infile,
		const IndexMap & map_nid2index,
		Trees & trees) {


  while (!infile.eof()) {
    Nid nid; 
    int node, parent, level, xfrom, xto;

    infile >> nid >> node >> parent >> level >> xfrom >> xto;
    if (infile.eof()) break;


    IndexMap::const_iterator it = map_nid2index.find(nid);

    if (it != map_nid2index.end()) {
      Index index = it->second;
      // std::cout << nid << "\t" << parent << "\t" << xfrom << "\t" << xto << "\t" << index <<endl;
      trees[index].push_back( TreeNode(parent,0,0,xfrom,xto) );
    } 
  }

  Trees::iterator it(trees.begin()), end(trees.end());
  for (;it!=end;++it) {
    Tree & t = *it;
    // skip root, child can not be 0 (unless in leaves)
    for (unsigned int i = 1; i < t.size(); ++i) {
      int parent = t[i].mParent;
      if (t[parent].mLeftChild) {
	t[parent].mRightChild = i;
      } else {
	t[parent].mLeftChild = i;
      }
    }
  }
}

//--------------------------------------------------------------------------------
  /** get child partitions for a given partition 
   */
template< class OutputIter >
void fillPartitionsWithChildren( const Trees & trees,
				 const Index index,
				 const Node parent_node,
				 OutputIter it) {
  
  int left = trees[index][parent_node].mLeftChild;
  int right = trees[index][parent_node].mRightChild;
  if (left) {
    *it = Partition( left, trees[index][left].mFrom, trees[index][left].mTo );
    ++it;
  }

  if (right) {
    *it = Partition( right, trees[index][right].mFrom, trees[index][right].mTo);
    ++it;
  }
}  

//------------------------------------------------------------------------
// fill vector of nids with list of components
template< class OutputIter >
void fillNidsFromFile( ifstream & infile, 
		       OutputIter  it) {

  Nid nid;
  while (!infile.eof()) {
    infile >> nid;
    if (infile.eof()) break;
    *it = nid;
    ++it;
  } 

}  



//--------------------------------------------------------------------------------
/*
  Calculate transfer score between two domains on two sequences and an alignment
  between them.

  Mapping is necessary (see case three).


  1.
	   [----transfer-----]
   [-------------l1-----------------]
           -------------------
   [------------l2------------------]
  2.
                         [-transfer-]
   [-------------l1-----------------]
                         -------------------
   [------------l2------------------]
  3.
                         [-transfer-]
   [-------------l1-----------------]
              ----------------------------------------------------------
			 [------------l2------------------]


  The transfer score is:

  OF = log( (double)(l1-transfer) * (double)(l2-transfer))


 */
inline double CalculateScore( const Range & part1, const Range & part2, 
			      const Range & link1, const Range & link2 ) {


  Residue l1 = part1.second - part1.first;
  Residue l2 = part2.second - part2.first;

  // take min, so that transfer will not be negative 
  // make sure all values are treated as signed values, as the differences can 
  // be negative
  Residue lali = std::min( link1.second - link1.first, link2.second - link2.first);
  Residue start = std::max( part1.first  - link1.first + link2.first, link2.first);
  Residue end   = std::min( part1.second - link1.first + link2.first, link2.second);

  Residue transfer = std::min( part2.second, end) - max( part2.first, start);

  // has to be one, as due to the scaling I might have small overlap
  // which would get penalized heavily!!!
  if (transfer <= param_threshold_overlap)
    return 0;

  // surprise score for splitting the alignment into a domain of size transfer
  double z = ((double)transfer - param_c) / param_k;
  double p = 1.0 - exp( -exp(-z) - z + 1);
  if (p < 0.0) p = 0.0;
  double s = -log(p);

  // surprise score for missing out on residues:
  double o1, o2;
  if (param_relative_overhang) {
    o1 = (double)(l1-transfer) / (double)l1;
    o2 = (double)(l2-transfer) / (double)l2;
  } else {
    o1 = (double)(l1-transfer);
    o2 = (double)(l2-transfer);
  }

  // surprise score for missing out on residues:
  double p1 = param_real_f * exp( -param_e * o1);
  double s1 = -log(p1);

  double p2 = param_real_f * exp( -param_e * o2);
  double s2 = -log(p2);

  if (param_loglevel >= 3) {
    cout << endl << "part1=" << part1 << endl << "part2=" << part2 << endl << "link1=" << link1 << endl << "link2=" << link2 << endl;
    cout << " ( start=" << start << ", end=" << end 
	 << ",l1=" << l1 << ",l2=" << l2 
	 << ",lali=" << lali << ",t=" << transfer 
	 << ")" << endl;
    cout << " (p=" << p  << ",s="  << s 
	 << ",p1=" << p1 << ",s1=" << s1 
	 << ",p2=" << p2 << ",s2=" << s2 
	 << ")" << endl;
  }

  if (param_only_query) 
    return s + s2;
  else
    return s + s1 + s2;
}
	

double CalculatePartitionScore( LinkList & links,
				Partitions & partitions, 
				Partition  & old_partition, 
				PartitionList & new_partitions) {
  
  
  double delta_score = 0;

  //------------------------
  // 1. loop over links
  LinkList::iterator it(links.begin()), it_end( links.end());

  for (; it != it_end; ++it) {

    Index sbjct_index = it->sbjct_index;

    //------------------------
    // 2. loop over partitions in sbjct sequence linked to query sequence
    PartitionList::iterator pit(partitions[sbjct_index].begin()), pend(partitions[sbjct_index].end());
    
    for (;pit!=pend;++pit) {

      if (param_loglevel >= 3)
	cout << "------> testing partition idx=" << sbjct_index << " from=" << pit->from << " to=" << pit->to << endl;

      // calculate score for original partition
      double old_score = CalculateScore( Range( pit->from, pit->to), 
					 Range( old_partition.from, old_partition.to),
					 Range( it->sbjct_from, it->sbjct_to),
					 Range( it->query_from, it->query_to));

      
      // calculate score for new partitions
      double new_score = 0;
      PartitionList::iterator nit( new_partitions.begin()), nit_end( new_partitions.end());
      for (; nit != nit_end; ++nit) {
	new_score += CalculateScore( Range( pit->from, pit->to), 
				     Range( nit->from, nit->to),
				     Range( it->sbjct_from, it->sbjct_to),
				     Range( it->query_from, it->query_to));

      }
      
      delta_score += new_score - old_score;

      if (param_loglevel >= 3)
	cout << endl;
      if (param_loglevel >= 2) 
	cout << "------> " << sbjct_index
	     << " new_score=" << new_score 
	     << " old_score=" << old_score 
	     << " inc=" << new_score - old_score
	     << " delta=" << delta_score 
	     << endl;
    }
  }
  return delta_score;
}

//--------------------------------------------------------------------------------
/** optimize partitions.
    below is a greedy optimizer. Every current node in the tree is split. The split
    is retained only, if it is an improvement over a previous assignment.
    
    The order of commands is as follows:
    while improvement > 0:
	0. improvement = 0;
	1. get next partition p_i
	2. split partitition into p_i1 and p_i2
	3. calculate improvement
	4. if improvement > 0:
		delete old partition p_i
		add new partitions p_i1, p_i2
		set improvement > 0
	   else:
		do nothing
*/
void OptimizePartitions( Partitions & partitions, 
			 const Trees & trees,
			 const NidMap & map_index2nid,
			 const IndexMap & map_nid2index,
			 FILE * file_links,
			 const FileIndexMap & map_nid2fileindex,
			 int max_iterations = 10) {

  int niterations = 0;
  
  while (niterations < max_iterations) {
    
    if (param_loglevel >= 0)
      std::cout << "# entering iteration " << niterations << std::endl;
      
    if (param_loglevel >= 1) {
      std::cout << "# ------------------------------------------------------------------------" << endl;
      std::cout << "# partitions at iteration " << niterations << endl;
      PrintPartitions( partitions, map_index2nid );
    }

    niterations ++;
    double improvement = 0;
    
    Index index = 0;
    for (; index < map_index2nid.size(); ++index) {
      
      Nid nid = map_index2nid[index];
      if (param_loglevel >= 1) 
	cout << "--> checking split of " << index << "(" << nid << ")" << endl;
      
      PartitionList::iterator it(partitions[index].begin()), end(partitions[index].end());
      
      while (it!=end) {
	
	Node node = it->node;

	PartitionList new_partitions;
      
	fillPartitionsWithChildren( trees,
				    index,
				    node, 
				    back_insert_iterator< PartitionList >(new_partitions));

	if (new_partitions.size() == 0) {
	  ++it;
	  continue;
	}

	if (param_loglevel >= 1) {
	  cout << "# ----> new partitions ";
	  std::copy( new_partitions.begin(), new_partitions.end(), ostream_iterator< Partition >( std::cout, ";"));
	  cout << endl;
	}

	if (param_disallow_shortening && (new_partitions.size() != 2)) {
	  ++it;
	  continue;
	}

	LinkList links;
	
	fillLinks( file_links, 
		   map_nid2fileindex.find(nid)->second, 
		   nid, 
		   map_nid2index, 
		   back_insert_iterator< LinkList >(links));
	
	if (param_loglevel >= 2) 
	  cout << "# --> found " << links.size() << " links" << endl;
	
	double score = CalculatePartitionScore( links, partitions, *it, new_partitions );
      
	if (score < 0) {
	  if (param_loglevel >= 1) 
	    cout << "# ----> substituting partitition" << endl;

	  partitions[index].insert( it, new_partitions.begin(), new_partitions.end());
	  it = partitions[index].erase( it );
	  improvement += score;
	
	  if (param_descend)
	    for (unsigned int i = 0; i < new_partitions.size(); ++i)
	      --it;
	} else {
	  if (param_loglevel >= 1) 
	    std::cout << "# ----> keeping partitition" << endl;
	  ++it;
	}

	if (param_loglevel >= 3)
	  std::cout << "# ----------------------------------------------------------------" << endl;

      }
    
    }

    if (param_loglevel >= 1)
      std::cout << "# --> improvement=" << improvement << std::endl;

    if (improvement >= 0) 
      break;
  }
}

//--------------------------------------------------------------------------------
void fillFileIndexMap( FileIndexMap & map_nid2fileindex, std::string & file_name_index) {

  FILE * file = fopen(file_name_index.c_str(),"r");
  
  if (file == NULL) {
    std::cerr << "could not open filename with indices: " << file_name_index << std::endl;
    exit(EXIT_FAILURE);
  }
  
  FileIndex last_index;
  
  while(!feof(file)) { 
    
    Nid nid = 0;
    FileIndex index;
    
    fread(&nid,sizeof(Nid), 1, file);
    if (feof(file)) break;
    fread(&index, sizeof(FileIndex), 1, file);

    map_nid2fileindex[nid] = index;
    last_index = index;
  }
  
  fclose(file);

}

//--------------------------------------------------------------------------------
void checkIndex( FileIndexMap & map_nid2fileindex, FILE * file_links) {
}


//--------------------------------------------------------------------------------
int main (int argc, char *argv[]) {

  ParseArguments( argc, argv );
  
  if (param_loglevel >= 1)
    cout <<  "param_real_e=" << param_real_e << ",param_e=" << param_e 
	 << ",param_real_k=" << param_real_k << ",param_k=" << param_k 
	 << ",param_real_c=" << param_real_c << ",param_c=" << param_c 
	 << ",param_real_max=" << param_real_max << ",param_real_min=" << param_real_min
         << ",param_real_f=" << param_real_f 
	 << endl;

  /*------------------------------------------------------------------*/
  // retrieve nids of component
  if (param_loglevel >= 1) {
    std::cout << "# retrieving nids: ";
    std::cout.flush();
  }

  NidMap map_index2nid;

  if (param_use_file_nids) {
    ifstream fin(param_file_name_nids.c_str());
    if (!fin) {
      std::cerr << "could not open filename with nids: " << param_file_name_nids << std::endl;
      exit(EXIT_FAILURE);
    }
    fillNidsFromFile( fin,
		      back_insert_iterator< NidMap >(map_index2nid));
    fin.close();
  } else {
    std::cerr << "please specify file with nids" << std::endl;
    exit(EXIT_FAILURE);
  }

  if (param_loglevel >= 1) 
    std::cout << map_index2nid.size() << " nids in partition " << endl;
  if (param_loglevel >= 2) 
    std::copy( map_index2nid.begin(), map_index2nid.end(), ostream_iterator<Nid>( std::cout, "\n"));

  /*------------------------------------------------------------------*/
  // make map of nid->index
  IndexMap map_nid2index;
  {
    NidMap::iterator it(map_index2nid.begin()), end(map_index2nid.end());
    for (Index i=0;it!=end;++it,++i) 
      map_nid2index[*it] = i;
  }

  if (param_loglevel >= 2) {
    NidMap::iterator it(map_index2nid.begin()), end(map_index2nid.end());
    std::cout << "# map_index2nid\tmap_index2nid" << std::endl;
    for (Index i=0;it!=end;++it,++i) 
      cout << "# " << i << "\t" << *it << "\t" << map_nid2index[*it] << "\t" << (map_nid2index.find(*it) != map_nid2index.end()) << std::endl;
  }

  /*------------------------------------------------------------------*/
  // read tree
  if (param_loglevel >= 1) {
    cout << "# retrieving trees: ";
    std::cout.flush();
  }

  Trees trees(map_index2nid.size());
  {
    ifstream fin(param_file_name_trees.c_str());
    if (!fin) {
      std::cerr << "could not open filename with trees: " << param_file_name_trees << std::endl;
      exit(EXIT_FAILURE);
    }

    fillTrees( fin, 
	       map_nid2index,
	       trees);
    
    fin.close();
  }

  if (param_loglevel >= 1) { 
      Trees::iterator it(trees.begin()), end(trees.end());
      int count = 0;
      for (;it!=end;++it) count += (it->size() > 0);
      std::cout << count << " trees found " << endl;
  }

  if (param_loglevel >= 4) {
    PrintSection();
    PrintTrees( trees, map_index2nid );
  }
  

  /*------------------------------------------------------------------*/
  // open links file: read indices

  FileIndexMap map_nid2fileindex;
  {
    if (param_loglevel >= 3) {
      std::cout << "## retrieving indices from " << param_file_name_index << "." << std::endl;
    }
    
    fillFileIndexMap( map_nid2fileindex, param_file_name_index );

    if (param_loglevel >= 3) {
      std::cout << "## retrieved " << map_nid2fileindex.size() << " indices." << std::endl;
    }
  }

  /*------------------------------------------------------------------*/
  if (param_loglevel >= 1)
    cout << "# opening links file: " << std::endl; 
  
  FILE * file_links = fopen(param_file_name_neighbours.c_str(),"r");

  if (file_links == NULL) {
    std::cerr << "could not open filename with links: " << param_file_name_neighbours << std::endl;
    exit(EXIT_FAILURE);
  }

  /*------------------------------------------------------------------*/
  // fill partitions with initial values
  Partitions partitions(map_index2nid.size());
  {
    for (Index index = 0; index < map_index2nid.size(); ++index) 
      if (trees[index].size())
	partitions[index].push_back( Partition( 0, trees[index][0].mFrom, trees[index][0].mTo) );
  }

  if (param_loglevel >= 3) {
    std::cout << "# partitions at beginning " << endl;
    std::copy( partitions.begin(), partitions.end(), ostream_iterator< PartitionList >( std::cout, ""));
  }
  
  OptimizePartitions( partitions, 
		      trees,
		      map_index2nid,
		      map_nid2index,
		      file_links,
		      map_nid2fileindex,
		      param_max_iterations);
  
  std::cout << "# final partitions" << endl;
  PrintPartitions( partitions, map_index2nid);
  
  fclose( file_links );

}































