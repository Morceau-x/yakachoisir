/*********************
******** DROPS *******
*********************/
DROP FUNCTION IF EXISTS f_create_event(user_id INTEGER, name VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(128));
DROP FUNCTION IF EXISTS f_edit_event(user_id INTEGER, event_id INTEGER);
DROP FUNCTION IF EXISTS f_delete_event(user_id INTEGER, event_id INTEGER);
DROP FUNCTION IF EXISTS f_get_list_event();
DROP FUNCTION IF EXISTS f_get_event(user_id INTEGER, event_id INTEGER);


/*********************
***** FUNCTIONS ******
*********************/
/*
*/

/*********************
*** CREATE ACCOUNT ***
*********************/
CREATE OR REPLACE FUNCTION f_create_event(user_id INTEGER, name VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(128))
RETURNS INTEGER AS
$$
DECLARE
	id INTEGER;
BEGIN
	IF (login IS NULL OR password IS NULL OR email IS NULL) THEN
		RETURN NULL;
	END IF;
	INSERT INTO users VALUES
	(DEFAULT, DEFAULT, login, email, DEFAULT, password, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
	SELECT u.id INTO id FROM users u
	WHERE u.login = $1 AND u.account_type = 'regular';
	RETURN id;
EXCEPTION
	WHEN OTHERS THEN
		RETURN NULL;
END;
$$ LANGUAGE plpgsql;
