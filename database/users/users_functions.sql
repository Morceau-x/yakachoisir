/*********************
******** DROPS *******
*********************/
DROP FUNCTION IF EXISTS f_create_user(login VARCHAR(256), password VARCHAR(256), email VARCHAR(256));
DROP FUNCTION IF EXISTS f_delete_user(id INTEGER, password VARCHAR(256));
DROP FUNCTION IF EXISTS f_regular_connect(login VARCHAR(256), password VARCHAR(256));
DROP FUNCTION IF EXISTS f_epita_connect(login VARCHAR(256));
DROP FUNCTION IF EXISTS f_change_password(id INTEGER, old_pass VARCHAR(256), new_pass VARCHAR(256));
DROP FUNCTION IF EXISTS f_set_moderator(id INTEGER, target INTEGER);
DROP FUNCTION IF EXISTS f_remove_moderator(id INTEGER, target INTEGER);
DROP FUNCTION IF EXISTS f_is_moderator(id INTEGER);
DROP FUNCTION IF EXISTS f_is_administrator(id INTEGER);
DROP FUNCTION IF EXISTS f_id(login VARCHAR(256));


/*********************
***** FUNCTIONS ******
*********************/
/* Create account [login, password, email -> id]
-- Delete account [id, password -> bool]
-- Connect regular [login, password -> id]
-- Connect epita [login -> id]
-- Change password [id, old, new -> bool]
-- Change email [id, old, new -> bool]
-- TODO -- Edit data (ionis, epita, firstname, lastname, address, phone_number)
-- Is moderator [id -> bool]
-- Is administrator [id -> bool]
-- set moderator [id, target -> bool]
*/

/*********************
*** CREATE ACCOUNT ***
*********************/
CREATE OR REPLACE FUNCTION f_create_user(login VARCHAR(256), password VARCHAR(256), email VARCHAR(256))
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

/*********************
*** DELETE ACCOUNT ***
*********************/
CREATE OR REPLACE FUNCTION f_delete_user(id INTEGER, password VARCHAR(256))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (id IS NULL OR password IS NULL) THEN
		RETURN FALSE;
	END IF;
	
	UPDATE users SET (login, account_type, email, password, deleted, address, phone_number, deletion_date)
	= (NULL, NULL, NULL, NULL, TRUE, '', '', LOCALTIMESTAMP)
	WHERE users.id = $1 AND users.password = $2;
	
	RETURN EXISTS (SELECT u.id from users u WHERE u.id = $1 AND u.deleted = TRUE);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
** REGULAR CONNECT ***
*********************/
CREATE OR REPLACE FUNCTION f_regular_connect(login VARCHAR(256), password VARCHAR(256))
RETURNS BOOLEAN AS
$$
DECLARE
	id INTEGER;
BEGIN
	IF (login IS NULL OR password IS NULL) THEN
		RETURN FALSE;
	END IF;
	
	SELECT u.id INTO id FROM users u
	WHERE $1 = u.login AND $2 = u.password AND u.account_type = 'regular';
	
	RETURN id;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
**** EPITA CONNECT ***
**********************/
CREATE OR REPLACE FUNCTION f_epita_connect(login VARCHAR(256))
RETURNS INTEGER AS
$$
DECLARE
	id INTEGER;
BEGIN
	IF (login IS NULL) THEN
		RETURN NULL;
	END IF;
	
	SELECT u.id INTO id FROM users u
	WHERE $1 = u.login AND u.account_type = 'epita';
	
	IF (id IS NOT NULL) THEN
		RETURN id;
	END IF;
	
	INSERT INTO users (account_type, login) VALUES ('epita', login);
	SELECT u.id INTO id FROM users u
	WHERE u.login = $1 AND u.account_type = 'epita';
	RETURN id;
EXCEPTION
	WHEN OTHERS THEN
		RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/*********************
***** CHANGE PASS ****
**********************/
CREATE OR REPLACE FUNCTION f_change_password(id INTEGER, old_pass VARCHAR(256), new_pass VARCHAR(256))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (id IS NULL OR old_pass IS NULL OR new_pass IS NULL OR old_pass = new_pass) THEN
		RETURN FALSE;
	END IF;

	UPDATE users SET password = $3	
	WHERE users.id = $1 AND users.password = $2 AND users.account_type = 'regular';

	RETURN EXISTS(SELECT * FROM users u WHERE u.id = $1 AND u.password = $3);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
**** CHANGE EMAIL ****
**********************/
CREATE OR REPLACE FUNCTION f_change_email(id INTEGER, old_email VARCHAR(256), new_email VARCHAR(256))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (id IS NULL OR old_email IS NULL OR new_email IS NULL OR old_email = new_email) THEN
		RETURN FALSE;
	END IF;

	UPDATE users SET email = $3
	WHERE users.id = $1 AND users.email = $2 AND users.account_type = 'regular';

	RETURN EXISTS(SELECT * FROM users u WHERE u.id = $1 AND u.email = $3);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
**** IS MODERATOR ****
**********************/
CREATE OR REPLACE FUNCTION f_is_moderator(id INTEGER)
RETURNS BOOLEAN AS
$$
BEGIN
	RETURN EXISTS(	SELECT * FROM users u
					WHERE u.id = $1 AND (u.authority = 'moderator' OR u.authority = 'administrator'));
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
** IS ADMINISTRATOR **
**********************/
CREATE OR REPLACE FUNCTION f_is_administrator(id INTEGER)
RETURNS BOOLEAN AS
$$
BEGIN
	RETURN EXISTS(SELECT * FROM users u WHERE u.id = $1 AND u.authority = 'administrator');
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
**** SET MODERATOR ***
**********************/
CREATE OR REPLACE FUNCTION f_set_moderator(id INTEGER, target INTEGER)
RETURNS BOOLEAN AS
$$
BEGIN
	IF (NOT EXISTS(SELECT * FROM users u WHERE u.id = $1 AND u.authority = 'administrator')) THEN
		RETURN FALSE;
	END IF;
	
	UPDATE users SET authority = 'moderator' WHERE users.id = target;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
**** RM MODERATOR ****
**********************/
CREATE OR REPLACE FUNCTION f_remove_moderator(id INTEGER, target INTEGER)
RETURNS BOOLEAN AS
$$
BEGIN
	IF (NOT EXISTS(SELECT * FROM users u WHERE u.id = $1 AND u.authority = 'administrator')) THEN
		RETURN FALSE;
	END IF;
	
	UPDATE users SET authority = 'user' WHERE users.id = target;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
***** GET USER iD ****
**********************/
CREATE OR REPLACE FUNCTION f_id(login VARCHAR(256))
RETURNS INTEGER AS
$$
DECLARE
	id INTEGER;
BEGIN
	SELECT u.id INTO id FROM users u WHERE u.login = $1;
	RETURN id;
EXCEPTION
	WHEN OTHERS THEN
		RETURN -1;
END;
$$ LANGUAGE plpgsql;