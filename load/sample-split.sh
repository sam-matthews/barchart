#!/bin/bash

#Define the string to split
text="3-mth,week,10"

#Define multi-character delimiter
delimiter=","
#Concatenate the delimiter with the main string
string=$text$delimiter

#Split the text based on the delimiter
myarray=()
while [[ $string ]]; do
  myarray+=( "${string%%"$delimiter"*}" )
  string=${string#*"$delimiter"}
done

CHART_TYPE=`echo ${myarray[0]}`
CHART_PERIOD=`echo ${myarray[1]}`
CHART_DUR=`echo ${myarray[2]}`
echo ${CHART_TYPE}
echo ${CHART_PERIOD}
echo ${CHART_DUR}
