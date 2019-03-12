#!/usr/bin/env bash

############################
#
#
#
#
############################

################
###   Vars   ###
inetlist=$(nmcli --fields "NAME" connection show |grep [a-z])

###   Funcs  ###
f_inetc(){
PS3="please choose Interface "

select inet in $inetlist
	do
 nmcli connection show $inet
  break
   done 
}




################
###   Main   ###

printf "      nmcli manage tool     \n"
printf "============================\n"
printf " **     Interfaces      **  \n"  
nmcli --fields "NAME" connection show
printf "++++++++++++++++++++++++++++\n"
f_inetc
