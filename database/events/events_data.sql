SELECT * FROM f_create_event('boulay_v', 'Nova Genesis', '','2018-06-27 22:00:00', '2017-06-28 06:00:00', 'Nova');
SELECT * FROM f_create_event('lhermi_m', 'RIP', 'MyRPGMaker','2018-06-27 22:00:00', '2017-06-28 06:00:00', 'Nova');
SELECT * FROM f_create_event('imtheboss', 'TC', '','2017-06-27 22:00:00', '2017-06-28 06:00:00', 'Nova');
SELECT * FROM f_create_event('imtheboss', 'PARTYYY', 'COOOL', '2000-06-28 06:00:00', '2020-06-28 06:00:00', 'Nova');

UPDATE events SET (moderator_approved, president_approved) = (TRUE, TRUE);

SELECT * FROM f_add_participant('boulay_v', 'RIP');
SELECT * FROM f_add_participant('lee_o', 'RIP');
SELECT * FROM f_add_participant('lhermi_m', 'RIP');
SELECT * FROM f_add_participant('imtheboss', 'TC');


SELECT * FROM f_add_participant('boulay_v', 'PARTYYY');
SELECT * FROM f_add_participant('pamart_a', 'PARTYYY');
SELECT * FROM f_add_participant('lee_o', 'PARTYYY');
SELECT * FROM f_add_participant('imtheboss', 'PARTYYY');