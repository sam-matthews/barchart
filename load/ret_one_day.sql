CREATE OR REPLACE FUNCTION ret_one_day() RETURNS VOID AS $$

/*

	In LOOP:

	 - 
*/


DECLARE

  ref   RECORD;
  date_start DATE := '04-06-2020';
  date_stop  DATE := '31-12-2020';

  day_of_week INTEGER;

BEGIN


  TRUNCATE TABLE ret_one_day;

  FOR ref IN SELECT * FROM lkp_dates WHERE prev_date BETWEEN date_start AND date_stop ORDER BY 1 LOOP

  	raise notice 'Prev Date: %', ref.prev_date;
  	raise notice 'Curr Date: %', ref.data_date;

  	-- Grab list of stocks from previous day and insert it into previous table.
	-- This is how we define what stocks we choose. Typically based on some criteria. Weighted Alpha or 1 Moth performance or 1 week performance.
  	

/*
	INSERT INTO tmp_stocks_to_invest 
  	SELECT symbol 
  	FROM barchart_data 
  	WHERE 1=1
  	  AND data_date = ref.prev_date
  	ORDER BY weighted_alpha::decimal DESC LIMIT 20;
*/

	day_of_week = date_part('dow', ref.prev_date);

	IF (day_of_week IN (1,2,3,4,5)) THEN
		
		raise notice 'Updating stocks.';
		
		TRUNCATE TABLE tmp_stocks_to_invest;

		INSERT INTO tmp_stocks_to_invest 
  		SELECT symbol 
  		FROM barchart_data 
  		WHERE 1=1
  	  	  AND data_date = ref.prev_date
		ORDER BY perc_chg_6mth::decimal DESC LIMIT 10;

	END IF;
  	-- ORDER BY perc_chg_3mth::decimal DESC LIMIT 10;
	-- ORDER BY weighted_alpha::decimal DESC LIMIT 10;


	-- Insert barchart data into return table.
  	-- We should be able to query this table to determine over performance of daily changes.
	raise notice 'Loading data into: %', ref.data_date;

  	INSERT INTO ret_one_day  
  	SELECT b.symbol, b.data_date, b.weighted_alpha, b.perc_change_daily, b.perc_chg_3mth 
	FROM barchart_data b 
  	WHERE 1=1
  	  AND b.data_date = ref.data_date 
  	  AND b.symbol IN (SELECT symbol FROM tmp_stocks_to_invest)
  	;


	raise notice '==============';

  END LOOP;

END;

$$ LANGUAGE plpgsql;
