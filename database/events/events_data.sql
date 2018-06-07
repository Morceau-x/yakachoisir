SELECT * FROM f_create_event('boulay_v', 'Nova Genesis', '','2018-06-27 22:00:00', '2017-06-28 06:00:00', 'Nova');
SELECT * FROM f_create_event('lhermi_m', 'RIP', 'MyRPGMaker','2018-06-27 22:00:00', '2017-06-28 06:00:00', 'Nova');
SELECT * FROM f_create_event('imtheboss', 'TC', '','2017-06-27 22:00:00', '2017-06-28 06:00:00', 'Nova');
SELECT * FROM f_create_event('imtheboss', 'PARTYYY', 'COOOL', '2000-06-28 06:00:00', '2020-06-28 06:00:00', 'Nova');

SELECT * FROM f_create_event('imtheboss', 'too early', 'COOOL', '2018-06-03 00:00:01', '2018-06-05 10:00:00', 'Nova');
SELECT * FROM f_create_event('imtheboss', 'monday', 'COOOL', '2018-06-04 00:00:01', '2018-06-05 10:00:00', 'Nova');
SELECT * FROM f_create_event('imtheboss', 'sunday', 'COOOL', '2018-06-10 23:00:00', '2018-06-11 0:00:00', 'Nova');
SELECT * FROM f_create_event('imtheboss', 'too late', 'COOOL', '2018-06-11 00:00:01', '2018-06-11 10:00:00', 'Nova');

SELECT * FROM f_create_price('lhermi_m', 'Nova Genesis', 'interne', 10, 200, FALSE, FALSE, TRUE);
SELECT * FROM f_create_price('lhermi_m', 'RIP', 'externe', 10, 100, FALSE, FALSE, FALSE);
SELECT * FROM f_create_price('lhermi_m', 'RIP', 'interne', 10, 200, FALSE, FALSE, TRUE);
SELECT * FROM f_create_price('lhermi_m', 'TC', 'interne', 10, 200, FALSE, FALSE, TRUE);
SELECT * FROM f_create_price('lhermi_m', 'PARTYYY', 'interne', 10, 200, FALSE, FALSE, TRUE);

UPDATE events SET (moderator_approved, president_approved) = (TRUE, TRUE);

SELECT * FROM f_add_participant('boulay_v', 'RIP', 'interne');
SELECT * FROM f_add_participant('lee_o', 'RIP', 'interne');
SELECT * FROM f_add_participant('lhermi_m', 'RIP', 'interne');
SELECT * FROM f_add_participant('imtheboss', 'TC', 'interne');

SELECT * FROM f_add_participant('boulay_v', 'PARTYYY', 'interne');
SELECT * FROM f_add_participant('pamart_a', 'PARTYYY', 'interne');
SELECT * FROM f_add_participant('lee_o', 'PARTYYY', 'interne');
SELECT * FROM f_add_participant('imtheboss', 'PARTYYY', 'interne');