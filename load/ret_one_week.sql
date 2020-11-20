CREATE OR REPLACE FUNCTION ret_one_week() RETURNS VOID AS $$

/*

	In LOOP:

	 - 
*/


DECLARE

  ref   RECORD;
  date_start DATE := '05-06-2020';
  date_stop  DATE := '12-08-2020';
  date_dow CHAR(15);

BEGIN

  TRUNCATE TABLE ret_one_week;

  FOR ref IN SELECT * FROM lkp_dates WHERE prev_date BETWEEN date_start AND date_stop ORDER BY 1 LOOP

  	raise notice 'Prev Date: %', ref.prev_date;
  	raise notice 'Curr Date: %', ref.data_date;

    -- IF Day of week is Friday, then update the list.
    
    date_dow = TO_CHAR(ref.data_date::date, 'Day');
    
    IF date_dow = 'Friday' THEN

      raise notice 'Current day is Friday: Loading new stocks for next week';

      TRUNCATE TABLE tmp_stocks_to_invest;

      INSERT INTO tmp_stocks_to_invest 
      SELECT symbol FROM barchart_data 
      WHERE 1=1
        AND data_date = ref.prev_date
      ORDER BY weighted_alpha::decimal DESC LIMIT 10;

    END IF;

  	-- Insert barchart data into return table.
  	-- We should be able to query this table to determine over performance of daily changes.

    raise notice 'Inserting into ret_one_week';

  	INSERT INTO ret_one_week  
  	SELECT b.symbol, b.data_date, b.weighted_alpha, b.perc_change_daily FROM barchart_data b 
  	WHERE 1=1
  	  AND b.data_date = ref.data_date 
  	  AND b.symbol IN (SELECT symbol FROM tmp_stocks_to_invest)
  	;


    raise notice '==============';

  END LOOP;

END;

$$ LANGUAGE plpgsql;
