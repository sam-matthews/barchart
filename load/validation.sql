/*
	validate.sql
	Script to validate load script.
	29th November 2020

	Sam Matthews

	- Add validate to check if duplicate rows.
	
*/



-- If there are any records returned then investigate.

SELECT symbol, data_date FROM barchart_data GROUP BY symbol, data_date HAVING COUNT(*) > 1;

