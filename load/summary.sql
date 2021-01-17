-- summary.sql
-- Sam Matthews
-- 12th January 2021

-- Display summary of calculated revenue, currently in total, 
-- but eventually will look at rolling 12 months.

-- Below crosstab function is used. This essentially is translating multiple rols into columns.

\echo '3-MTH DAILY'

SELECT a.* FROM (SELECT * FROM CROSSTAB('
    SELECT curr_date, ret_period, ROUND((running_total::decimal),4) 
    FROM summary_return_average 
    WHERE ret_strategy = ''3-mth'' 
      AND ret_type = ''day'' 
    ORDER BY curr_date DESC, ret_period::integer')
    AS summary_return_average(
        curr_date date, 
        period1 decimal, 
        period2 decimal, 
        period3 decimal, 
        period4 decimal,
        period5 decimal,
        period6 decimal,
        period7 decimal,
        period8 decimal,
        period9 decimal,
        period10 decimal)) a
ORDER BY a.curr_date DESC LIMIT 1
 ;    

\echo 'Weighted ALpha DAILY'

SELECT a.* FROM (SELECT * FROM CROSSTAB('
    SELECT curr_date, ret_period, ROUND((running_total::decimal),4) 
    FROM summary_return_average 
    WHERE ret_strategy = ''weighted_alpha'' 
      AND ret_type = ''day'' 
    ORDER BY curr_date DESC, ret_period::integer')
    AS summary_return_average(
        curr_date date, 
        period1 decimal, 
        period2 decimal, 
        period3 decimal, 
        period4 decimal,
        period5 decimal,
        period6 decimal,
        period7 decimal,
        period8 decimal,
        period9 decimal,
        period10 decimal)) a
ORDER BY a.curr_date DESC LIMIT 1
 ;    

\echo '3-MTH WEEK'

SELECT a.* FROM (SELECT * FROM CROSSTAB('
    SELECT curr_date, ret_period, ROUND((running_total::decimal),4) 
    FROM summary_return_average 
    WHERE ret_strategy = ''3-mth'' 
      AND ret_type = ''week'' 
    ORDER BY curr_date DESC, ret_period::integer')
    AS summary_return_average(
        curr_date date, 
        period1 decimal, 
        period2 decimal, 
        period3 decimal, 
        period4 decimal,
        period5 decimal,
        period6 decimal,
        period7 decimal,
        period8 decimal,
        period9 decimal,
        period10 decimal)) a
ORDER BY a.curr_date DESC LIMIT 1
 ;    

\echo 'Weighted Alpha WEEK'

SELECT a.* FROM (SELECT * FROM CROSSTAB('
    SELECT curr_date, ret_period, ROUND((running_total::decimal),4) 
    FROM summary_return_average 
    WHERE ret_strategy = ''weighted_alpha'' 
      AND ret_type = ''week'' 
    ORDER BY curr_date DESC, ret_period::integer')
    AS summary_return_average(
        curr_date date, 
        period1 decimal, 
        period2 decimal, 
        period3 decimal, 
        period4 decimal,
        period5 decimal,
        period6 decimal,
        period7 decimal,
        period8 decimal,
        period9 decimal,
        period10 decimal)) a
ORDER BY a.curr_date DESC LIMIT 1
 ;    
