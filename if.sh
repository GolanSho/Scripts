#!/usr/bin/env bash

##############################
# GolanSho
# 1.0.0
# arrnging interfaces in chart
##############################

#########################
# Setting Vars        ###

interface1=$(ifconfig | cut -d":" -f1 -s | awk -F" " 'NR==1')
interface2=$(ifconfig | cut -d":" -f1 -s | awk -F" " 'NR==4')
interface3=$(ifconfig | cut -d":" -f1 -s | awk -F" " 'NR==7')
ip1=$(ifconfig | grep "[i][n][e][t]" |awk -F" " 'NR==1''{ print $2 }')
ip2=$(ifconfig | grep "[i][n][e][t]" |awk -F" " 'NR==2''{ print $2 }')
ip3=$(ifconfig | grep "[i][n][e][t]" |awk -F" " 'NR==4''{ print $2 }')
mac1=$(ifconfig | grep "[e][t][h][e][r]" | awk -F" " 'NR==1''{print $2}')
mac2=$(ifconfig | grep "[e][t][h][e][r]" | awk -F" " 'NR==2''{print $2}')
mac3=$()

#########################
# Building the chart  ###

printf " ______________________________________________________\n"
printf "| Interface | IP Adress       | MAC Adress             | \n"
printf "|======================================================| \n"
printf "| $interface1 | $ip1 | $mac1  \n"
printf "|------------------------------------------------------| \n"
printf "| $interface2 | $ip2 | $mac2  \n"
printf "|------------------------------------------------------| \n"
printf "| $interface3 | $ip3 | $mac3  \n"
printf "|______________________________________________________| \n"
