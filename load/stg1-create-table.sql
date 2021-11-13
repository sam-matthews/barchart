DROP FOREIGN TABLE stg1;
CREATE FOREIGN TABLE stg1 (
	symbol 		CHAR(10),
	last_price	CHAR(10),
    wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d		CHAR(15),
	chg_1m		CHAR(15),
	chg_3m		CHAR(15),
	chg_6m		CHAR(15),
	chg_12m		CHAR(15)
)
SERVER srv_file_fdw 
OPTIONS ( 
	filename '/Users/sam/dev/data/barchart/csv/barchart-data-to-load.csv', 
	FORMAT 'csv', 
	HEADER 'true'
)
;