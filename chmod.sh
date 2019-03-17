#!/usr/bin/env bash


f_chmod(){

read -p "Enter a Full Path: " fpath

list=$(ls $fpath)

for i in $list
 do
  
  if [ -d "$fpath$i" ]; then
   chmod 775 "$fpath$i" && echo "Dir Changed"
  elif [ -f "$fpath$i" ]; then
   chmod 664 "$fpath$i" && echo "File Changed"
  else echo "cant change that"
  fi
done
}

f_chmod   
