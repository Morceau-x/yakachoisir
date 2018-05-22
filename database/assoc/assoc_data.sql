INSERT INTO schools VALUES
	('EPITA', 'École Pour l Informatique et les Techniques Avancées', '');
	

SELECT * FROM f_create_assoc(f_id('lhermi_m'), 'Nova', 'On aime se raser la tete', 'EPITA');

SELECT * FROM f_set_president(f_id('lhermi_m'), f_id('lee_o'), 'Nova');
SELECT * FROM f_set_desk(f_id('lee_o'), f_id('pamart_a'), 'Nova');
SELECT * FROM f_set_desk(f_id('pamart_a'), f_id('lee_o'), 'Nova');
SELECT * FROM f_set_desk(f_id('pamart_a'), f_id('boulay_v'), 'Nova');
SELECT * FROM f_set_member(f_id('pamart_a'), f_id('boulay_v'), 'Nova');