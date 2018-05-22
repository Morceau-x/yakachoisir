/*********************
******** DROPS *******
*********************/
DROP FUNCTION IF EXISTS f_create_assoc(name VARCHAR(1024), summary VARCHAR(8192), school VARCHAR(128));
DROP FUNCTION IF EXISTS f_delete_assoc(user_id INTEGER, name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_member(user_id INTEGER, name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_desk(user_id INTEGER, name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_president(user_id INTEGER, name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_superior(user_id INTEGER, target_id INTEGER, name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_set_member(user_id INTEGER, target_id INTEGER, name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_set_desk(user_id INTEGER, target_id INTEGER, name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_remove_member(user_id INTEGER, target_id INTEGER, name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_set_president(user_id INTEGER, target_id INTEGER, name VARCHAR(1024));
DROP FUNCTION IF EXISTS f_is_remove_president(user_id INTEGER, target_id INTEGER, name VARCHAR(1024));

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
	IF (name IS NULL OR school IS NULL OR summary IS NULL) THEN
		RETURN FALSE;
	END IF;
	if (NOT f_is_moderator(user_id)) THEN
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
	IF (user_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $2)) THEN
		RETURN FALSE;
	END IF;
	IF (NOT f_is_moderator(user_id)) THEN
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
	IF (user_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $2)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(user_id)) THEN
		RETURN TRUE;
	END IF;
	IF (EXISTS (SELECT * FROM assocs a WHERE a.name = $2 AND a.president = $1)) THEN
		RETURN TRUE;
	END IF;
	RETURN EXISTS(SELECT * FROM members m JOIN assocs a ON m.assoc = a.id
		WHERE m.member = $1 AND a.name = $2);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*********************
******* IS DESK ******
*********************/
CREATE OR REPLACE FUNCTION f_is_desk(user_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (user_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $2)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(user_id)) THEN
		RETURN TRUE;
	END IF;

	IF (EXISTS (SELECT * FROM assocs a WHERE a.name = $2 AND a.president = $1)) THEN
		RETURN TRUE;
	END IF;
	RETURN EXISTS(SELECT * FROM members m JOIN assocs a ON m.assoc = a.id
		WHERE m.member = $1 AND a.name = $2 AND m.desk = TRUE);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/************************
****** IS PRESIDENT *****
*************************/
CREATE OR REPLACE FUNCTION f_is_president(user_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (user_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $2)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(user_id)) THEN
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
CREATE OR REPLACE FUNCTION f_is_superior(user_id INTEGER, target_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (user_id IS NULL OR target_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(target_id)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_moderator(user_id)) THEN
		RETURN TRUE;
	END IF;
	IF (f_is_president(user_id)) THEN
		RETURN TRUE;
	END IF;
	IF (f_is_desk(user_id) AND NOT f_is_desk(target_id)) THEN
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
CREATE OR REPLACE FUNCTION f_set_member(user_id INTEGER, target_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (user_id IS NULL OR target_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(user_id, target_id, name)) THEN
		RETURN FALSE;
	END IF;

	IF (f_is_president(target_id)) THEN
		UPDATE assocs SET president = NULL WHERE assocs.name = $3;
		INSERT INTO members VALUES ($3, $2, FALSE);
	ELSIF (f_is_desk(target_id)) THEN
		UPDATE members SET desk = FALSE WHERE members.member = $2 AND members.assoc = $3;
	ELSIF (NOT f_is_member(target_id)) THEN
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
CREATE OR REPLACE FUNCTION f_set_desk(user_id INTEGER, target_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (user_id IS NULL OR target_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(user_id, target_id, name) OR NOT f_is_president(user_id)) THEN
		RETURN FALSE;
	END IF;
	
	IF (f_is_president(target_id)) THEN
		UPDATE assocs SET president = NULL WHERE assocs.name = $3;
		INSERT INTO members VALUES ($3, $2, TRUE);
	ELSIF (f_is_member(target_id)) THEN
		UPDATE members SET desk = TRUE WHERE members.member = $2 AND members.assoc = $3;
	ELSIF (NOT f_is_desk(target_id)) THEN
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
CREATE OR REPLACE FUNCTION f_remove_member(user_id INTEGER, target_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (user_id IS NULL OR target_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(user_id, target_id, name)) THEN
		RETURN FALSE;
	END IF;
	
	IF (f_is_president(target_id)) THEN
		UPDATE assocs SET president = NULL WHERE assocs.name = $3;
	ELSIF (f_is_member(target_id)) THEN
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
CREATE OR REPLACE FUNCTION f_set_president(user_id INTEGER, target_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (user_id IS NULL OR target_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(user_id, target_id, name) OR NOT f_is_moderator(user_id)) THEN
		RETURN FALSE;
	END IF;
	
	IF (f_is_member(target_id)) THEN
		DELETE FROM members WHERE members.member = $2 AND members.assoc = $3;
		UPDATE assocs SET president = $2 WHERE assocs.name = $3;
	ELSEIF (NOT f_is_president(target_id)) THEN
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
CREATE OR REPLACE FUNCTION f_remove_president(user_id INTEGER, target_id INTEGER, name VARCHAR(1024))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (user_id IS NULL OR target_id IS NULL OR name IS NULL) THEN
		RETURN FALSE;
	END IF;
	IF (EXISTS(SELECT * FROM assocs a WHERE a.deleted = TRUE AND a.name = $3)) THEN
		RETURN FALSE;
	END IF;
	
	IF (NOT f_is_superior(user_id, target_id, name) OR NOT f_is_moderator(user_id)) THEN
		RETURN FALSE;
	END IF;
	
	IF (f_is_president(target_id)) THEN
		UPDATE assocs SET president = NULL WHERE assocs.name = $3;
	END IF;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql