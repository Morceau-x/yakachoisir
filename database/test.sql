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