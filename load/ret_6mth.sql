CREATE OR REPLACE FUNCTION ret_6mth(dur_type IN VARCHAR) RETURNS VOID AS $$

/*

	analyze_type is one of the characterisics we use. Currently weighted_alpha or perc_chg_3mth.
	dur_type is changing the list of stocks, daily or weekly.
*/


DECLARE

  ref   RECORD;
  date_start DATE := '04-06-2020';
  date_stop  DATE := '31-12-2020';

  day_of_week INTEGER;

BEGIN


  TRUNCATE TABLE ret_one_day;

	FOR ref IN SELECT * FROM lkp_dates WHERE prev_date BETWEEN date_start AND date_stop ORDER BY 1 LOOP

  		-- Grab list of stocks from previous day and insert it into previous table.
		-- This is how we define what stocks we choose. Typically based on some criteria. Weighted Alpha or 1 Moth performance or 1 week performance.
  	
		day_of_week = date_part('dow', ref.prev_date);

		-- Determine what stocks should be invested.
		IF (dur_type = 'week' AND day_of_week = 5) THEN
				
			TRUNCATE TABLE tmp_stocks_to_invest;

			INSERT INTO tmp_stocks_to_invest 
  			SELECT symbol 
  			FROM barchart_data 
  			WHERE 1=1
  	  	  	  AND data_date = ref.prev_date
			ORDER BY perc_chg_6mth::decimal DESC LIMIT 10;

		ELSIF dur_type = 'day' THEN

			TRUNCATE TABLE tmp_stocks_to_invest;

			INSERT INTO tmp_stocks_to_invest 
  			SELECT symbol 
  			FROM barchart_data 
  			WHERE 1=1
  	  	  	  AND data_date = ref.prev_date
			ORDER BY perc_chg_6mth::decimal DESC LIMIT 10;

		END IF;
	
	-- Insert barchart data into return table.
  	-- We should be able to query this table to determine over performance of daily changes.

  	INSERT INTO ret_one_day  
  	SELECT b.symbol, b.data_date, b.weighted_alpha, b.perc_change_daily, b.perc_chg_3mth 
	FROM barchart_data b 
  	WHERE 1=1
  	  AND b.data_date = ref.data_date 
  	  AND b.symbol IN (SELECT symbol FROM tmp_stocks_to_invest);

  END LOOP;

END;

$$ LANGUAGE plpgsql;
