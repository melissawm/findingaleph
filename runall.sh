#!/bin/bash

## touch pefile01.txt
## prob00/00 -> 000.000.001 through 000.099.999
## prob00/01 -> 000.100.000 through 000.199.999
## prob00/02 -> 000.200.000 through 000.299.999
## prob00/03 -> 000.300.000 through 000.399.999
## prob00/04 -> 000.400.000 through 000.499.999
## prob00/05 -> 000.500.000 through 000.599.999
## prob00/06 -> 000.600.000 through 000.699.999
## prob00/07 -> 000.700.000 through 000.799.999
## prob00/08 -> 000.800.000 through 000.899.999
## prob00/09 -> 000.900.000 through 000.999.999
## ...
## prob00/99 -> 009.900.000 through 009.999.999

for j in `seq 1 99`
do
#   let "j = 0"
   for i in `seq 1 99999`;
   do
       let "m = 100000 * j + i"
       echo "Problem $m"
       ./findingaleph pmatf $m > "/dados/findingaleph_results/prob00/$(printf %02d $j)/prob$(printf %09d $m).log"
#       result=`tail -1 "/dados/findingaleph_results/prob00/$(printf %02d $j)/prob$(printf %09d $m).log"`
#       if [ "${result:2:1}" = "x" ]; then
#	   echo $m "${result:$((${#result}-1)):1}" >> errors.log
#       fi
   done
#   mv errors.log "/dados/findingaleph_results/prob00/$(printf %02d $j)/."
   #echo "Done $j/99"
   tar czvf "/dados/findingaleph_results/prob00/prob00$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob00/$(printf %02d $j)/"
done

## touch pefile02.txt
## prob01/00 -> 010.000.001 through 010.099.999
## prob01/01 -> 010.100.000 through 010.199.999
## prob01/02 -> 010.200.000 through 010.299.999
## prob01/03 -> 010.300.000 through 010.399.999
## prob01/04 -> 010.400.000 through 010.499.999
## prob01/05 -> 010.500.000 through 010.599.999
## prob01/06 -> 010.600.000 through 010.699.999
## prob01/07 -> 010.700.000 through 010.799.999
## prob01/08 -> 010.800.000 through 010.899.999
## prob01/09 -> 010.900.000 through 010.999.999
## ...
## prob01/99 -> 019.900.000 through 019.999.999

#for j in `seq 1 99`
#do
#   for i in `seq 1 99999`;
#   do
#       # m goes from 010.100.000 up to 019.999.999
#       let "m = 10000000 + 100000 * j + i"
#       echo "Problem $m"
#       ./findingaleph pmatf $m > "/dados/findingaleph_results/prob01/$(printf %02d $j)/prob$(printf %09d $m).log"
#   done
#   tar czvf "/dados/findingaleph_results/prob01/prob01$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob01/$(printf %02d $j)/"
#done

## touch pefile03.txt
## prob02/00 -> 020.000.001 through 020.099.999
## prob02/01 -> 020.100.000 through 020.199.999
## prob02/02 -> 020.200.000 through 020.299.999
## prob02/03 -> 020.300.000 through 020.399.999
## prob02/04 -> 020.400.000 through 020.499.999
## prob02/05 -> 020.500.000 through 020.599.999
## prob02/06 -> 020.600.000 through 020.699.999
## prob02/07 -> 020.700.000 through 020.799.999
## prob02/08 -> 020.800.000 through 020.899.999
## prob02/09 -> 020.900.000 through 020.999.999
## ...
## prob02/99 -> 029.900.000 through 029.999.999

# for j in `seq 0 99`
# do
#    for i in `seq 1 99999`;
#    do
#        # m goes from 020.100.000 up to 029.999.999
#        let "m = 20000000 + 100000 * j + i"
#        echo "Problem $m"
#        ./findingaleph pmatf $m > "/dados/findingaleph_results/prob02/$(printf %02d $j)/prob$(printf %09d $m).log"
#    done
#    tar czvf "/dados/findingaleph_results/prob02/prob02$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob02/$(printf %02d $j)/"
# done

# touch pefile04.txt -> prob03
# for j in `seq 0 99`
# do
#    for i in `seq 1 99999`;
#    do
#        # m goes from 030.100.000 up to 039.999.999
#        let "m = 30000000 + 100000 * j + i"
#        echo "Problem $m"
#        ./findingaleph pmatf $m > "/dados/findingaleph_results/prob03/$(printf %02d $j)/prob$(printf %09d $m).log"
#    done
#    tar czvf "/dados/findingaleph_results/prob03/prob03$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob03/$(printf %02d $j)/"
# done

# touch pefile05.txt -> prob04
# for j in `seq 0 99`
# do
#    for i in `seq 1 99999`;
#    do
#        # m goes from 040.100.000 até 049.999.999
#        let "m = 40000000 + 100000 * j + i"
#        echo "Problem $m"
#        ./findingaleph pmatf $m > "/dados/findingaleph_results/prob04/$(printf %02d $j)/prob$(printf %09d $m).log"
#    done
#    tar czvf "/dados/findingaleph_results/prob04/prob04$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob04/$(printf %02d $j)/"
# done

# touch pefile06.txt -> prob05
# for j in `seq 0 99`
# do
#     for i in `seq 1 99999`;
#     do
# 	# m goes from 050.100.000 até 059.999.999
# 	let "m = 50000000 + 100000 * j + i"
# 	echo "Problem $m"
# 	./findingaleph pmatf $m > "/dados/findingaleph_results/prob05/$(printf %02d $j)/prob$(printf %09d $m).log"
#     done
#     tar czvf "/dados/findingaleph_results/prob05/prob05$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob05/$(printf %02d $j)/"
# done

# touch pefile07.txt -> prob06
# for j in `seq 0 99`
# do
#     for i in `seq 1 99999`;
#     do
# 	# m goes from 060.100.000 até 069.999.999
# 	let "m = 60000000 + 100000 * j + i"
# 	echo "Problem $m"
# 	./findingaleph pmatf $m > "/dados/findingaleph_results/prob06/$(printf %02d $j)/prob$(printf %09d $m).log"
#     done
#     tar czvf "/dados/findingaleph_results/prob06/prob06$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob06/$(printf %02d $j)/"
# done

# touch pefile08.txt -> prob07
# for j in `seq 0 99`
# do
#     for i in `seq 1 99999`;
#     do
# 	# m goes from 070.100.000 até 079.999.999
# 	let "m = 70000000 + 100000 * j + i"
# 	echo "Problem $m"
# 	./findingaleph pmatf $m > "/dados/findingaleph_results/prob07/$(printf %02d $j)/prob$(printf %09d $m).log"
#     done
#     tar czvf "/dados/findingaleph_results/prob07/prob07$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob07/$(printf %02d $j)/"
# done

# touch pefile09.txt -> prob08
# for j in `seq 0 99`
# do
#     for i in `seq 1 99999`;
#     do
# 	# m goes from 080.100.000 até 089.999.999
# 	let "m = 80000000 + 100000 * j + i"
# 	echo "Problem $m"
# 	./findingaleph pmatf $m > "/dados/findingaleph_results/prob08/$(printf %02d $j)/prob$(printf %09d $m).log"
#     done
#     tar czvf "/dados/findingaleph_results/prob08/prob08$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob08/$(printf %02d $j)/"
# done

# touch pefile10.txt -> prob09
# for j in `seq 0 99`
# do
#     for i in `seq 1 99999`;
#     do
# 	# m goes from 090.100.000 até 099.999.999
# 	let "m = 90000000 + 100000 * j + i"
# 	echo "Problem $m"
# 	./findingaleph pmatf $m > "/dados/findingaleph_results/prob09/$(printf %02d $j)/prob$(printf %09d $m).log"
#     done
#     tar czvf "/dados/findingaleph_results/prob09/prob09$(printf %02d $j).tar.gz" "/dados/findingaleph_results/prob09/$(printf %02d $j)/"
# done
