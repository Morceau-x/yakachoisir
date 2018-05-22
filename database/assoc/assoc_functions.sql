/*********************
******** DROPS *******
*********************/
DROP FUNCTION IF EXISTS f_create_assoc(name VARCHAR(1024), summary VARCHAR(8192), school VARCHAR(128));
DROP FUNCTION IF EXISTS f_delete_assoc(user_id INTEGER, name VARCHAR(1024));

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
CREATE OR REPLACE FUNCTION f_create_assoc(user_id INTEGER, name VARCHAR(1024), summary VARCHAR(8192), school VARCHAR(128))
RETURNS BOOLEAN AS
$$
BEGIN
	if (NOT f_is_moderator(user_id)) THEN
		RETURN FALSE;
	END IF;
	IF (name IS NULL OR school IS NULL OR summary IS NULL) THEN
		RETURN FALSE;
	END IF;
	INSERT INTO assocs VALUES
	(DEFAULT, name, summary, school, DEFAULT, DEFAULT, DEFAULT, NULL);
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
*** DELETE ACCOUNT ***
*********************/
CREATE OR REPLACE FUNCTION f_delete_assoc(user_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (NOT f_is_moderator(user_id)) THEN
		RETURN FALSE;
	END IF;
	IF (user_id IS NULL OR name IS NULL) THEN
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
CREATE OR REPLACE FUNCTION f_is_member(user_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (f_is_moderator(user_id)) THEN
		RETURN TRUE;
	END IF;
	IF (user_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	/** PRESIDENT **/
	RETURN EXISTS(SELECT * FROM members m
	JOIN assocs a ON m.assoc = a.id
	WHERE m.member = $1 AND a.name = $2 AND a.deleted = FALSE);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
***** ADD MEMBER *****
*********************/
CREATE OR REPLACE FUNCTION f_delete_assoc(user_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (NOT f_is_moderator(user_id)) THEN
		RETURN FALSE;
	END IF;
	IF (user_id IS NULL OR name IS NULL) THEN
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
