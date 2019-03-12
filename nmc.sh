#!/usr/bin/env bash

############################
#
#
#
#
############################

################
###   Vars   ###

inetlist=$(nmcli device show |grep "GENERAL.DEVICE:" |awk -F" " '{print $2}')

###   Funcs  ###

f_inetc(){
PS3="please choose Interface "

select inet in $inetlist
        do
 nmcli device show $inet
  inetc=$(echo $inet)
        break
   done
}


################
###   Main   ###

printf "      nmcli manage tool     \n"
printf "============================\n"
printf " **     Interfaces      **  \n"
f_inetc

