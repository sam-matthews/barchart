#!/bin/bash

# load.sh
# Sam Matthews
# 26th October 2020

START_DIR=${HOME}/Desktop/barchart/CSV
BIN_HOME=${HOME}/dev/src/barchart/load
DEF_STG_FILE=${START_DIR}/barchart-data-to-load.csv

psql -d barchart -c "TRUNCATE TABLE barchart_data;"

ls -lrt ${START_DIR}/watchlist-Stock-of-the-Day-*.csv

for LONG_FILE in `ls -1 ${START_DIR}/watchlist-Stock-of-the-Day-*.csv`
do
	FILE=`basename "${LONG_FILE}"`
	echo "File to load - " ${FILE}

	# Define correct date.
	MTH=`echo "${FILE}" | cut -d '-' -f 6`
	DAY=`echo "${FILE}" | cut -d '-' -f 7`
	YEAR=`echo "${FILE}" | cut -d '-' -f 8 | cut -d '.' -f 1`
	CURR_DATE=${DAY}-${MTH}-${YEAR}
	echo CURRENT_DATE=${CURR_DATE}
	
	# Copy current file into # Load data into barchart stg table.
	cp -p ${LONG_FILE} ${DEF_STG_FILE}

	psql -d barchart << EOF

		SELECT FROM load_stg_table('$FILE', '$CURR_DATE');

EOF

done

echo "Running One Off Commands"
psql -d barchart -f ${BIN_HOME}/post-implementation.sql

#echo "Running summary"
#psql -d barchart -f ${BIN_HOME}/summary.sql

echo "Generate CSV files to be loaded into Motive Wave"

${BIN_HOME}/mw-all.sh
