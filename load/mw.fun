-- DROP FUNCTION mw_new(fund CHAR(10));

CREATE OR REPLACE FUNCTION mw(chart_type IN CHAR, chart_period IN CHAR, chart_dur IN INTEGER) RETURNS VOID AS $$
DECLARE
  ref           RECORD;
  counter       INTEGER;
  close_price   REAL;
  high_price    REAL;
  low_price     REAL;

  chart_name    CHAR(30);

BEGIN
  -- DEFINE variables
  counter := 0;
  chart_name := chart_type || '-' || chart_period || '-' || chart_dur;

  -- raise notice 'Loading: %', fund;

  -- TRUNCATE TABLE s_stock;
  TRUNCATE TABLE s_stock;

  FOR ref IN
    SELECT 
      curr_date AS p_date, 
      chart_name AS stock, 
      running_total::decimal AS p_price
    FROM summary_return_average
    WHERE 1=1
      AND ret_strategy = chart_type
      AND ret_type = chart_period
      AND ret_period::integer = chart_dur
    ORDER BY p_date

  LOOP
    counter := counter + 1;

    -- raise notice 'counter: %', counter;
    -- raise notice 'Date   : %', ref.p_date;
    -- raise notice 'Price  : %', ref.p_price;

    -- If first record
    IF counter = 1 then

      INSERT INTO s_stock VALUES(
        ref.p_date,
        ref.p_price,
        ref.p_price,
        ref.p_price,
        ref.p_price,
        0,
        ref.p_price
      );

      ELSE
        -- Check what is the high price and what is the low price.
        IF close_price < ref.p_price THEN
          low_price := close_price;
          high_price := ref.p_price;
        ELSE
          low_price := ref.p_price;
          high_price := close_price;
        END IF;


        INSERT INTO s_stock VALUES(
          ref.p_date,
          close_price,
          high_price,
          low_price,
          ref.p_price,
          0,
          ref.p_price
      );


    END IF;
    close_price := ref.p_price;

  END LOOP;

END;
$$ LANGUAGE plpgsql;
