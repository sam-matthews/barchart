-- cre_s_stock.sql
-- Staging table to hold stock table in preparation to load into Motive Wave.
-- Sam Matthews
-- 7th March 2021.

\! echo "======================="
\! echo "Create Table: s_stock"
CREATE TABLE IF NOT EXISTS s_stock(
  s_stock_date      DATE,
  s_stock_open      REAL,
  s_stock_high      REAL,
  s_stock_low       REAL,
  s_stock_close     REAL,
  s_stock_volume    INTEGER,
  s_stock_adj_close REAL
)
;
