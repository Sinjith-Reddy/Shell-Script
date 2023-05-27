#!/bin/bash

#A prime number is a number that is divisible by only two numbers: 1 and itself. 
#So, if any number is divisible by any other number, it is not a prime number.

###################################
######## using For Loop ###########

#number
n=9
#flag Variable
f=0

# if you want to provide number at runtime uncomment below two line.
#echo "enter number: \n"
#read n
for ((i=2; i<=n/2; n++))
#we are looping from 2 to num/2. It is because a number is not divisible by more than its half. 
#No need to divide it by 1  anyway
do
	ans=$(( n%i ))
	if [ $ans -eq 0 ]
	then
   		f=1
	break  #
 	fi
done
if [ $f -eq 1 ]
then
	echo "$n is not a prime number."
else
	echo "$n is a prime number."
fi




###################################
######## using While Loop ###########

#loop variable
i=2
#running a loop from 2 to number/2
while test $i -le `expr $number / 2`
do
#checking if i is factor of number
if test `expr $number % $i` -eq 0
then
	f=1
	break
fi
#increment the loop variable
i=`expr $i + 1`
done

if test $f -eq 1
then
echo "Not Prime"
else
echo "Prime"
fi
