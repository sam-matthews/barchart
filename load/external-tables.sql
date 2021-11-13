-- Create as superuser such as postgres user.
-- Created for entire cluster.
CREATE EXTENSION file_fdw;

CREATE SERVER srv_file_fdw FOREIGN DATA WRAPPER file_fdw;

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

DROP FOREIGN TABLE stg2;
CREATE FOREIGN TABLE stg2 (
	symbol 		CHAR(10),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d		CHAR(15),
	trend 		CHAR(20),
	trend_str	CHAR(20),
	trend_dir	CHAR(20),
	chg_1m		CHAR(15),
	chg_3m		CHAR(15),
	chg_6m		CHAR(15),
	chg_9m		CHAR(15),
	chg_12m		CHAR(15),
	high_1m 	CHAR(10),
	last_price	CHAR(10)
) 
	SERVER srv_file_fdw 
	OPTIONS ( filename '/Users/sam/dev/data/barchart/csv/barchart-data-to-load.csv', FORMAT 'csv', HEADER 'true')
;

DROP FOREIGN TABLE stg3;
CREATE FOREIGN TABLE stg3 (
	symbol 		CHAR(10),
	symbol_name CHAR(500),
	wtd_alpha	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d		CHAR(15),
	chg_1m		CHAR(15),
	highs_1m	CHAR(10),
	chg_3m		CHAR(15),
	chg_6m		CHAR(15),
	chg_12m		CHAR(15),
	ma_20d		CHAR(10)
) 
	SERVER srv_file_fdw 
	OPTIONS ( filename '/Users/sam/dev/data/barchart/csv/barchart-data-to-load.csv', FORMAT 'csv', HEADER 'true')
;

DROP FOREIGN TABLE stg4;
CREATE FOREIGN TABLE stg4 (
	symbol		CHAR(10),
	last_price 	CHAR(10),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d		CHAR(15),
	chg_1m		CHAR(15),
	chg_3m		CHAR(15),
	chg_6m		CHAR(15),
	chg_9m		CHAR(15),
	chg_12m		CHAR(15)
) 
SERVER srv_file_fdw 
OPTIONS ( filename '/Users/sam/dev/data/barchart/csv/barchart-data-to-load.csv', FORMAT 'csv', HEADER 'true')
;
