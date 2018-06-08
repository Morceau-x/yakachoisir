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
END;
$$ LANGUAGE plpgsql;