CREATE OR REPLACE FUNCTION f_change_password(login VARCHAR(256), new_pass VARCHAR(256))
RETURNS BOOLEAN AS
$$
BEGIN
	IF (login IS NULL OR new_pass IS NULL) THEN
		RETURN FALSE;
	END IF;

	UPDATE users SET password = $2 WHERE users.login = $1;

	RETURN EXISTS(SELECT * FROM users u WHERE u.login = $1 AND u.password = $2);
EXCEPTION
	WHEN OTHERS THEN
		RETURN FALSE;
END;
$$ LANGUAGE plpgsql;