#!/usr/bin/env bash


############################################################################
#
# Created By: GolanSho
#
# Date: 09/01/20
#
# Ver: 0.7
#
# Description: Advanced automation for Lets encrypt ssl.
#
# avilable options: [-b] Build [-s] Single\Send [-r] Reinstall [-d] Delete
#
############################################################################

# =========================================== #

#         1st Stage - Running on List         #

# =========================================== #

f_run_on_file(){

  for dom in $(grep "^[^#]" /home/letsencrypt/to_do_list.lst |cut -d"'" -f1);
  do
    grep -q "^$dom" /home/letsencrypt/completed_list.lst

    if [ $? = 1 ]; then
      f_www_or_not $dom
    fi
  done

  if [[ -z ${with_www} ]] && [[ -z ${no_www} ]]; then
    echo "nothing to do." && exit
  fi

}

f_get_from_usr(){

  if [[ $# = 1 ]]; then
    echo "didn't got any value.."
  elif [[ $# > 2 ]]; then
    echo "got too many args.."
  elif [[ $# = 2 ]]; then
    if [[ $2 =~ .+,.+,.+ ]]; then
      grep $2 /home/letsencrypt/to_do_list.lst
      if [[ $? = 0 ]]; then
        echo "domain already exist.."
      else
        echo "adding $2 to the list.." && dom=$(echo $2 | sed "s/\,/\'/g") && echo $dom >> /home/letsencrypt/to_do_list.lst
      fi
    else
        echo "Format is - domain,external_ip,internal_ip"
    fi
  fi
}

# =========================================== #

#          2nd Stage - www or not             #

# =========================================== #

f_www_or_not(){

  if [[ $1 =~ ^www.+ ]]; then
    echo "$1 install with www" && with_www=("${with_www[@]}" "$dom")
  else
    echo "$1 install without www" && no_www=("${no_www[@]}" "$dom")
  fi
}


# =========================================== #

#          3rd Stage - Building NginX         #

# =========================================== #

f_chk_int(){

  grep -q $1 /etc/network/interfaces

  if [ $? = 0 ]; then
    echo "interface $1 already exist" && int_status=false
  else echo "Creating new interface for $1" && int_status=true
  fi
}

f_chk_redir(){

  grep -q $1 /etc/nginx/sites-enabled/default

  if [ $? = 0 ]; then
    echo "Client $1 already exist" && redir_status=false
  else echo "Craing new Client for $1" && redir_status=true
  fi
}

f_build_nginx(){

  for i in $(grep "^[^#]" /home/letsencrypt/to_do_list.lst);
  do
    ext_ip=$(echo $i |cut -d"'" -f2)
    int_ip=$(echo $i |cut -d"'" -f3)
    x=$(echo $ext_ip |sed 's/\./\\./g')
    dom_name=$(echo $i |cut -d"'" -f1)
    
    f_chk_int $ext_ip

    if [ $int_status = false ]; then
      echo "Skipping interface setup"
    elif [ $int_status = true ]; then
      last_eth=$(grep -oP "eth0:\d*" /etc/network/interfaces | tail -n1 | cut -d":" -f2)
      new_eth="eth0:"$(( $last_eth + 1 ))
      printf "
allow-hotplug $new_eth
iface $new_eth inet static
        address $ext_ip
        netmask 255.255.255.255
" >> /etc/network/interfaces

    fi

    f_chk_redir $ext_ip

    if [ $redir_status = false ]; then
      echo "Skipping Nginx setup"
    elif [ $redir_status = true ]; then

      printf "
#####
# $dom_name
#####
server {
        listen $ext_ip:80 default_server;
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                proxy_pass      http://$int_ip;
        }
 #      location /.well-known/acme-challenge/ {
 #               proxy_pass      http://127.0.0.1;
 #      } 
 location ~ ^/\\.well-known/acme-challenge/([-_a-zA-Z0-9]+)$ {
    default_type text/plain;
    return 200 \"\$1.EIqzoXnfBt52xjKp4N4Y4rWibBu5CotXkLG9AI2I4HI\";
  }
}
" >> /etc/nginx/sites-enabled/default
  
    fi
  done
}


# =========================================== #

#          4th Stage - Building SSL           #

# =========================================== #

f_build_no_www(){

  for domain in ${no_www[@]};
  do
    grep -q "^$domain" /home/letsencrypt/completed_list.lst

    if [ $? = 0 ]; then
      echo "$domain ssl already installed"
    else
      /home/letsencrypt/letsencrypt_manual_nowww.sh $domain $(grep "$domain" /home/letsencrypt/to_do_list.lst |cut -d"'" -f3) &&
          echo $(grep "$domain" /home/letsencrypt/to_do_list.lst) >> /home/letsencrypt/completed_list.lst
    fi
  done
}

f_build_www(){

  for domain in ${with_www[@]};
  do
    grep -q "^$domain" /home/letsencrypt/completed_list.lst
    
    if [ $? = 0 ]; then
      echo "$domain ssl already installed"
    else
      /home/letsencrypt/letsencrypt_manual.sh $domain $(grep "$domain" /home/letsencrypt/to_do_list.lst |cut -d"'" -f3) &&
          echo $(grep "$domain" /home/letsencrypt/to_do_list.lst) >> /home/letsencrypt/completed_list.lst
    fi
  done
}

# =========================================== #

#                 Remove SSL                  #

# =========================================== #

f_rm_ssl(){

  if [[ $# = 2 ]]; then
    if [[ $2 = "." || $2 = "*" ]]; then
      echo "not permited" && exit 0
    else
      to_del=$(echo $2 |cut -d"," -f1)
    fi
  elif [[ $# > 2 ]]; then
    echo "only accept one domain" && exit 0
  elif [[ $# < 2 ]]; then
    echo "didnt recived a domain" && exit 0
  fi

  sed -i "/^$to_del'/d" /home/letsencrypt/completed_list.lst
  sed -i "/$to_del/d" /etc/hosts

  to_del=$(echo $to_del |cut -d"." -f2-)
  dir_list="/etc/letsencrypt/archive/$to_del /etc/letsencrypt/live/$to_del /etc/letsencrypt/renewal/$to_del.conf /etc/nginx/sites-enabled/$to_del.conf"

  for dir in $dir_list;
  do
    if [ -e $dir ]; then
      rm -rf $dir && echo "$to_del removed from $dir"
    else
      echo "domain not found in $dir"
    fi
  done

}


# =========================================== #

#                    Help                     #

# =========================================== #

f_help(){

printf "
########################################################

#                     Help Section                     #

########################################################

# Usage: [-b] Build [-s] Single/Send                   #
         [-r] Reinstall [-d] Delete [-h] Help          #

# [-b] Install Cert by the DB file.                    #
# [-s] adds a single domain to DB file.                #
#    - Format is: domain_name,External_ip,Internal_ip  #
# [-r] Reintall Cert by domain name                    #
# [-d] Delete Cert by domain name                      #
# [-h] This Help page                                  #

########################################################
"
}

# =========================================== #

#                    Main                     #

# =========================================== #

if [[ $# = 0 ]]; then
  f_help
fi

while getopts ":bsrdh" opt; do
  case $opt in
    b)
      f_run_on_file
      f_build_nginx
      f_build_no_www
      f_build_www
      ;;
    s)
      f_get_from_usr $@
      ;;
    r)
      f_rm_ssl $@
      f_get_from_user $@
      f_run_on_file
      f_build_no_www
      f_build_www
      ;;
    d)
      f_rm_ssl $@
      ;;
    h)
      f_help
      ;;
  esac
done
