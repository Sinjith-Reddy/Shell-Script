#!/bin/sh
# Name: Log rotate
# parameters: 
    # 1-directory path
    # 2-filename you want to archive or delete
    # 3-total number of days files sould be deleted
    # 4-gzip archive older than days


if {$#argv !=4} then
echo ""
echo "You must give exaclty 4 parameters"

NAME=`basename $0`  #o/p script filename
ROTATE_DATE=`date +%Y`'-'`date +%m`'-'`date +%d` # o/p date in 2023-07-02 format
echo "$NAME starting at `date`."
echo "Rotate date is: $ROTATE_DATE"
echo "Parameters $1 $2 $3 $4"

# creating archive dir copying the files to archive dir

mkdir -p $1/archive
cd $1
cp $2 $1/archive/$2.$ROTATE_DATE

# deleting the older archived logs

find $1/archive/$2.$ROTATE_DATE -mtime +$3 -exec /bin/rm -rf {} \;
echo "Delete of $2 files olderthan $3 days completed at `data`."

# compressing the logs

find $1/archive/$2.$ROTATE_DATE -mtime +$4 -exec gzip {} \;
echo "gzip of $2 files older than $4 days completed at `data`."

echo ""
echo " Log rotation completed at `data`."
echo ""
exit 0