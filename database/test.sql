CREATE OR REPLACE FUNCTION f_list_prices(event VARCHAR(1024))
RETURNS SETOF price_data AS
'SELECT p.price_name, p.price_value, count(s.id)::integer, p.max_number, p.assoc_only, p.epita_only, p.ionis_only 
FROM participants s
JOIN prices p ON p.id = s.price
WHERE p.event = $1
GROUP BY p.price_name, p.price_value, p.max_number, p.assoc_only, p.epita_only, p.ionis_only;'
LANGUAGE SQL;