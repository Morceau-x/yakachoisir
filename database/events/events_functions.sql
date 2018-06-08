/*********************
******** DROPS *******
*********************/
DROP FUNCTION IF EXISTS f_create_event(login VARCHAR(256), event VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(1024));
DROP FUNCTION IF EXISTS f_edit_event(login VARCHAR(256), event VARCHAR(1024), summary VARCHAR(8192), begin_date TIMESTAMP, end_date TIMESTAMP);
DROP FUNCTION IF EXISTS f_can_edit_event(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_delete_event(login VARCHAR(256), event VARCHAR(1024));

DROP FUNCTION IF EXISTS f_is_creator(login VARCHAR(256), event VARCHAR(1024));
DROP FUNCTION IF EXISTS f_get_creator(event VARCHAR(1024));

DROP FUNCTION IF EXISTS f_set_premium(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_approve(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_can_approve(login VARCHAR(256), name VARCHAR(1024));

DROP FUNCTION IF EXISTS f_add_participant(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_add_staff(login VARCHAR(256), name VARCHAR(1024));

DROP FUNCTION IF EXISTS f_add_partner(login VARCHAR(256), event VARCHAR(1024), assoc VARCHAR(1024));
DROP FUNCTION IF EXISTS f_remove_partner(login VARCHAR(256), event VARCHAR(1024), assoc VARCHAR(1024));

DROP FUNCTION IF EXISTS f_get_event(name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_list_all_events();
DROP FUNCTION IF EXISTS f_list_events(assoc VARCHAR(1024));
DROP FUNCTION IF EXISTS f_list_future_events(); /* approved */
DROP FUNCTION IF EXISTS f_list_mod_events();
DROP FUNCTION IF EXISTS f_list_pres_events();

DROP FUNCTION IF EXISTS f_list_participants(event VARCHAR(1024));
DROP FUNCTION IF EXISTS f_list_staff(event VARCHAR(1024));

DROP FUNCTION IF EXISTS f_list_participating(login VARCHAR(256));
DROP FUNCTION IF EXISTS f_get_participant(login VARCHAR(256), event VARCHAR(1024));

DROP FUNCTION IF EXISTS f_enter(login VARCHAR(256), event VARCHAR(1024));
DROP FUNCTION IF EXISTS f_leave(login VARCHAR(256), event VARCHAR(1024));

DROP FUNCTION IF EXISTS f_create_price(login VARCHAR(256), event VARCHAR(1024), name VARCHAR(1024), price REAL, max_number INTEGER, assoc_only BOOLEAN, epita_only BOOLEAN, ionis_only BOOLEAN);
DROP FUNCTION IF EXISTS f_list_prices(event VARCHAR(256));

/*********************
******** TYPES *******
*********************/
CREATE TYPE price_data AS (price_name VARCHAR(1024), price_value REAL, max_number INTEGER, assoc_only BOOLEAN, epita_only BOOLEAN, ionis_only BOOLEAN);
CREATE TYPE event_data AS (summary VARCHAR(8192), premium BOOLEAN, begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(1024), creator VARCHAR(256));
CREATE TYPE event_name_data AS (name VARCHAR(1024), summary VARCHAR(8192), premium BOOLEAN, begin_date TIMESTAMP, end_date TIMESTAMP, assoc VARCHAR(1024), creator VARCHAR(256));
CREATE TYPE participant_data AS (price_name VARCHAR(1024), price_value REAL, is_inside BOOLEAN);
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
*** CAN EDIT EVENT ***
*********************/
CREATE OR REPLACE FUNCTION f_can_edit_event(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
DECLARE
	assoc VARCHAR(1024);
BEGIN
	SELECT e.assoc INTO assoc FROM events e WHERE e.name = $2;
	IF (f_is_desk(login, assoc) OR f_is_creator(login, name)) THEN
		RETURN TRUE;
	END IF;
	RETURN FALSE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;


/*********************
* CAN APPROUVE EVENT *
*********************/
CREATE OR REPLACE FUNCTION f_can_approve(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
DECLARE
	assoc VARCHAR(1024);
	pres_app BOOLEAN;
	mod_app BOOLEAN;
BEGIN
	SELECT e.assoc, e.president_approved, e.moderator_approved INTO assoc, pres_app, mod_app FROM events e WHERE e.name = $2;
	IF (f_is_president(login, assoc) AND pres_app = FALSE) THEN
		RETURN TRUE;
	END IF;
	IF (f_is_moderator(login) AND mod_app = FALSE) THEN
		RETURN TRUE;
	END IF;
	RETURN FALSE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
**** SET PREMIUM *****
*********************/
CREATE OR REPLACE FUNCTION f_set_premium(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (NOT f_is_moderator(login)) THEN
		RETURN FALSE;
	END IF;
	UPDATE events SET premium = TRUE WHERE events.name = $2;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
****** APPROUVE ******
*********************/
CREATE OR REPLACE FUNCTION f_approve(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
DECLARE
	assoc VARCHAR(1024);
BEGIN
	SELECT e.assoc INTO assoc FROM events e WHERE e.name = $2;
	IF (NOT f_is_president(login, assoc)) THEN
		RETURN FALSE;
	END IF;
	UPDATE events SET president_approved = TRUE WHERE events.name = $2;
	IF (NOT f_is_moderator(login)) THEN
		RETURN TRUE;
	END IF;
	UPDATE events SET moderator_approved = TRUE WHERE events.name = $2;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
*** ADD PARTICPANT ***
*********************/
CREATE OR REPLACE FUNCTION f_add_participant(login VARCHAR(256), name VARCHAR(1024), price VARCHAR(1024))
RETURNS BOOLEAN AS
$$
DECLARE
	id INTEGER;
BEGIN
	IF (login IS NULL OR name IS NULL OR price IS NULL) THEN
		RETURN FALSE;
	END IF;
	SELECT p.id INTO id FROM prices p WHERE p.event = $2 AND p.price_name = $3;
	INSERT INTO participants VALUES (DEFAULT, name, login, id, FALSE, TRUE, DEFAULT);
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
** ADD PARTICPANT 2 **
*********************/
CREATE OR REPLACE FUNCTION f_add_participant(login VARCHAR(256), name VARCHAR(1024), price INTEGER)
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL OR price IS NULL) THEN
		RETURN FALSE;
	END IF;
	INSERT INTO participants VALUES (DEFAULT, name, login, price, FALSE, TRUE, DEFAULT);
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
* LIST EV TO APPROVE**
*********************/
CREATE OR REPLACE FUNCTION f_list_mod_events()
RETURNS SETOF event_name_data AS
'SELECT name, summary, premium, begin_date, end_date, assoc, creator FROM events e WHERE e.president_approved = TRUE AND moderator_approved = FALSE;'
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION f_list_pres_all_events()
RETURNS SETOF event_name_data AS
'SELECT name, summary, premium, begin_date, end_date, assoc, creator FROM events e WHERE e.president_approved = FALSE;'
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION f_list_pres_events(a VARCHAR(1024))
RETURNS SETOF event_name_data AS
'SELECT name, summary, premium, begin_date, end_date, assoc, creator FROM events e WHERE e.president_approved = FALSE AND e.assoc = $1;'
LANGUAGE SQL;


/*********************
* LIST WEEKS EVENTS **
*********************/
CREATE OR REPLACE FUNCTION f_list_week_events()
RETURNS SETOF event_name_data AS
$$
BEGIN
	RETURN QUERY SELECT name, summary, premium, begin_date, end_date, assoc, creator FROM events e 
	WHERE e.begin_date <= date_trunc('month', date_trunc('month',  LOCALTIMESTAMP) + interval '34 day') AND e.begin_date >= date_trunc('month',  LOCALTIMESTAMP) AND e.moderator_approved = TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN QUERY SELECT NULL LIMIT 0;
END;
$$ LANGUAGE plpgsql;

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
CREATE OR REPLACE FUNCTION f_list_participating(login VARCHAR(256))
RETURNS SETOF event_name_data AS
'SELECT e.name, e.summary, e.premium, e.begin_date, e.end_date, e.assoc, e.creator FROM participants p
JOIN events e ON e.name = p.event
WHERE p.login = $1;'
LANGUAGE SQL;

/*********************
** GET PARTICIPANT ***
*********************/
CREATE OR REPLACE FUNCTION f_get_participant(login VARCHAR(256), event VARCHAR(1024))
RETURNS participant_data AS
'SELECT s.price_name, s.price_value, p.is_inside FROM participants p
JOIN prices s ON s.id = p.price
WHERE p.login = $1 AND p.event = $2;'
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

/*********************
**** CREATE PRICE ****
*********************/
CREATE OR REPLACE FUNCTION f_create_price(login VARCHAR(256), event VARCHAR(1024), name VARCHAR(1024), price REAL, max_number INTEGER, assoc_only BOOLEAN, epita_only BOOLEAN, ionis_only BOOLEAN)
RETURNS BOOLEAN AS
$$
DECLARE
	assoc VARCHAR(1024);
BEGIN
	IF (login IS NULL OR event IS NULL OR name IS NULL OR price IS NULL OR max_number IS NULL OR assoc_only IS NULL OR epita_only IS NULL OR ionis_only IS NULL) THEN
		RETURN FALSE;
	END IF;
	SELECT e.assoc INTO assoc FROM events e WHERE e.name = $2;
	IF (NOT f_is_creator(login, event) AND NOT f_is_desk(login, assoc)) THEN
		RETURN FALSE;
	END IF;
	INSERT INTO prices VALUES (DEFAULT, $2, $3, $4, $5, $6, $7, $8);
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
**** LIST PRICES *****
*********************/
CREATE OR REPLACE FUNCTION f_list_prices(event VARCHAR(1024))
RETURNS SETOF price_data AS
'SELECT p.price_name, p.price_value, p.max_number, p.assoc_only, p.epita_only, p.ionis_only FROM prices p
WHERE p.event = $1;'
LANGUAGE SQL;