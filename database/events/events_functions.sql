/*********************
******** DROPS *******
*********************/
DROP FUNCTION IF EXISTS f_create_event(login VARCHAR(256), name VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(128));
DROP FUNCTION IF EXISTS f_delete_event(login VARCHAR(256), event_id INTEGER);
DROP FUNCTION IF EXISTS f_get_list_event();
DROP FUNCTION IF EXISTS f_get_event(login VARCHAR(256), event_id INTEGER);


/*********************
***** FUNCTIONS ******
*********************/
/*
*/

/*********************
*** CREATE ACCOUNT ***
*********************/
CREATE OR REPLACE FUNCTION f_create_event(login VARCHAR(256), name VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(128))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL OR summary IS NULL OR begin_date IS NULL OR end_date IS NULL OR assoc IS NULL) THEN
		RETURN NULL;
	END IF;
	INSERT INTO events VALUES
	(DEFAULT, name, summary, DEFAULT, begin_date, end_date, login, assoc, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;
