-- tables.sql
-- Create tables for Barchart application.
-- Sam Matthews
-- 29th October 2020.

-- Create some external tables.
CREATE EXTENTION file_fdw;
CREATE SERVER srv_file_fdw FOREIGN DATA WRAPPER file_fdw;



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
	OPTIONS ( filename '/Users/sam/Desktop/barchart/CSV/barchart-data-to-load.csv', FORMAT 'csv', HEADER 'true')
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
	OPTIONS ( filename '/Users/sam/Desktop/barchart/CSV/barchart-data-to-load.csv', FORMAT 'csv', HEADER 'true')
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
OPTIONS ( filename '/Users/sam/Desktop/barchart/CSV/barchart-data-to-load.csv', FORMAT 'csv', HEADER 'true')
;

-- stg_file_type
-- Holds information relating to what CSV file should use what foreign table.
DROP TABLE stg_file_type;
CREATE TABLE stg_file_type (
	csv_file	CHAR(20),
	stg_file 	CHAR(20)
);	

CREATE INDEX stg_file_type_n1 ON stg_file_type(csv_file);


DROP TABLE stg CASCADE;
CREATE TABLE stg (
	symbol 			CHAR(10),
	last_price	CHAR(10),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d			CHAR(15),
	chg_1m			CHAR(15),
	chg_3m			CHAR(15),
	chg_6m			CHAR(15),
	chg_12m			CHAR(15)
);
	

DROP TABLE stg1 CASCADE;
CREATE TABLE stg1 (
	symbol 			CHAR(10),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d			CHAR(15),
	trend 			CHAR(10),
	trend_str		CHAR(10),
	trend_dir 	CHAR(20),
	chg_1m			CHAR(15),
	chg_3m			CHAR(15),
	chg_6m			CHAR(15),
	chg_9m			CHAR(15),
	chg_12m			CHAR(15),
	highs_1m		CHAR(10),
	last_price	CHAR(10)
);

DROP TABLE stg_20200212;
CREATE TABLE stg_20200212 (
	symbol 		CHAR(15),
	wtd_alpha 	CHAR(15),
	chg_1d    	CHAR(15),
	chg_5d		CHAR(15),
	trend   	CHAR(15),
	trend_str 	CHAR(15),
	trend_dir 	CHAR(15),
	chg_1m		CHAR(15),
	chg_3m		CHAR(15),
	chg_6m		CHAR(15),
	chg_9m		CHAR(15),
	chg_12m		CHAR(15),
	high_1m  	CHAR(15),
	last_price	CHAR(15)
);

DROP TABLE stg_20200601;
CREATE TABLE stg_20200601 (
	symbol 			CHAR(10),
	prev_price  CHAR(15),
	last_price	CHAR(15),
	chg_1d    	CHAR(15),
	chg_5d		CHAR(15),
	wtd_alpha 	CHAR(10),
	chg_1m		CHAR(15),
	chg_3m		CHAR(15),
	chg_6m		CHAR(15),
	chg_12m		CHAR(15),
	high_1m  	CHAR(10),
	high_3m  	CHAR(10),
	high_6m  	CHAR(10),
	high_12m  	CHAR(10)
);

DROP TABLE stg_20200604;
CREATE TABLE stg_20200604 (
	symbol 		CHAR(10),
	stock_name  CHAR(100),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d		CHAR(15),
	chg_1m		CHAR(15),
	chg_3m		CHAR(15),
	chg_6m		CHAR(15),
	chg_12m		CHAR(15),
	ma_20d    	CHAR(10)
);

DROP TABLE stg_20200701;
CREATE TABLE stg_20200604 (
	symbol 		CHAR(10),
	stock_name  CHAR(100),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d		CHAR(15),
	chg_1m		CHAR(15),
	high_1m 	CHAR(10),
	chg_3m		CHAR(15),
	chg_6m		CHAR(15),
	chg_12m		CHAR(15),
	ma_20d    	CHAR(10)
);

DROP TABLE stg_20200901;
CREATE TABLE stg_20200901 (
	symbol 			CHAR(10),
	stock_name  CHAR(100),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	last_price  CHAR(15),
	ma_20d    	CHAR(10),
	rsi_14d     CHAR(10),
	chg_5d			CHAR(15),
	chg_1m			CHAR(15),
	chg_3m			CHAR(15),
	chg_6m			CHAR(15),
	chg_12m			CHAR(15)
);

DROP TABLE stg_20200909;
CREATE TABLE stg_20200909 (
	symbol 			CHAR(10),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	last_price  CHAR(15),
	ma_20d    	CHAR(10),
	ma_50d      CHAR(10),
	chg_5d			CHAR(15),
	chg_1m			CHAR(15),
	chg_3m			CHAR(15),
	chg_6m			CHAR(15),
	chg_12m			CHAR(15)
);

DROP TABLE stg_20200917;
CREATE TABLE stg_20200917 (
	symbol 			CHAR(10),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	last_price  CHAR(15),
	ma_20d    	CHAR(10),
	ma_5d     	CHAR(10),
	ma_50d    	CHAR(10),
	chg_5d			CHAR(15),
	chg_1m			CHAR(15),
	chg_3m			CHAR(15),
	chg_6m			CHAR(15),
	chg_12m			CHAR(15)
);

DROP TABLE stg_20201002;
CREATE TABLE stg_20201002 (
	symbol 			CHAR(10),
	last_price  CHAR(15),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d			CHAR(15),
	chg_1m			CHAR(15),
	chg_3m			CHAR(15),
	chg_6m			CHAR(15),
	chg_12m			CHAR(15)
);

DROP TABLE stg2 CASCADE;
CREATE TABLE stg2 (
	symbol 			CHAR(10),
	stock_name  CHAR(100),
	wtd_alpha 	CHAR(10),
	chg_1d    	CHAR(15),
	chg_5d			CHAR(15),
	chg_1m			CHAR(15),
	chg_3m			CHAR(15),
	chg_6m			CHAR(15),
	chg_12m			CHAR(15),
	ma_20d  		CHAR(10)
);

DROP TABLE summary;
CREATE TABLE summary(
  symbol		CHAR(10),
  curr_date		DATE,
  ret_strategy  CHAR(20),
  ret_type      CHAR(10),
  ret_period    CHAR(10),
  chg_1d		CHAR(10)
);

CREATE TABLE ret_one_day(
  symbol  		CHAR(10),
  curr_date 	DATE,
  wtd_alpha 	CHAR(10),
  chg_1d    	CHAR(10),
  perc_chg_3mth CHAR(10)
);

CREATE TABLE ret_one_week(
  symbol  	CHAR(10),
  curr_date DATE,
  wtd_alpha CHAR(10),
  chg_1d    CHAR(10)
);



CREATE TABLE tmp_stocks_to_invest(
	symbol CHAR(10)
);

