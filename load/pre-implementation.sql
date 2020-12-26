/*

	pre-implementation.sql
	Sam Matthews
	25th November 2020

	SQL commands to run before main script is run.
*/

DELETE FROM barchart_data WHERE data_date > '2020-10-01'; 
