
top_line="___________________________________________________"
middle_line="           "
bottom_line="=================================================="

inter1=$(ip address show |cut -d":" -f2 -s|awk -F" " 'NR==1')
inter2=$(ip address show |cut -d":" -f2 -s|awk -F" " 'NR==4')
inter3=$(ip address show |cut -d":" -f2 -s|awk -F" " 'NR==7')
interlist="$inter1 $inter2 $inter3"

f_inter(){
for inter in $interlist ;do
  printf "| $inter |"
  printf " $middle_line "
done
}

iplist=$(ip address show |grep "inet " |awk -F" " '{print $2}')

f_ip(){
for ip in $iplist; do
  printf "| $ip |"

done
}

mac_address=$(ip address show | grep "link/" |awk -F" " '{print $2}')

f_mac(){
for mac in $mac_address; do
  printf "| $mac |"
 
done
}

inter=$(f_inter)
ip=$(f_ip)
mac=$(f_mac)

printf "          Interface List          \n "
printf "$top_line \n"
printf "$inter \n"
printf "$ip \n"
printf "$mac \n"
printf "$bottom_line \n"
