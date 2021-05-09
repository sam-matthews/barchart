CREATE OR REPLACE FUNCTION calculate_running_total(
  f_ret_strategy IN VARCHAR,
  f_ret_type IN VARCHAR,
  f_ret_period IN INTEGER)
RETURNS VOID AS $$

/*

  Calculate running total

*/


DECLARE

  ref                 RECORD;
  start_running_total INTEGER := 1;
  loop_counter        INTEGER := 1;
  
  curr_running_total  DECIMAL;
  prev_running_total  DECIMAL;

  curr_return         DECIMAL;

BEGIN

  curr_running_total := start_running_total;

  FOR ref IN 
    SELECT curr_date, ret_strategy, ret_type, ret_period, current_return::decimal/100 AS current_return 
    FROM summary_return_average 
    WHERE 1=1
      AND ret_strategy = f_ret_strategy 
      AND ret_type = f_ret_type
      AND ret_period::integer = f_ret_period
      -- AND curr_date BETWEEN '2020-09-30' AND '2020-12-31'
    ORDER BY curr_date 
  LOOP
    
    prev_running_total := curr_running_total;
    curr_return := ref.current_return;

    IF (loop_counter = 1) THEN
      
      curr_running_total = ROUND((1 + ref.current_return::decimal),4);

    ELSE
      
      curr_running_total := ROUND((prev_running_total * (1 + ref.current_return::decimal)),4); 
    
    END IF;

    RAISE NOTICE 'LOOP: %', loop_counter;
    RAISE NOTICE 'DATE: %', ref.curr_date;
    RAISE NOTICE 'REF.CURRENT_RETURN: %', ref.current_return;
    RAISE NOTICE 'current running total: %', curr_running_total;

    UPDATE summary_return_average SET running_total = curr_running_total 
    WHERE 1=1 
      AND curr_date = ref.curr_date 
      AND ret_strategy = f_ret_strategy
      AND ret_type = f_ret_type
      AND ret_period::integer = f_ret_period; 

    loop_counter := loop_counter + 1;
  
  END LOOP;

END;

$$ LANGUAGE plpgsql;
