#!/usr/bin/env bash

##############################
#GolanSho
#Date - 19/03/19
#Ver - 1.0.0
#Porpuse - Calculating max,min & avg from user input
##############################

############## Funcs #########
                                  ##  Getting input from user and storing it in array
f_getinloop(){

CurrStat=0

  while [ $CurrStat -ge 0 ]
   do 
      read -p "Input Numbers only: " number
        
           numarry=("${numarry[@]}" "$number")
  

CurrStat=$number 
         
  done
}
                                  ##  Calculating max,min & avg and printing the results
f_gotrughinp(){

max=${numarry[0]}
min=${numarry[0]}
avg=0
  
  for i in "${numarry[@]}"; 
     do
        (( i > max )) && max=$i
        (( i < min )) && min=$i
        total=$((total + i))
  done

        finalavg=$((total/${#numarry[@]}))

        printf "max NUM is $max \n"
        printf "min NUM is $min \n"
        printf "avg is $finalavg \n"
}

###########  Main  ###########

f_getinloop
f_gotrughinp


