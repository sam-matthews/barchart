CREATE OR REPLACE FUNCTION load_stock_list(analyze_type IN VARCHAR) RETURNS VOID AS $$

BEGIN
  raise notice 'Running load_stock_list';

END;

$$ LANGUAGE plpgsql;