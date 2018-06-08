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
END;
$$ LANGUAGE plpgsql;