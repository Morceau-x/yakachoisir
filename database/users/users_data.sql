INSERT INTO account_types VALUES
	('regular', true, true, true),
	('epita', true, DEFAULT, DEFAULT),
	('google', true, DEFAULT, DEFAULT);
	
	
SELECT * FROM f_create_user('lhermi_m', 'pass', 'email');
SELECT * FROM f_create_user('lee_o', 'ssap', 'email');
SELECT * FROM f_create_user('pamart_a', 'decu', 'email');