#!/usr/bin/env bash

#############################################
# Created By GolanSho
# Date - 13/3/19
# Ver - 1.0.0
# Porpuse - tool for managing your interfaces
#############################################

################
###   Vars   ###

inetlist=$(nmcli -f DEVICE dev status |tail -n +2)
conlist=$(nmcli -f CONNECTION dev status |tail -n +2)
modifylist="ip netmask gateway dns broadcast profile exit"

###   Funcs  ###

f_inetc(){
PS3="please choose Profile "

select prof in $conlist
        do
 if [ $prof == -- ]; then
  echo "profile dosent exist"
  read -p "create a profile? y/n " add
   if [ $add == y ]; then f_conadd && f_inetc
   else exit
   fi
 else 
   nmcli device show $prof
   inetc=$(echo $prof)
 fi 
        break
 
done
}
f_conadd(){
read -p "choose type " type
read -p "choose profile name " con_name
select ifname in $inetlist 
 do echo $ifname 
 break
done
nmcli con add type $type con-name $con_name ifname $ifname
}
f_conmod(){
while getopts ":ingdbp" opt; do
  case $opt in
    i)
      read -p "ipv4: " ipc
      nmcli con mod $inetc ipv4.address "$ipc" ipv4.method "manual"
      ;;
    n)
      read -p "netmask: " netmc
      nmcli con mod $inetc ... "$netmc" 
      ;;	
    g)
      read -p "gateway: " gatec
      nmcli con mod $inetc ipv4.gateway "$gatec"
      ;;
    d)
      read -p "DNS1: " dns1c
      read -p "DNS2: " dns2c
      nmcli con mod $inetc ipv4.dns "$dns1c $dns2c"
      ;;
    b)
      read -p "broadcast: " brodc
      nmcli con mod $inetc ... "$brodc"
      ;;
    p)
      read -p "profile: " profc
      nmcli con mod $inetc ... "$profc"
      ;;
  esac
done
}
f_conmodc(){
PS3="what to modify? "
select wtm in $modifylist
 do case $wtm in
  "ip") f_conmod -i ;;
  "netmask") f_conmod -n ;;
  "gateway") f_conmod -g ;;
  "dns") f_conmod -d ;;
  "broadcast") f_conmod -b ;;
  "profile") f_conmod -p ;;
  "exit") break ;;
    esac
done 
}
f_conchk(){
PS3="choose interface "
read -p "setting profile up? y/n " chkans
if [ $chkans == y ]; then
 select ifname in $inetlist
  do echo $ifname 
 break
 done
 nmcli con up $inetc ifname $ifname
  if [ $? == 0 ]; then
   echo "checking connection"
   nmcli networking connectivity check "$ifname"
    else echo "profile didnt go up"
  fi
 else exit
fi 
}
################
###   Main   ###

printf "      nmcli manage tool     \n"
printf "============================\n"
printf " **     Interfaces      **  \n"
nmcli dev status
printf "____________________________\n"

f_inetc
f_conmodc
f_conchk
