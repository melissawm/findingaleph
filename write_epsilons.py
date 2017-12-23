# -*- coding: utf-8 -*-
#matrixfiles = ["matrizes01.txt", "matrizes02.txt", "matrizes03.txt", \
#"matrizes04.txt", "matrizes05.txt", "matrizes06.txt", "matrizes07.txt", \
#"matrizes08.txt", "matrizes09.txt", "matrizes10.txt"]

#pefiles = ["pefile01.txt", "pefile02.txt", "pefile03.txt", \
#"pefile04.txt", "pefile05.txt", "pefile06.txt", "pefile07.txt",\
#"pefile08.txt", "pefile09.txt", "pefile10.txt"]
import numpy as np

with open("epsilons01.txt","w") as epsilonsfile:
    with open("pefile01.txt") as outputfile:
        i = 1
        for line in outputfile:
            #print line
            epsilon = np.asarray(line.split()[4:], dtype=float)
            #print epsilon
            i = i+1
            np.savetxt(epsilonsfile, epsilon[0:4], fmt="%9.7f", newline=" ")
            epsilonsfile.write("\n")
            np.savetxt(epsilonsfile, epsilon[4:8], fmt="%9.7f", newline=" ")
            epsilonsfile.write("\n")
            np.savetxt(epsilonsfile, epsilon[8:12], fmt="%9.7f", newline=" ")
            epsilonsfile.write("\n")
            np.savetxt(epsilonsfile, epsilon[12:16], fmt="%9.7f", newline=" ")
            epsilonsfile.write("\n")
            
print "Done."

