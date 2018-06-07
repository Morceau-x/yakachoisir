/*********************
******** DROPS *******
*********************/
DROP FUNCTION IF EXISTS f_create_event(login VARCHAR(256), event VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(1024));
DROP FUNCTION IF EXISTS f_edit_event(login VARCHAR(256), event VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP);
DROP FUNCTION IF EXISTS f_delete_event(login VARCHAR(256), event VARCHAR(1024));

DROP FUNCTION IF EXISTS f_is_creator(login VARCHAR(256), event VARCHAR(1024));
DROP FUNCTION IF EXISTS f_get_creator(event VARCHAR(1024));

DROP FUNCTION IF EXISTS f_set_premium(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_moderator_approve(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_president_approve(login VARCHAR(256), name VARCHAR(1024));

DROP FUNCTION IF EXISTS f_add_participant(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_add_staff(login VARCHAR(256), name VARCHAR(1024));

DROP FUNCTION IF EXISTS f_add_partner(login VARCHAR(256), event VARCHAR(1024), assoc VARCHAR(1024));
DROP FUNCTION IF EXISTS f_remove_partner(login VARCHAR(256), event VARCHAR(1024), assoc VARCHAR(1024));

DROP FUNCTION IF EXISTS f_create_price(login VARCHAR(256), event VARCHAR(1024), name VARCHAR(1024), price REAL, max_number INTEGER, assoc_only BOOLEAN, epita_only BOOLEAN, ionis_only BOOLEAN);

DROP FUNCTION IF EXISTS f_get_event(name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_list_all_events();
DROP FUNCTION IF EXISTS f_list_events(assoc VARCHAR(1024));
DROP FUNCTION IF EXISTS f_list_future_events(); /* approved */

DROP FUNCTION IF EXISTS f_list_participants(event VARCHAR(1024));
DROP FUNCTION IF EXISTS f_list_staff(event VARCHAR(1024));

DROP FUNCTION IF EXISTS f_list_participating(login VARCHAR(256));

/*********************
***** FUNCTIONS ******
*********************/
/*
*/

/*********************
**** CREATE EVENT ****
*********************/
CREATE OR REPLACE FUNCTION f_create_event(login VARCHAR(256), event VARCHAR(1024), summary VARCHAR(8192), begin_date VARCHAR(1024), end_date VARCHAR(1024), assoc VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR event IS NULL OR summary IS NULL OR begin_date IS NULL OR end_date IS NULL OR assoc IS NULL) THEN
		RETURN FALSE;
	END IF;
	INSERT INTO events VALUES
	(DEFAULT, event, summary, DEFAULT, begin_date::timestamp, end_date::timestamp, assoc, login, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
***** EDIT EVENT *****
*********************/
CREATE OR REPLACE FUNCTION f_edit_event(login VARCHAR(256), name VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP)
RETURNS BOOLEAN AS
$$
DECLARE
	assoc VARCHAR(1024);
BEGIN
	IF (login IS NULL OR name IS NULL OR summary IS NULL OR begin_date IS NULL OR end_date IS NULL) THEN
		RETURN FALSE;
	END IF;
	SELECT e.assoc INTO assoc FROM events e WHERE e.name = $2;
	IF (NOT f_is_desk(login, assoc) AND NOT f_is_creator(login, name)) THEN
		RETURN FALSE;
	END IF;
	UPDATE events SET (summary, begin_date, end_date) = ($3, $4, $5)
	WHERE events.name = $2;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
*** ADD PARTICPANT ***
*********************/
CREATE OR REPLACE FUNCTION f_add_participant(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	INSERT INTO participants VALUES (DEFAULT, name, login, FALSE, TRUE, DEFAULT);
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
****** ADD STAFF *****
*********************/
CREATE OR REPLACE FUNCTION f_add_staff(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	INSERT INTO participants VALUES (DEFAULT, name, login, TRUE, TRUE, DEFAULT);
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
***** IS CREATOR *****
*********************/
CREATE OR REPLACE FUNCTION f_is_creator(login VARCHAR(256), event VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	RETURN EXISTS(SELECT * FROM events e WHERE e.creator = login AND e.name = event);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
**** GET CREATOR *****
*********************/
CREATE OR REPLACE FUNCTION f_get_creator(event VARCHAR(1024))
RETURNS VARCHAR(256) AS 'SELECT e.creator FROM events e WHERE e.name = $1;'
LANGUAGE SQL;

/*********************
***** GET EVENT ******
*********************/
CREATE TYPE event_data AS (summary VARCHAR(8192), premium BOOLEAN, begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(1024), creator VARCHAR(256));
CREATE OR REPLACE FUNCTION f_get_event(name VARCHAR(1024))
RETURNS event_data AS
'SELECT summary, premium, begin_date, end_date, assoc, creator FROM events e WHERE e.name = $1;'
LANGUAGE SQL;

/*********************
*** LIST ALL EVENTS **
*********************/
CREATE OR REPLACE FUNCTION f_list_all_events()
RETURNS SETOF VARCHAR(1024) AS
'SELECT name FROM events e;'
LANGUAGE SQL;

/*********************
***** LIST EVENTS ****
*********************/
CREATE OR REPLACE FUNCTION f_get_list_events(assoc VARCHAR(1024))
RETURNS SETOF VARCHAR(1024) AS
'SELECT name FROM events e WHERE e.assoc = $1;'
LANGUAGE SQL;

/*********************
* LIST FUTURE EVENTS *
*********************/
CREATE OR REPLACE FUNCTION f_list_future_events()
RETURNS SETOF VARCHAR(1024) AS
'SELECT name FROM events e WHERE e.end_date > LOCALTIMESTAMP AND e.moderator_approved = TRUE;'
LANGUAGE SQL;

/*********************
** LIST PARTICIPANTS *
*********************/
CREATE OR REPLACE FUNCTION f_list_participants(event VARCHAR(1024))
RETURNS SETOF VARCHAR(256) AS
'SELECT p.login FROM participants p WHERE p.event = $1 AND p.staff = FALSE;'
LANGUAGE SQL;

/*********************
***** LIST STAFF *****
*********************/
CREATE OR REPLACE FUNCTION f_list_staff(event VARCHAR(1024))
RETURNS SETOF VARCHAR(256) AS
'SELECT p.login FROM participants p WHERE p.event = $1 AND p.staff = TRUE;'
LANGUAGE SQL;

/*********************
*** PARTICIPATING ****
*********************/
CREATE TYPE event_name_data AS (name VARCHAR(1024), summary VARCHAR(8192), premium BOOLEAN, begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(1024), creator VARCHAR(256));
CREATE OR REPLACE FUNCTION f_list_participating(login VARCHAR(256))
RETURNS SETOF event_name_data AS
'SELECT e.name, e.summary, e.premium, e.begin_date, e.end_date, e.assoc, e.creator FROM participants p
JOIN events e ON e.name = p.event
WHERE p.login = $1;'
LANGUAGE SQL;

/*********************
******* ENTER ********
*********************/
CREATE OR REPLACE FUNCTION f_enter(login VARCHAR(256), event VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR event IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT e.name FROM events e WHERE name = $2 AND (begin_date > LOCALTIMESTAMP OR end_date < LOCALTIMESTAMP))) THEN
			RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT p.login FROM participants p WHERE p.login = $1 AND p.event = $2 AND is_inside = TRUE)) THEN
		RETURN FALSE;
	END IF;
	UPDATE participants p SET is_inside = TRUE WHERE p.login = $1 AND p.event = $2;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
******* LEAVE ********
*********************/
CREATE OR REPLACE FUNCTION f_leave(login VARCHAR(256), event VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR event IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT e.name FROM events e WHERE e.name = $2 AND (begin_date > LOCALTIMESTAMP OR end_date < LOCALTIMESTAMP))) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT p.login FROM participants p WHERE p.login = $1 AND p.event = $2 AND p.is_inside = FALSE)) THEN
		RETURN FALSE;
	END IF;
	UPDATE participants p SET is_inside = FALSE WHERE p.login = $1 AND p.event = $2;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

