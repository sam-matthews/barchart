CREATE OR REPLACE FUNCTION ret_1mth(dur_type IN VARCHAR, stocks_to_choose IN INTEGER) RETURNS VOID AS $$

/*

	analyze_type is one of the characterisics we use. Currently weighted_alpha or perc_chg_3mth.
	dur_type is changing the list of stocks, daily or weekly.
    STOCKS_TO_CHOOSE : Number of stocks to choose from.
*/


DECLARE

  ref   RECORD;
  date_start DATE := '12-02-2020';
  date_stop  DATE := '31-12-2021';

  f_ret_strategy CHAR(10) := '1-mth';

  day_of_week INTEGER;

BEGIN

    raise notice 'Duration Type: %', dur_type;
    raise notice 'Number of Stocks: %', stocks_to_choose;

    DELETE FROM summary 
    WHERE 1=1
      AND ret_strategy = f_ret_strategy 
      AND ret_type = dur_type 
      AND ret_period::integer = stocks_to_choose;

    FOR ref IN SELECT * FROM lkp_dates WHERE prev_date BETWEEN date_start AND date_stop ORDER BY 1 LOOP
  	
		day_of_week = date_part('dow', ref.prev_date);
		raise notice 'Day of Week: %', day_of_week;

		-- Determine what stocks should be invested.
		IF (dur_type = 'week' AND day_of_week = 5) THEN
		
			raise notice 'Updating stocks for the week.';
		
			TRUNCATE TABLE tmp_stocks_to_invest;

			INSERT INTO tmp_stocks_to_invest 
  			SELECT symbol 
  			FROM barchart_data 
  			WHERE 1=1
  	  	  	  AND data_date = ref.prev_date
			ORDER BY perc_chg_1mth::decimal DESC LIMIT stocks_to_choose;

		ELSIF dur_type = 'day' THEN

			raise notice 'Updating stocks for the day.';
            raise notice 'prev_date: %', ref.prev_date;
	
			TRUNCATE TABLE tmp_stocks_to_invest;

			INSERT INTO tmp_stocks_to_invest 
  			SELECT symbol 
  			FROM barchart_data 
  			WHERE 1=1
  	  	  	  AND data_date = ref.prev_date
			ORDER BY perc_chg_1mth::decimal DESC LIMIT stocks_to_choose;

		END IF;
	
	    -- Insert barchart data into return table.
  	    -- We should be able to query this table to determine over performance of daily changes.
	    raise notice 'Loading data into: %', ref.data_date;

  	    INSERT INTO summary
        SELECT b.symbol, b.data_date, f_ret_strategy, dur_type, stocks_to_choose, b.perc_change_daily 
        FROM barchart_data b 
        WHERE 1=1
          AND b.data_date = ref.data_date 
          AND b.symbol IN (SELECT symbol FROM tmp_stocks_to_invest);

    END LOOP;

    RAISE NOTICE 'Migrating to summary_return_average';

    DELETE FROM summary_return_average 
    WHERE 1=1
        AND ret_strategy = '3-mth' 
        AND ret_type = dur_type 
        AND ret_period::integer = stocks_to_choose;

    INSERT INTO summary_return_average
    SELECT curr_date, ret_strategy, ret_type, ret_period, ROUND(AVG(chg_1d::decimal),4)
    FROM summary
    WHERE 1=1
        AND ret_strategy = '3-mth'
        AND ret_type = dur_type
        AND ret_period::integer = stocks_to_choose
    GROUP BY curr_date, ret_strategy, ret_type, ret_period;

    PERFORM FROM calculate_running_total('3-mth', dur_type, stocks_to_choose);

END;

$$ LANGUAGE plpgsql;
