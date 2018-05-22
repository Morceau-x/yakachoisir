CREATE OR REPLACE FUNCTION f_change_password(id INTEGER, old_pass VARCHAR(256), new_pass VARCHAR(256))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (id IS NULL OR old_pass IS NULL OR new_pass IS NULL) THEN
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