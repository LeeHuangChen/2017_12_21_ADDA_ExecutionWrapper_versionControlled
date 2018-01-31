from Bio.Blast import NCBIXML
import os


class HSP():

    def __init__(self):
        pass

    def __repr__(self):
        return '%s--%d-%d__%s--%d-%d' % (
        self.query_id, self.query_span.start, self.query_span.end, self.target_id, self.target_span.start,
        self.target_span.end)

    def set_focus(self, focus):  # either 'query' or 'target'
        self.focus = focus

        return

    def focus_id(self):
        if self.focus == 'query':
            return self.query_id
        elif self.focus == 'target':
            return self.target_id
        else:
            raise Exception('focus not recognized')

    def focus_align_start(self):
        if self.focus == 'query':
            return self.query_start
        elif self.focus == 'target':
            return self.target_start
        else:
            raise Exception('focus not recognized')

    def focus_align_end(self):
        if self.focus == 'query':
            return self.query_end
        elif self.focus == 'target':
            return self.target_end
        else:
            raise Exception('focus not recognized')

    def other_id(self):
        if self.focus == 'query':
            return self.target_id
        elif self.focus == 'target':
            return self.query_id
        else:
            raise Exception('focus not recognized')

    def other_align_start(self):
        if self.focus == 'query':
            return self.target_start
        elif self.focus == 'target':
            return self.query_start
        else:
            raise Exception('focus not recognized')

    def other_align_end(self):
        if self.focus == 'query':
            return self.target_end
        elif self.focus == 'target':
            return self.query_end
        else:
            raise Exception('focus not recognized')


class Span():

    def __init__(self, start=None, end=None):
        self.start = start
        self.end = end

    def __len__(self):
        if self.start != None and self.end != None:
            return self.end - self.start
        else:
            return 0


# #, query, target, query_start, query_end, target_start, target_end, align_length, identity):
# def read_HSP(line):
#     pair=line.strip().split()
#     hsp = HSP()
#     hsp.query_id = pair[0]      # [query_taxid]-[query_gi]-[query_length]
#     hsp.target_id = pair[2]     # [target_taxid]-[target_gi]-[target_length]

#     hsp.query_tax_id, hsp.query_gid, hsp.query_length = pair[0].split('-')
#     hsp.query_length = int(hsp.query_length)
#     hsp.target_tax_id, hsp.target_gid, hsp.target_length = pair[2].split('-')
#     hsp.target_length = int(hsp.target_length)

#     hsp.query_start, hsp.query_end = map(int, pair[1].split('-'))
#     hsp.target_start, hsp.target_end = map(int, pair[3].split('-'))
#     hsp.align_length = int(pair[4])
#     hsp.identity = int(pair[5])
#     hsp.positive = int(pair[6])
#     hsp.evalue=float(pair[7])

#     return hsp

# def overlap(s1start, s1end, s2start, s2end):
#     maxstart = max(s1start, s2start)
#     minend = min(s1end, s2end)
#     if maxstart < minend:
#         return minend - maxstart
#     else:
#         return 0


def intersection(s1, s2):
    maxstart = max(s1.start, s2.start)
    minend = min(s1.end, s2.end)
    if maxstart < minend:
        return Span(maxstart, minend)
    else:
        return Span()  # an empty span


def union(s1, s2):
    # if the two spans are disjoint then the
    # region in between the two spans are also
    # included in the union.
    minstart = min(s1.start, s2.start)
    maxend = max(s1.end, s2.end)

    return Span(minstart, maxend)


def parse_blast(strInput, evalue_threshold=1e-4, query_taxid='511145'):
    """
    parse blast result xml
    
    Arguments:
    - `blastxmlpath`:
    """
    # input string format:
    # 0      1       2   3       4       5           6       7   8
    # nid1   nid2    %id from1   to1     alignlen    from2   to2 Evalue  na  na

    arr = strInput.split("\t")

    query = arr[0]
    target = arr[1]
    identity = float(arr[2])
    qst = int(arr[3])
    qend = int(arr[4])
    align_length = int(arr[5])
    sst = int(arr[6])
    send = int(arr[7])
    Evalue = float(arr[8])

    # remove self hit
    # i.e., hsp with full length aligned to the query
    if query == target and qst == qend and sst == send:
        return (None, None)
    hsps = []
    h = HSP()

    h.query_tax_id = "ignored"
    h.query_gid = query
    h.query_length = "ignored"
    h.query_span = Span(qst, qend)
    h.query_id = '%s-%s-%s' % (h.query_tax_id, h.query_gid, h.query_length)

    h.target_tax_id = "ignored"
    h.target_gid = target
    h.target_length = "ignored"
    h.target_span = Span(sst, send)
    h.target_id = '%s-%s-%s' % (h.target_tax_id, h.target_gid, h.target_length)

    h.align_length = align_length
    h.identity = identity
    h.positive = "ignored"
    h.evalue = Evalue

    if h.evalue < evalue_threshold:
        # print "test"
        hsps.append(h)

    return (query, hsps)
