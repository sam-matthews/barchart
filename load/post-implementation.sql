
UPDATE barchart_data
SET perc_chg_1mth = SUBSTR(perc_chg_1mth,1,4)
WHERE SUBSTR(perc_chg_1mth,5,1) = '%';

UPDATE barchart_data 
SET perc_chg_1mth = SUBSTR(perc_chg_1mth,1,5)
WHERE SUBSTR(perc_chg_1mth,6,1) = '%';

UPDATE barchart_data 
SET perc_chg_1mth = SUBSTR(perc_chg_1mth,1,6)
WHERE SUBSTR(perc_chg_1mth,7,1) = '%';

--Update the lookup tables for dates.
TRUNCATE TABLE lkp_dates;
INSERT INTO lkp_dates 
	SELECT LAG(data_date,1) OVER (ORDER BY data_date ASC) AS prev_date, data_date 
	FROM barchart_data 
	WHERE symbol = 'ZM';

-- Remove stocks originally loaded from staging CSV files. I have found that these stocks do not actually exist in Hatch and Stake.
DELETE FROM barchart_data WHERE symbol IN ('ERI');

