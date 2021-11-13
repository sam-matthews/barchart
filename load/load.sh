#!/bin/bash

# load.sh
# Sam Matthews
# 26th October 2020


BARCHART_CSV="${BARCHART_DAT}/csv"
DEF_STG_FILE="${BARCHART_CSV}/barchart-data-to-load.csv"

psql -d barchart -c "TRUNCATE TABLE barchart_data;"

ls -lrt ${BARCHART_CSV}/watchlist-Stock-of-the-Day-*.csv


for LONG_FILE in `ls -1 ${BARCHART_CSV}/watchlist-Stock-of-the-Day-*.csv`
do
	FILE=`basename "${LONG_FILE}"`
	echo "File to load - " ${FILE}

	# Define correct date.
	MTH=`echo "${FILE}" | cut -d '-' -f 6`
	DAY=`echo "${FILE}" | cut -d '-' -f 7`
	YEAR=`echo "${FILE}" | cut -d '-' -f 8 | cut -d '.' -f 1`
	CURR_DATE=${DAY}-${MTH}-${YEAR}
	echo CURRENT_DATE=${CURR_DATE}
	echo LONG_FILE=${LONG_FILE}
	echo CURRENT_FILE=${FILE}
	
	# Copy current file into # Load data into barchart stg table.
	echo "Copying CSV file to External file location."
	cp -p ${LONG_FILE} ${DEF_STG_FILE}

	echo "Starting load into Database."
	echo "SELECT FROM load_stg_table('$FILE', '$CURR_DATE');"
	psql -d barchart << EOF
		SELECT FROM load_stg_table('$FILE', '$CURR_DATE');
EOF

done

echo "Running One Off Commands"
psql -d barchart -f ${BARCHART_BIN}/post-implementation.sql

# echo "Running summary"
# psql -d barchart -f ${BIN_HOME}/summary.sql

echo "Generate CSV files to be loaded into Motive Wave"

# ${BIN_HOME}/mw-all.sh
