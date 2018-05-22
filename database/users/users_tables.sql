/********************************************************
************************* USERS *************************
********************************************************/

DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS account_types CASCADE;

CREATE TABLE account_types
(
	name 				VARCHAR(128)		NOT NULL,

	login_required		BOOLEAN				NOT NULL		DEFAULT		FALSE,
	email_required 		BOOLEAN				NOT NULL		DEFAULT		FALSE,
	password_required	BOOLEAN				NOT NULL		DEFAULT		FALSE,

	PRIMARY	KEY	(name)
);

CREATE TABLE users
(
	/* Primary key */
	id					SERIAL 				NOT NULL,

	/* Account */
	account_type		VARCHAR(128)						DEFAULT		'regular',
	
	login				VARCHAR(256),

	email 				VARCHAR(256)						DEFAULT		NULL,
	email_verified 		BOOLEAN				NOT NULL		DEFAULT		FALSE,

	password 			VARCHAR(256)						DEFAULT		NULL,

	deleted				BOOLEAN				NOT	NULL		DEFAULT		FALSE,

	ionis				BOOLEAN				NOT NULL		DEFAULT		FALSE,
	epita				BOOLEAN				NOT NULL		DEFAULT		FALSE,
	/* Authority level */
	authority			VARCHAR(128)		NOT NULL		DEFAULT		'user',

	/* User data */
	firstname			VARCHAR(256)		NOT NULL		DEFAULT		'',
	lastname			VARCHAR(256)		NOT NULL		DEFAULT		'',
	address				VARCHAR(1024)		NOT NULL		DEFAULT		'',
	phone_number		VARCHAR(32)			NOT NULL		DEFAULT		'',
	
	creation_date		TIMESTAMP			NOT NULL		DEFAULT		LOCALTIMESTAMP,
	deletion_date		TIMESTAMP							DEFAULT		NULL,

	PRIMARY	KEY	(id),
	UNIQUE		(account_type, login),
	FOREIGN	KEY	(account_type)	REFERENCES	account_types(name),
	CHECK		(authority IN ('user', 'moderator', 'administrator'))
);

CREATE TABLE connection_history
(
	id					SERIAL 				NOT NULL,

	user_id				INTEGER				NOT NULL,
	connection_time		TIMESTAMP			NOT NULL		DEFAULT		LOCALTIMESTAMP,

	PRIMARY	KEY	(id)
);

CREATE TABLE modification_history
(
	id					SERIAL 				NOT NULL,

	user_id				INTEGER				NOT NULL,
	modification_time	TIMESTAMP			NOT NULL		DEFAULT		LOCALTIMESTAMP,
	modification_type	VARCHAR(1024)		NOT NULL		DEFAULT		'Password changed.',

	PRIMARY	KEY	(id)
);