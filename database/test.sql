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
	
	IF (NOT f_is_superior(user_id, target_id, name) OR NOT f_is_president(user_id, name)) THEN
		RETURN FALSE;
	END IF;
	
	IF (f_is_president(target_id, name)) THEN
		UPDATE assocs SET president = NULL WHERE assocs.name = $3;
		INSERT INTO members VALUES ($3, $2, TRUE);
	ELSIF (f_is_member(target_id, name)) THEN
		UPDATE members SET desk = TRUE WHERE members.member = $2 AND members.assoc = $3;
	ELSIF (NOT f_is_desk(target_id, name)) THEN
		INSERT INTO members VALUES ($3, $2, TRUE);		
	END IF;
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;