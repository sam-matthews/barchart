#!/bin/bash

# load.sh
# Sam Matthews
# 26th October 2020

START_DIR=${HOME}/Desktop/barchart/CSV

# for LONG_FILE in `ls -1 ${START_DIR}/*06-[0-3][0-9]-2020*.csv`
for LONG_FILE in `ls -1 ${START_DIR}/*09-01-2020*.csv`
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

		TRUNCATE TABLE stg_20200604;

		-- INSERT INTO STG Table.
		\copy stg_20200604 from $LONG_FILE DELIMITER ',' CSV HEADER

		-- INSERT INTO ATOMIC TABLE.
		INSERT INTO barchart_data
		SELECT symbol, '$CURR_DATE', '0',
		CASE 
			WHEN wtd_alpha = 'unch' THEN '0'
			WHEN wtd_alpha = 'N/A' then '0' 
			WHEN substr(wtd_alpha,1,1) = '+' THEN SUBSTR(wtd_alpha,2,LENGTH(wtd_alpha)-1) 
			ELSE wtd_alpha 
		END wtd_alpha,
		CASE
			WHEN chg_1d = 'unch' THEN '0'
			WHEN substr(chg_1d,1,1) = '+' THEN SUBSTR(chg_1d,2,LENGTH(chg_1d)-2)
			WHEN SUBSTR(chg_1d,1,1) = '-' THEN SUBSTR(chg_1d,1,LENGTH(chg_1d)-1)
			ELSE chg_1d
		END chg_1d,
		CASE
			WHEN chg_5d = 'unch' THEN '0'
			WHEN substr(chg_5d,1,1) = '+' THEN SUBSTR(chg_5d,2,LENGTH(chg_5d)-2) -- remove +
			WHEN SUBSTR(chg_5d,1,1) = '-' THEN SUBSTR(chg_5d,1,LENGTH(chg_5d)-1) -- 
			ELSE chg_5d
		END chg_5d,
		CASE
			WHEN chg_1m = 'unch' THEN '0'
			WHEN substr(chg_1m,1,1) = '+' THEN SUBSTR(chg_1m,2,LENGTH(chg_1m)-2) -- remove +
			WHEN SUBSTR(chg_1m,1,1) = '-' THEN SUBSTR(chg_1m,1,LENGTH(chg_1m)-1) -- 
			ELSE chg_1m
		END chg_1m,
		CASE
			WHEN chg_3m = 'unch' THEN '0'
			WHEN substr(chg_3m,1,1) = '+' THEN SUBSTR(chg_3m,2,LENGTH(chg_3m)-2) -- remove +
			WHEN SUBSTR(chg_3m,1,1) = '-' THEN SUBSTR(chg_3m,1,LENGTH(chg_3m)-1) -- 
			ELSE chg_3m
		END chg_3m,
		CASE
			WHEN chg_6m = 'unch' THEN '0'
			WHEN substr(chg_6m,1,1) = '+' THEN SUBSTR(chg_6m,2,LENGTH(chg_6m)-2) -- remove +
			WHEN SUBSTR(chg_6m,1,1) = '-' THEN SUBSTR(chg_6m,1,LENGTH(chg_6m)-1) -- 
			ELSE chg_6m
		END chg_6m,
		CASE
			WHEN chg_12m = 'unch' THEN '0'
			WHEN substr(chg_12m,1,1) = '+' THEN SUBSTR(chg_12m,2,LENGTH(chg_12m)-2) -- remove +
			WHEN SUBSTR(chg_12m,1,1) = '-' THEN SUBSTR(chg_12m,1,LENGTH(chg_12m)-1) -- 
			ELSE chg_12m
		END chg_12m
		FROM stg_20200604
		EXCEPT 
			SELECT symbol, data_date, last_price, weighted_alpha, perc_change_daily, perc_chg_week, perc_chg_1mth, perc_chg_3mth, perc_chg_6mth, perc_chg_year
		 	FROM barchart_data
		;

EOF

done