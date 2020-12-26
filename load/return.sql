/*
return.sql
Sam Matthews
10th December 2020

Return the latest expected profit for the last growth sql run.

*/

SELECT curr_date, ROUND(AVG(chg_1d::decimal),4)/100 "Return" 
FROM ret_one_day 
GROUP BY curr_date 
-- ORDER BY curr_date DESC LIMIT 10;
ORDER BY curr_date;