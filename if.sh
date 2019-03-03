#!/usr/bin/env bash

##############################
# GolanSho
# 1.0.0
# arrnging interfaces in chart
##############################

#########################
# Setting Vars        ###

interface1=$(ifconfig |awk -F: '$1>0 {print $1}'|awk 'NR==1'|grep [a-z][a-z][a-z])
interface2=$(ifconfig |awk -F: '$1>0 {print $1}'|awk 'NR==2'|grep [a-z][a-z][a-z])
interface3=$(ifconfig |awk -F: '$1>0 {print $1}'|awk 'NR==3'|grep [a-z][a-z][a-z])
ip1=$(ifconfig | grep "[i][n][e][t][ ]" |awk -F" " 'NR==1''{ print $2 }')
ip2=$(ifconfig | grep "[i][n][e][t][ ]" |awk -F" " 'NR==2''{ print $2 }')
ip3=$(ifconfig | grep "[i][n][e][t][ ]" |awk -F" " 'NR==3''{ print $2 }')
mac1=$(ifconfig | grep "[e][t][h][e][r]" | awk -F" " 'NR==1''{print $2}')
mac2=$(ifconfig | grep "[e][t][h][e][r]" | awk -F" " 'NR==2''{print $2}')
mac3=$(ifconfig | grep "[e][t][h][e][r]" | awk -F" " 'NR==3''{print $2}')

#########################
# Functions           ###

f_loop1(){
if [ -z "$interface1" ] ;then
  echo "Loop"
fi
} 
f_loop2(){
if [ -z "$interface2" ] ;then
  echo "Loop"
fi
}
f_loop3(){
if [ -z "$interface3" ] ;then
  echo "Loop"
fi
}
floop1=$(f_loop1)
floop2=$(f_loop2)
floop3=$(f_loop3)
#########################
# Building the chart  ###

printf " ______________________________________________________\n"
printf "| Interface | IP Adress       | MAC Adress             | \n"
printf "|======================================================| \n"
printf "| $interface1$floop1 | $ip1 | $mac1  \n"
printf "|------------------------------------------------------| \n"
printf "| $interface2$floop2 | $ip2 | $mac2  \n"
printf "|------------------------------------------------------| \n"
printf "| $interface3$floop3 | $ip3 | $mac3  \n"
printf "|______________________________________________________| \n"
