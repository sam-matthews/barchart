-- tables.sql
-- Create tables for Barchart application.
-- Sam Matthews
-- 29th October 2020.

-- stg_file_type
-- Holds information relating to what CSV file should use what foreign table.
DROP TABLE barchart_data;
CREATE TABLE barchart_data (
	symbol				CHAR(20),
	data_date			DATE,
	last_price			CHAR(20),
	weighted_alpha		CHAR(20),
	perc_change_daily	CHAR(20),
	perc_chg_week		CHAR(20),
	perc_chg_1mth		CHAR(20),
	perc_chg_3mth		CHAR(20),
	perc_chg_6mth		CHAR(20),
	perc_chg_year		CHAR(20)
);

DROP TABLE stg_file_type;
CREATE TABLE stg_file_type (
	csv_file	CHAR(50),
	stg_file 	CHAR(10)
);	

CREATE INDEX stg_file_type_n1 ON stg_file_type(csv_file);

DROP TABLE lkp_dates;
CREATE TABLE lkp_dates(
  lkp_prev_date DATE, 
  lkp_data_date DATE
);

DROP TABLE lkp_start_date;
CREATE TABLE lkp_start_date(
  start_date DATE
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

DROP TABLE summary_return_average;
CREATE TABLE summary_return_average(
  curr_date       DATE,
  ret_strategy    CHAR(20),
  ret_type        CHAR(20),
  ret_period      CHAR(20),
  current_return  DECIMAL,
  running_total   CHAR(20)
);

DROP TABLE tmp_stocks_to_invest;
CREATE TABLE tmp_stocks_to_invest(
  symbol  CHAR(10)
);

DROP TABLE ret_one_day;
CREATE TABLE ret_one_day(
  symbol  		CHAR(10),
  curr_date 	DATE,
  wtd_alpha 	CHAR(10),
  chg_1d    	CHAR(10),
  perc_chg_3mth CHAR(10)
);

DROP TABLE ret_one_week;
CREATE TABLE ret_one_week(
  symbol  	CHAR(10),
  curr_date DATE,
  wtd_alpha CHAR(10),
  chg_1d    CHAR(10)
);