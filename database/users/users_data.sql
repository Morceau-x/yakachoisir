INSERT INTO account_types VALUES
	('regular', true, true, true),
	('epita', true, DEFAULT, DEFAULT),
	('google', true, DEFAULT, DEFAULT);
	
INSERT INTO users VALUES
	(DEFAULT, 'regular', 'imtheboss', 'email', true, '1234', false, true, true, 'administrator', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
	
SELECT * FROM f_create_user('lhermi_m', 'pass', 'lhermi_m@test.fr');
SELECT * FROM f_create_user('lee_o', 'ssap', 'lee_o@test.fr');
SELECT * FROM f_create_user('pamart_a', 'decu', 'pamart_a@test.fr');
SELECT * FROM f_create_user('boulay_v', 'password', 'boulay_v@test.fr');

SELECT * FROM f_set_moderator('imtheboss', 'lhermi_m');