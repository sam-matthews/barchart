CREATE OR REPLACE FUNCTION load_stg_table(f_csv_file IN VARCHAR, f_stg_file_date IN DATE) RETURNS VOID AS $$

/*

	Find proper staging table and load data from staging table into Atomic table.

*/

DECLARE

  ref       RECORD;
  stg_table CHAR(20);

BEGIN

  -- Check and insert current CSV file into CSVFILE lookup table.
  RAISE NOTICE 'STEP 1. Check stage file being loaded is in stg_file_type.';
  INSERT INTO stg_file_type SELECT f_csv_file, 'stg1' FROM stg_file_type WHERE csv_file NOT IN (f_csv_file);

  SELECT stg_file INTO stg_table FROM stg_file_type WHERE csv_file = f_csv_file;
  
  -- INSERT INTO ATOMIC TABLE.
  
  CASE stg_table
    WHEN 'stg1' THEN

      RAISE NOTICE 'STARTING CASE STATEMENT FOR STG1 TABLE';
      INSERT INTO barchart_data
      SELECT symbol, f_stg_file_date, last_price,
      CASE 
        WHEN wtd_alpha = 'unch' THEN '0'
        WHEN wtd_alpha = 'N/A' then '0' 
        WHEN substr(wtd_alpha,1,1) = '+' THEN SUBSTR(wtd_alpha,2,LENGTH(wtd_alpha)-1) 
        ELSE wtd_alpha 
      END wtd_alpha,
      CASE
        WHEN chg_1d = 'unch' THEN '0'
        WHEN chg_1d = 'N/A' THEN '0'
        WHEN substr(chg_1d,1,1) = '+' THEN SUBSTR(chg_1d,2,LENGTH(chg_1d)-2)
        WHEN SUBSTR(chg_1d,1,1) = '-' THEN SUBSTR(chg_1d,1,LENGTH(chg_1d)-1)
        ELSE chg_1d
      END chg_1d,
      CASE
        WHEN chg_5d = 'unch' THEN '0'
        WHEN chg_5d = 'N/A' THEN '0'
        WHEN substr(chg_5d,1,1) = '+' THEN SUBSTR(chg_5d,2,LENGTH(chg_5d)-2) -- remove +
        WHEN SUBSTR(chg_5d,1,1) = '-' THEN SUBSTR(chg_5d,1,LENGTH(chg_5d)-1) -- 
        ELSE chg_5d
      END chg_5d,
      CASE
        WHEN chg_1m = 'unch' THEN '0'
        WHEN chg_1m = 'N/A' THEN '0'
        WHEN SUBSTR(chg_1m,1,1) = '+' THEN SUBSTR(chg_1m,2,LENGTH(chg_1m)-2) -- remove +
        WHEN SUBSTR(chg_1m,1,1) = '-' THEN SUBSTR(chg_1m,1,LENGTH(chg_1m)-1) -- 
        ELSE chg_1m
      END chg_1m,
      CASE
        WHEN chg_3m = 'unch' THEN '0'
        WHEN chg_3m = 'N/A' THEN '0'
        WHEN substr(chg_3m,1,1) = '+' THEN SUBSTR(chg_3m,2,LENGTH(chg_3m)-2) -- remove +
        WHEN SUBSTR(chg_3m,1,1) = '-' THEN SUBSTR(chg_3m,1,LENGTH(chg_3m)-1) -- 
        ELSE chg_3m
      END chg_3m,
      CASE
        WHEN chg_6m = 'unch' THEN '0'
        WHEN chg_6m = 'N/A' THEN '0'
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
      FROM stg1
      EXCEPT 
        SELECT 
          symbol, 
          data_date, 
          last_price, 
          weighted_alpha, 
          perc_change_daily, 
          perc_chg_week, 
          perc_chg_1mth, 
          perc_chg_3mth, 
          perc_chg_6mth, 
          perc_chg_year
      FROM barchart_data;

    WHEN 'stg2' THEN
      
      INSERT INTO barchart_data
      SELECT symbol, f_stg_file_date, last_price,
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
      FROM stg2
      EXCEPT 
        SELECT 
          symbol, 
          data_date, 
          last_price, 
          weighted_alpha, 
          perc_change_daily, 
          perc_chg_week, 
          perc_chg_1mth, 
          perc_chg_3mth, 
          perc_chg_6mth, 
          perc_chg_year
      FROM barchart_data;

WHEN 'stg3' THEN
      
      INSERT INTO barchart_data
      SELECT symbol, f_stg_file_date, '0',
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
      FROM stg3
      EXCEPT 
        SELECT 
          symbol, 
          data_date, 
          last_price, 
          weighted_alpha, 
          perc_change_daily, 
          perc_chg_week, 
          perc_chg_1mth, 
          perc_chg_3mth, 
          perc_chg_6mth, 
          perc_chg_year
      FROM barchart_data;

    WHEN 'stg4' THEN
      
      INSERT INTO barchart_data
      SELECT symbol, f_stg_file_date, last_price,
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
      FROM stg4
      EXCEPT 
        SELECT 
          symbol, 
          data_date, 
          last_price, 
          weighted_alpha, 
          perc_change_daily, 
          perc_chg_week, 
          perc_chg_1mth, 
          perc_chg_3mth, 
          perc_chg_6mth, 
          perc_chg_year
      FROM barchart_data;

    ELSE RAISE NOTICE 'STG TABLE DOES NOT EXIST.';
  END CASE;

END; $$

LANGUAGE plpgsql;
