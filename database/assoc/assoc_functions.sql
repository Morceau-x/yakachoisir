/*********************
******** DROPS *******
*********************/
DROP FUNCTION IF EXISTS f_create_assoc(name VARCHAR(1024), summary VARCHAR(8192), school VARCHAR(128));
DROP FUNCTION IF EXISTS f_delete_assoc(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_member(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_desk(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_president(login VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_superior(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_set_member(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_set_desk(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_remove_member(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_set_president(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_remove_president(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_get_assoc(name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_list_assocs();
DROP FUNCTION IF EXISTS f_get_members(name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_get_desk(name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_get_president(name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_has_assoc(login VARCHAR(256));
DROP FUNCTION IF EXISTS f_assocs(login VARCHAR(256));

/*********************
***** FUNCTIONS ******
*********************/
/* Create assoc [name, summary, school -> bool]
-- Delete assoc [ -> bool]
-- Add member [ -> bool]
-- Remove member [ -> bool]
-- Upgrade member [ -> bool]
-- Downgrade member [ -> bool]
-- Set president [ -> bool]
-- Remove president [ -> bool]
-- TODO -- Edit data (name, summary, school)
*/

/*********************
*** CREATE ASSOC ***
*********************/
CREATE OR REPLACE FUNCTION f_create_assoc(login VARCHAR(256), name VARCHAR(1024), summary VARCHAR(8192), school VARCHAR(128))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL OR school IS NULL OR summary IS NULL) THEN
		RETURN FALSE;
	END IF;
	if (NOT f_is_moderator(login)) THEN
		RETURN FALSE;
	END IF;

	INSERT INTO assocs VALUES
	(name, summary, school, DEFAULT, DEFAULT, DEFAULT, NULL);
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
*** DELETE ACCOUNT ***
*********************/
CREATE OR REPLACE FUNCTION f_delete_assoc(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $2)) THEN
		RETURN FALSE;
	END IF;
	IF (NOT f_is_moderator(login)) THEN
		RETURN FALSE;
	END IF;
	
	UPDATE assocs SET (name, deleted, deletion_date, president) = (NULL, TRUE, LOCALTIMESTAMP, NULL)
	WHERE assocs.name = $2;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
****** IS MEMBER *****
*********************/
CREATE OR REPLACE FUNCTION f_is_member(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $2)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(login)) THEN
		RETURN TRUE;
	END IF;
	IF (EXISTS (SELECT * FROM assocs a WHERE a.name = $2 AND a.president = $1)) THEN
		RETURN TRUE;
	END IF;
	RETURN EXISTS(SELECT * FROM members m JOIN assocs a ON m.assoc = a.name
		WHERE m.member = $1 AND a.name = $2);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
******* IS DESK ******
*********************/
CREATE OR REPLACE FUNCTION f_is_desk(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $2)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(login)) THEN
		RETURN TRUE;
	END IF;

	IF (EXISTS (SELECT * FROM assocs a WHERE a.name = $2 AND a.president = $1)) THEN
		RETURN TRUE;
	END IF;
	RETURN EXISTS(SELECT * FROM members m JOIN assocs a ON m.assoc = a.name
		WHERE m.member = $1 AND a.name = $2 AND m.desk = TRUE);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/************************
****** IS PRESIDENT *****
*************************/
CREATE OR REPLACE FUNCTION f_is_president(login VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $2)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(login)) THEN
		RETURN TRUE;
	END IF;
	
	RETURN EXISTS (SELECT * FROM assocs a WHERE a.name = $2 AND a.president = $1);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/************************
****** IS SUPERIOR *****
*************************/
CREATE OR REPLACE FUNCTION f_is_superior(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR target IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(target)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(login)) THEN
		RETURN TRUE;
	END IF;
	IF (f_is_president(login, name)) THEN
		RETURN TRUE;
	END IF;
	IF (f_is_desk(login, name) AND NOT f_is_desk(target, name)) THEN
		RETURN TRUE;
	END IF;
	RETURN FALSE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
***** SET MEMBER *****
*********************/
CREATE OR REPLACE FUNCTION f_set_member(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR target IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(login, target, name)) THEN
		RETURN FALSE;
	END IF;

	IF (f_is_president(target, name)) THEN
		UPDATE assocs SET president = NULL WHERE assocs.name = $3;
		INSERT INTO members VALUES ($3, $2, FALSE);
	ELSIF (f_is_desk(target, name)) THEN
		UPDATE members SET desk = FALSE WHERE members.member = $2 AND members.assoc = $3;
	ELSIF (NOT f_is_member(target, name)) THEN
		INSERT INTO members VALUES ($3, $2, FALSE);
	END IF;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
****** SET DESK ******
*********************/
CREATE OR REPLACE FUNCTION f_set_desk(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR target IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(login, target, name) OR NOT f_is_president(login, name)) THEN
		RETURN FALSE;
	END IF;
	
	IF (f_is_president(target, name)) THEN
		UPDATE assocs SET president = NULL WHERE assocs.name = $3;
		INSERT INTO members VALUES ($3, $2, TRUE);
	ELSIF (f_is_member(target, name)) THEN
		UPDATE members SET desk = TRUE WHERE members.member = $2 AND members.assoc = $3;
	ELSIF (NOT f_is_desk(target, name)) THEN
		INSERT INTO members VALUES ($3, $2, TRUE);		
	END IF;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/**************************
****** REMOVE MEMBER ******
***************************/
CREATE OR REPLACE FUNCTION f_remove_member(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR target IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(login, target, name)) THEN
		RETURN FALSE;
	END IF;
	
	IF (f_is_president(target, name)) THEN
		UPDATE assocs SET president = NULL WHERE assocs.name = $3;
	ELSIF (f_is_member(target, name)) THEN
		DELETE FROM members WHERE members.member = $2 AND members.assoc = $3;
	END IF;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/**************************
****** SET PRESIDENT ******
***************************/
CREATE OR REPLACE FUNCTION f_set_president(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR target IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(login, target, name) OR NOT f_is_moderator(login)) THEN
		RETURN FALSE;
	END IF;
	
	IF (f_is_member(target, name)) THEN
		DELETE FROM members WHERE members.member = $2 AND members.assoc = $3;
		UPDATE assocs SET president = $2 WHERE assocs.name = $3;
	ELSEIF (NOT f_is_president(target, name)) THEN
		UPDATE assocs SET president = $2 WHERE assocs.name = $3;
	END IF;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*****************************
****** REMOVE PRESIDENT ******
******************************/
CREATE OR REPLACE FUNCTION f_remove_president(login VARCHAR(256), target VARCHAR(256), name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR target IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(login, target, name) OR NOT f_is_moderator(login)) THEN
		RETURN FALSE;
	END IF;
	
	IF (f_is_president(target, name)) THEN
		UPDATE assocs SET president = NULL WHERE assocs.name = $3;
	END IF;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
*** GET ASSOC DATA ***
**********************/
CREATE TYPE assoc_data AS (summary VARCHAR(8192), school VARCHAR(128), president VARCHAR(256));
CREATE OR REPLACE FUNCTION f_get_assoc(name VARCHAR(1024))
RETURNS assoc_data AS
'SELECT summary, school, president FROM assocs a WHERE a.name = $1;'
LANGUAGE SQL;

/*********************
***** LIST ASSOCS ****
**********************/
CREATE OR REPLACE FUNCTION f_list_assocs()
RETURNS SETOF VARCHAR(1024) AS 'SELECT name FROM assocs;'
LANGUAGE SQL;

/*********************
**** GET MEMBERS *****
**********************/
CREATE OR REPLACE FUNCTION f_get_members(name VARCHAR(1024))
RETURNS SETOF VARCHAR(256) AS
'SELECT m.member FROM members m WHERE m.assoc = $1 AND m.desk = FALSE;'
LANGUAGE SQL;

/*********************
****** GET DESK ******
**********************/
CREATE OR REPLACE FUNCTION f_get_desk(name VARCHAR(1024))
RETURNS SETOF VARCHAR(256) AS
'SELECT m.member FROM members m WHERE m.assoc = $1 AND m.desk = TRUE;'
LANGUAGE SQL;

/*********************
**** GET PRESIDENT ***
**********************/
CREATE OR REPLACE FUNCTION f_get_president(name VARCHAR(1024))
RETURNS SETOF VARCHAR(256) AS
'SELECT a.president FROM assocs a WHERE a.name = $1;'
LANGUAGE SQL;

/*********************
** USER HAS A ASSOC **
**********************/
CREATE OR REPLACE FUNCTION f_has_assoc(login VARCHAR(256))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(login)) THEN
		RETURN TRUE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.president = $1 AND a.deleted = FALSE)) THEN
		RETURN TRUE;
	END IF;
	IF (EXISTS(SELECT * FROM members m JOIN assocs a ON m.assoc = a.name
			   WHERE m.member = $1 AND a.deleted = FALSE)) THEN
		RETURN TRUE;
	END IF;
	RETURN FALSE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
**** USER'S ASSOCS ***
**********************/
CREATE OR REPLACE FUNCTION f_assocs(login VARCHAR(256))
RETURNS SETOF VARCHAR(1024) AS
$$
BEGIN
	IF (login IS NULL) THEN
		RETURN QUERY SELECT NULL LIMIT 0;
	END IF;
	IF (f_is_moderator(login)) THEN
		RETURN QUERY SELECT a.name FROM assocs a WHERE a.deleted = false;
	ELSE
		RETURN QUERY SELECT DISTINCT a.name FROM members m JOIN assocs a ON a.name = m.assoc
				WHERE a.deleted = false AND (m.member = $1 OR a.president = $1);
	END IF;
EXCEPTION
	WHEN OTHERS THEN
		RETURN QUERY SELECT NULL LIMIT 0;
END;
$$ LANGUAGE plpgsql;

/*************************
****** GET PRESIDENT *****
*************************/
CREATE OR REPLACE FUNCTION f_get_president_assoc(login VARCHAR(256))
RETURNS VARCHAR(1024) AS
'SELECT a.name FROM assocs a WHERE a.president = $1;'
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION f_is_president_assoc(login VARCHAR(256))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(login)) THEN
		RETURN TRUE;
	END IF;
	IF (EXISTS(SELECT a.name FROM assocs a WHERE a.president = $1)) THEN
		RETURN TRUE;
	END IF;
	RETURN FALSE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION f_list_schools()
RETURNS SETOF VARCHAR(128) AS
'SELECT s.shortname FROM schools s;'
LANGUAGE SQL;
