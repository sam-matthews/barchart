
UPDATE barchart_data
SET perc_chg_1mth = SUBSTR(perc_chg_1mth,1,4)
WHERE SUBSTR(perc_chg_1mth,5,1) = '%';

UPDATE barchart_data 
SET perc_chg_1mth = SUBSTR(perc_chg_1mth,1,5)
WHERE SUBSTR(perc_chg_1mth,6,1) = '%';

UPDATE barchart_data 
SET perc_chg_1mth = SUBSTR(perc_chg_1mth,1,6)
WHERE SUBSTR(perc_chg_1mth,7,1) = '%';

UPDATE barchart_data 
SET perc_chg_3mth = SUBSTR(perc_chg_3mth,1,1) || SUBSTR(perc_chg_3mth,3,6)
WHERE SUBSTR(perc_chg_3mth,2,1) = ',';

-- 6MTH UPDATES
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,6) WHERE SUBSTR(perc_chg_6mth,7,1) = '%';
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,7) WHERE SUBSTR(perc_chg_6mth,8,1) = '%';
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,5) WHERE SUBSTR(perc_chg_6mth,6,1) = '%';
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,4) WHERE SUBSTR(perc_chg_6mth,5,1) = '%';
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,1) || SUBSTR(perc_chg_6mth,3,6) WHERE SUBSTR(perc_chg_6mth,2,1) = ',';

--Update the lookup tables for dates.
TRUNCATE TABLE lkp_dates;
INSERT INTO lkp_dates 
	SELECT LAG(data_date,1) OVER (ORDER BY data_date ASC) AS prev_date, data_date 
	FROM barchart_data 
	WHERE symbol = 'ZM';

-- Remove stocks originally loaded from staging CSV files. I have found that these stocks do not actually exist in Hatch and Stake.
DELETE FROM barchart_data WHERE symbol IN ('ERI');

