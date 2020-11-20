#!/bin/bash

# load.sh
# Sam Matthews
# 26th October 2020

START_DIR=${HOME}/Desktop/barchart/CSV

for LONG_FILE in `ls -1 ${START_DIR}/*.csv`
do
	FILE=`basename "${LONG_FILE}"`
	echo ${FILE}

	MTH=`echo "${FILE}" | cut -d '-' -f 6`
	DAY=`echo "${FILE}" | cut -d '-' -f 7`
	YEAR=`echo "${FILE}" | cut -d '-' -f 8 | cut -d '.' -f 1`
	CURR_DATE=${DAY}-${MTH}-${YEAR}
	echo CURRENT_DATE=${CURR_DATE}
	# Load data into barchart stg table.

	psql -d barchart << EOF

		TRUNCATE TABLE stg;

		-- INSERT INTO STG Table.
		\copy stg from $LONG_FILE DELIMITER ',' CSV HEADER

		-- INSERT INTO ATOMIC TABLE.
		INSERT INTO barchart_data
		SELECT symbol, '$CURR_DATE', last_price,
		CASE 
			WHEN weighted_alpha = 'unch' THEN '0'
			WHEN weighted_alpha = 'N/A' then '0' 
			WHEN substr(weighted_alpha,1,1) = '+' THEN SUBSTR(weighted_alpha,2,LENGTH(weighted_alpha)-1) --remove +
			ELSE weighted_alpha 
		END weighted_alpha,
		CASE
			WHEN perc_change_daily = 'unch' THEN '0'
			WHEN substr(perc_change_daily,1,1) = '+' THEN SUBSTR(perc_change_daily,2,LENGTH(perc_change_daily)-2)
			WHEN SUBSTR(perc_change_daily,1,1) = '-' THEN SUBSTR(perc_change_daily,1,LENGTH(perc_change_daily)-1)
			ELSE perc_change_daily
		END perc_change_daily,
		CASE
			WHEN perc_chg_week = 'unch' THEN '0'
			WHEN substr(perc_chg_week,1,1) = '+' THEN SUBSTR(perc_chg_week,2,LENGTH(perc_chg_week)-2) -- remove +
			WHEN SUBSTR(perc_chg_week,1,1) = '-' THEN SUBSTR(perc_chg_week,1,LENGTH(perc_chg_week)-1) -- 
			ELSE perc_chg_week
		END perc_chg_week,
		CASE
			WHEN perc_chg_1mth = 'unch' THEN '0'
			WHEN substr(perc_chg_1mth,1,1) = '+' THEN SUBSTR(perc_chg_1mth,2,LENGTH(perc_chg_1mth)-2) -- remove +
			WHEN SUBSTR(perc_chg_1mth,1,1) = '-' THEN SUBSTR(perc_chg_1mth,1,LENGTH(perc_chg_1mth)-1) -- 
			ELSE perc_chg_1mth
		END perc_chg_1mth,
		CASE
			WHEN perc_chg_3mth = 'unch' THEN '0'
			WHEN substr(perc_chg_3mth,1,1) = '+' THEN SUBSTR(perc_chg_3mth,2,LENGTH(perc_chg_3mth)-2) -- remove +
			WHEN SUBSTR(perc_chg_3mth,1,1) = '-' THEN SUBSTR(perc_chg_3mth,1,LENGTH(perc_chg_3mth)-1) -- 
			ELSE perc_chg_3mth
		END perc_chg_3mth,
		CASE
			WHEN perc_chg_6mth = 'unch' THEN '0'
			WHEN substr(perc_chg_6mth,1,1) = '+' THEN SUBSTR(perc_chg_6mth,2,LENGTH(perc_chg_6mth)-2) -- remove +
			WHEN SUBSTR(perc_chg_6mth,1,1) = '-' THEN SUBSTR(perc_chg_6mth,1,LENGTH(perc_chg_year)-1) -- 
			ELSE perc_chg_6mth
		END perc_chg_6mth,
		CASE
			WHEN perc_chg_year = 'unch' THEN '0'
			WHEN substr(perc_chg_year,1,1) = '+' THEN SUBSTR(perc_chg_year,2,LENGTH(perc_chg_year)-2) -- remove +
			WHEN SUBSTR(perc_chg_year,1,1) = '-' THEN SUBSTR(perc_chg_year,1,LENGTH(perc_chg_year)-1) -- 
			ELSE perc_chg_year
		END perc_chg_year
		FROM stg;

EOF

done