#!/usr/bin/env python
################################
# googlecomp.py ################
# Get the first autocomplete ###
# result of a Google search. ###
# Dist. under the MIT License. #
# ckjbgames 2017 ###############
################################
import urllib.request, urllib.parse, urllib.error,json,sys,re

def firstautocomp(kw):
    """
    Get the first autocomplete result
    for kw.
    """
    webpage="http://suggestqueries.google.com/complete/search?client=chrome&q="\
             + urllib.parse.quote_plus(kw)
    result=json.loads((urllib.request.urlopen(webpage).read()).decode('utf-8'))
    if len(result[1]):
        return result[1][0]
    else:
        return ''

def usage():
    """
    Show the usage of the program, then
    exit with status 1.
    """
    sys.stderr.write("Usage: ./googlecomp.py keyword\n")
    sys.stderr.write("\tFind the first Google autocomplete keyword.\n")
    sys.stderr.write("\tkeyword: A keyword to find autocomplete results for.\n")
    sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        usage()
    else:
        try:
            print((firstautocomp(re.sub(r'\s','+',sys.argv[1]))))
        except urllib.error.HTTPError as e:
            sys.stderr.write("There was an HTTP error. Sorry about that.\n")
            sys.exit(1)

