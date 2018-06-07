CREATE OR REPLACE FUNCTION f_list_week_events()
RETURNS SETOF VARCHAR(1024) AS
$$
BEGIN
	RETURN QUERY SELECT name FROM events e WHERE e.begin_date <= date_trunc('week',  LOCALTIMESTAMP) + interval '8 day' AND e.begin_date >= date_trunc('week',  LOCALTIMESTAMP) AND e.moderator_approved = TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN QUERY SELECT NULL LIMIT 0;
END;
$$ LANGUAGE plpgsql;