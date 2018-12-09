#!/bin/bash
#if [ -f errors.log ]; then
#    rm errors.log
#fi
#if [ -f /home/melissa/trabalho/hsw/data_hsw/pefile01.txt ]; then
#    rm /home/melissa/trabalho/hsw/data_hsw/pefile01.txt
#    touch /home/melissa/trabalho/hsw/data_hsw/pefile01.txt
#fi

# touch pefile01.txt
# prob00/00 -> 000.000.001 through 000.099.999
# prob00/01 -> 000.100.000 through 000.199.999
# prob00/02 -> 000.200.000 through 000.299.999
# prob00/03 -> 000.300.000 through 000.399.999
# prob00/04 -> 000.400.000 through 000.499.999
# prob00/05 -> 000.500.000 through 000.599.999
# prob00/06 -> 000.600.000 through 000.699.999
# prob00/07 -> 000.700.000 through 000.799.999
# prob00/08 -> 000.800.000 through 000.899.999
# prob00/09 -> 000.900.000 through 000.999.999
# ...
# prob00/99 -> 009.900.000 through 009.999.999

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
