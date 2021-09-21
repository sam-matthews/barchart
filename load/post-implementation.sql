-- Update perc_chg_week
UPDATE barchart_data SET perc_chg_week = SUBSTR(perc_chg_week,1,6) WHERE SUBSTR(perc_chg_week,5,1) = '%';
UPDATE barchart_data SET perc_chg_week = SUBSTR(perc_chg_week,1,7) WHERE SUBSTR(perc_chg_week,6,1) = '%';
UPDATE barchart_data SET perc_chg_week = SUBSTR(perc_chg_week,1,8) WHERE SUBSTR(perc_chg_week,7,1) = '%';

-- Update perc_chg_1mth
UPDATE barchart_data SET perc_chg_1mth = SUBSTR(perc_chg_1mth,1,4) WHERE SUBSTR(perc_chg_1mth,5,1) = '%';
UPDATE barchart_data SET perc_chg_1mth = SUBSTR(perc_chg_1mth,1,5) WHERE SUBSTR(perc_chg_1mth,6,1) = '%';
UPDATE barchart_data SET perc_chg_1mth = SUBSTR(perc_chg_1mth,1,6) WHERE SUBSTR(perc_chg_1mth,7,1) = '%';

UPDATE barchart_data SET perc_change_daily = SUBSTR(perc_change_daily,1,4) WHERE SUBSTR(perc_change_daily,5,1) = '%';
UPDATE barchart_data SET perc_change_daily = SUBSTR(perc_change_daily,1,5) WHERE SUBSTR(perc_change_daily,6,1) = '%';
UPDATE barchart_data SET perc_change_daily = SUBSTR(perc_change_daily,1,6) WHERE SUBSTR(perc_change_daily,7,1) = '%';

UPDATE barchart_data SET perc_change_daily = SUBSTR(perc_change_daily,1,1) || SUBSTR(perc_change_daily,3,6) 
WHERE SUBSTR(perc_change_daily,2,1) = ',';

UPDATE barchart_data SET perc_chg_3mth = SUBSTR(perc_chg_3mth,1,4) WHERE SUBSTR(perc_chg_3mth,5,1) = '%';
UPDATE barchart_data SET perc_chg_3mth = SUBSTR(perc_chg_3mth,1,5) WHERE SUBSTR(perc_chg_3mth,6,1) = '%';
UPDATE barchart_data SET perc_chg_3mth = SUBSTR(perc_chg_3mth,1,6) WHERE SUBSTR(perc_chg_3mth,7,1) = '%';

-- 3 MTH Updates

UPDATE barchart_data 
SET perc_chg_3mth = SUBSTR(perc_chg_3mth,1,1) || SUBSTR(perc_chg_3mth,3,6)
WHERE SUBSTR(perc_chg_3mth,2,1) = ',';

UPDATE barchart_data SET perc_chg_3mth = 0 WHERE perc_chg_3mth LIKE 'N/A%';

UPDATE barchart_data SET perc_chg_3mth = SUBSTR(perc_chg_3mth,1,1) || SUBSTR(perc_chg_3mth,3,6) 
WHERE SUBSTR(perc_chg_3mth,2,1) = ',';

-- Weighted Alpha Updates
UPDATE barchart_data SET weighted_alpha = SUBSTR(weighted_alpha,1,4) WHERE SUBSTR(weighted_alpha,5,1) = '%';
UPDATE barchart_data SET weighted_alpha = SUBSTR(weighted_alpha,1,5) WHERE SUBSTR(weighted_alpha,6,1) = '%';
UPDATE barchart_data SET weighted_alpha = SUBSTR(weighted_alpha,1,6) WHERE SUBSTR(weighted_alpha,7,1) = '%';
UPDATE barchart_data SET weighted_alpha = SUBSTR(weighted_alpha,1,2) || SUBSTR(weighted_alpha,4,6) WHERE SUBSTR(weighted_alpha,3,1) = ',';
UPDATE barchart_data SET weighted_alpha = SUBSTR(weighted_alpha,1,1) || SUBSTR(weighted_alpha,3,6) WHERE SUBSTR(weighted_alpha,2,1) = ',';


-- 6MTH UPDATES
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,6) WHERE SUBSTR(perc_chg_6mth,7,1) = '%';
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,7) WHERE SUBSTR(perc_chg_6mth,8,1) = '%';
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,5) WHERE SUBSTR(perc_chg_6mth,6,1) = '%';
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,4) WHERE SUBSTR(perc_chg_6mth,5,1) = '%';
UPDATE barchart_data SET perc_chg_6mth = SUBSTR(perc_chg_6mth,1,1) || SUBSTR(perc_chg_6mth,3,6) WHERE SUBSTR(perc_chg_6mth,2,1) = ',';


-- Year Updates
UPDATE barchart_data SET perc_chg_year = SUBSTR(perc_chg_year,1,4) WHERE SUBSTR(perc_chg_year,5,1) = '%';
UPDATE barchart_data SET perc_chg_year = SUBSTR(perc_chg_year,1,5) WHERE SUBSTR(perc_chg_year,6,1) = '%';
UPDATE barchart_data SET perc_chg_year = SUBSTR(perc_chg_year,1,6) WHERE SUBSTR(perc_chg_year,7,1) = '%';
UPDATE barchart_data SET perc_chg_year = SUBSTR(perc_chg_year,1,7) WHERE SUBSTR(perc_chg_year,8,1) = '%';
UPDATE barchart_data SET perc_chg_year = SUBSTR(perc_chg_year,1,8) WHERE SUBSTR(perc_chg_year,9,1) = '%';
UPDATE barchart_data SET perc_chg_year = SUBSTR(perc_chg_year,1,1) || SUBSTR(perc_chg_year,3,6) WHERE SUBSTR(perc_chg_year,2,1) = ',';
UPDATE barchart_data SET perc_chg_year = SUBSTR(perc_chg_year,1,2) || SUBSTR(perc_chg_year,4,7) WHERE SUBSTR(perc_chg_year,3,1) = ',';


--Update the lookup tables for dates.
TRUNCATE TABLE lkp_dates;
INSERT INTO lkp_dates 
	SELECT LAG(data_date,1) OVER (ORDER BY data_date ASC) AS prev_date, data_date 
	FROM barchart_data 
	WHERE symbol = 'TSLA';

-- Remove stocks originally loaded from staging CSV files. I have found that these stocks do not actually exist in Hatch and Stake.
DELETE FROM barchart_data WHERE symbol IN (
	'ERI',
	'TVIX',
	'RTN',
	'BGG',
	'GME',
	'AMC');

-- Calculate weighted_alpha and 3-mth strategies for day and week, 1-10 stocks.
SELECT FROM ret_3mth('day',1);
SELECT FROM ret_3mth('day',2);
SELECT FROM ret_3mth('day',3);
SELECT FROM ret_3mth('day',4);
SELECT FROM ret_3mth('day',5);
SELECT FROM ret_3mth('day',6);
SELECT FROM ret_3mth('day',7);
SELECT FROM ret_3mth('day',8);
SELECT FROM ret_3mth('day',9);
SELECT FROM ret_3mth('day',10);

SELECT FROM ret_3mth('week',1);
SELECT FROM ret_3mth('week',2);
SELECT FROM ret_3mth('week',3);
SELECT FROM ret_3mth('week',4);
SELECT FROM ret_3mth('week',5);
SELECT FROM ret_3mth('week',6);
SELECT FROM ret_3mth('week',7);
SELECT FROM ret_3mth('week',8);
SELECT FROM ret_3mth('week',9);
SELECT FROM ret_3mth('week',10);

SELECT FROM ret_3mth('2week',1);
SELECT FROM ret_3mth('2week',2);
SELECT FROM ret_3mth('2week',3);
SELECT FROM ret_3mth('2week',4);
SELECT FROM ret_3mth('2week',5);
SELECT FROM ret_3mth('2week',6);
SELECT FROM ret_3mth('2week',7);
SELECT FROM ret_3mth('2week',8);
SELECT FROM ret_3mth('2week',9);
SELECT FROM ret_3mth('2week',10);

SELECT FROM ret_3mth('month',1);
SELECT FROM ret_3mth('month',2);
SELECT FROM ret_3mth('month',3);
SELECT FROM ret_3mth('month',4);
SELECT FROM ret_3mth('month',5);
SELECT FROM ret_3mth('month',6);
SELECT FROM ret_3mth('month',7);
SELECT FROM ret_3mth('month',8);
SELECT FROM ret_3mth('month',9);
SELECT FROM ret_3mth('month',10);

SELECT FROM ret_3mth('2month',1);
SELECT FROM ret_3mth('2month',2);
SELECT FROM ret_3mth('2month',3);
SELECT FROM ret_3mth('2month',4);
SELECT FROM ret_3mth('2month',5);
SELECT FROM ret_3mth('2month',6);
SELECT FROM ret_3mth('2month',7);
SELECT FROM ret_3mth('2month',8);
SELECT FROM ret_3mth('2month',9);
SELECT FROM ret_3mth('2month',10);

SELECT FROM ret_weighted_alpha('day',1);
SELECT FROM ret_weighted_alpha('day',2);
SELECT FROM ret_weighted_alpha('day',3);
SELECT FROM ret_weighted_alpha('day',4);
SELECT FROM ret_weighted_alpha('day',5);
SELECT FROM ret_weighted_alpha('day',6);
SELECT FROM ret_weighted_alpha('day',7);
SELECT FROM ret_weighted_alpha('day',8);
SELECT FROM ret_weighted_alpha('day',9);
SELECT FROM ret_weighted_alpha('day',10);

SELECT FROM ret_weighted_alpha('week',1);
SELECT FROM ret_weighted_alpha('week',2);
SELECT FROM ret_weighted_alpha('week',3);
SELECT FROM ret_weighted_alpha('week',4);
SELECT FROM ret_weighted_alpha('week',5);
SELECT FROM ret_weighted_alpha('week',6);
SELECT FROM ret_weighted_alpha('week',7);
SELECT FROM ret_weighted_alpha('week',8);
SELECT FROM ret_weighted_alpha('week',9);
SELECT FROM ret_weighted_alpha('week',10);

SELECT FROM ret_weighted_alpha('month',1);
SELECT FROM ret_weighted_alpha('month',2);
SELECT FROM ret_weighted_alpha('month',3);
SELECT FROM ret_weighted_alpha('month',4);
SELECT FROM ret_weighted_alpha('month',5);
SELECT FROM ret_weighted_alpha('month',6);
SELECT FROM ret_weighted_alpha('month',7);
SELECT FROM ret_weighted_alpha('month',8);
SELECT FROM ret_weighted_alpha('month',9);
SELECT FROM ret_weighted_alpha('month',10);