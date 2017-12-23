# -*- coding: utf-8 -*-
# This script only reads one line at a time. When the next line is read, 
# the previous one will be garbage collected unless you have stored a 
# reference to it somewhere else.
with open("pefile10_orig.txt") as infile:
    with open("pefile10.txt",'w') as outfile:
        for line in infile:
            line = line.replace("**********", "Inf")
            outfile.writelines(line)
        
print "Done."
