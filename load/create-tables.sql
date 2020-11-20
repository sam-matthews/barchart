-- s_price.tab
-- Sam Matthews
-- Create staging table for price data.
\! echo "======================="
\! echo "Creating table: S_PRICE"

CREATE TABLE IF NOT EXISTS s_barchart(
  s_symbol CHAR(20),
  s_last 		INTEGER,
  s_wtd_alpha REAL,
  s_perc_change REAL
);



