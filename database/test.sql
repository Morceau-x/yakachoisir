CREATE OR REPLACE FUNCTION f_can_participate(login VARCHAR(256), name VARCHAR(1024), price VARCHAR(1024))
RETURNS BOOLEAN AS
$$
DECLARE
	pri INTEGER;
	ass VARCHAR(1024);
	epita BOOLEAN;
	ionis BOOLEAN;
	assoc BOOLEAN;

	epita_req BOOLEAN;
	ionis_req BOOLEAN;
	assoc_req BOOLEAN;
BEGIN
	IF (login IS NULL OR name IS NULL OR price IS NULL) THEN
		RETURN FALSE;
	END IF;
	SELECT e.assoc INTO ass FROM events e WHERE e.name = $2;
	SELECT p.id INTO pri FROM prices p WHERE p.event = $2 AND p.price_name = $3;
	SELECT u.epita, u.ionis INTO epita, ionis FROM users u WHERE u.login = $1;
	SELECT p.epita_only, p.ionis_only, p.assoc_only INTO epita_req, ionis_req, assoc_req FROM prices p WHERE p.id = pri;
	
	IF (EXISTS(SELECT * FROM participants p WHERE p.login = $1 AND p.event = $2)) THEN
		RETURN FALSE;
	END IF;
	IF (f_is_member($1, ass) OR f_is_desk($1, ass) OR f_is_president($1, ass)) THEN
		SELECT TRUE INTO assoc;
	ELSE
		SELECT FALSE INTO assoc;
	END IF;

	RETURN assoc OR (NOT assoc_req AND (epita OR (NOT epita_req AND (ionis OR (NOT ionis_req)))));
END;
$$ LANGUAGE plpgsql;