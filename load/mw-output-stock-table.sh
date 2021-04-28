#!/bin/bash


# DB_HOME="${APP_HOME}/postgres"
# CFG_HOME="${DB_HOME}/cfg"

# UNLOAD_HOME="${DATA_HOME}/unload"
# LOAD_HOME="${DATA_HOME}/load"

# for fund in `cat ${CFG_HOME}/mw-funds.cfg`
# do
  # echo $fund


DATA_HOME="$HOME/dev/data/barchart/unload"
CHART_TYPE='3-mth'
CHART_PERIOD='week'
CHART_DUR=8

split_line () {


  # define input parameter.
  text=$1

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

} 


myline=$1
echo "Generating data for ${myline}"

split_line "$myline"

CSV_FILE_NAME=${CHART_TYPE}-${CHART_PERIOD}-${CHART_DUR}


psql -d barchart << EOF > /dev/null

  SELECT mw('$CHART_TYPE', '$CHART_PERIOD', '$CHART_DUR');

  \COPY (SELECT \
    s_stock_date AS date, \
    s_stock_open AS open, \
    s_stock_high AS high, \
    s_stock_low AS low, \
    s_stock_close AS close, \
    s_stock_volume AS volume,\
    s_stock_adj_close AS adj_close\
  FROM s_stock)\
  TO '$DATA_HOME/$CSV_FILE_NAME.csv' WITH (FORMAT CSV , HEADER);

EOF
