INSERT INTO schools VALUES
	('EPITA', 'École Pour l Informatique et les Techniques Avancées', '');
	

SELECT * FROM f_create_assoc('lhermi_m', 'Nova', 'On aime se raser la tete', 'EPITA');

SELECT * FROM f_set_president('lhermi_m', 'lee_o', 'Nova');
SELECT * FROM f_set_desk('lee_o', 'pamart_a', 'Nova');
SELECT * FROM f_set_desk('pamart_a', 'lee_o', 'Nova');
SELECT * FROM f_set_desk('pamart_a', 'boulay_v', 'Nova');
SELECT * FROM f_set_member('pamart_a', 'boulay_v', 'Nova');