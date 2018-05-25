DROP FUNCTION IF EXISTS f_create_event(login VARCHAR(256), event VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(1024));

CREATE OR REPLACE FUNCTION f_create_event(login VARCHAR(256), event VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR event IS NULL OR summary IS NULL OR begin_date IS NULL OR end_date IS NULL OR assoc IS NULL) THEN
		RETURN FALSE;
	END IF;
	INSERT INTO events VALUES
	(DEFAULT, event, summary, DEFAULT, begin_date, end_date, login, assoc, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;