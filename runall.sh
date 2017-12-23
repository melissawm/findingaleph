#!/bin/bash
#if [ -f errors.log ]; then
#    rm errors.log
#fi
#if [ -f /home/melissa/trabalho/hsw/data_hsw/pefile01.txt ]; then
#    rm /home/melissa/trabalho/hsw/data_hsw/pefile01.txt
#    touch /home/melissa/trabalho/hsw/data_hsw/pefile01.txt
#fi
for i in `seq 30000000 39999999`;
do
    echo "Problem $i"
    ./main pmatf $i > "/home/melissa/logs/prob$i.log"
    result=`tail -1 "/home/melissa/logs/prob$i.log"`
    if [ "${result:2:1}" = "x" ]; then
	echo $i "${result:$((${#result}-1)):1}" >> errors.log
    fi
done
