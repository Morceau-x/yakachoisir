/********************************************************
********************** ASSOCIATIONS *********************
********************************************************/

CREATE TABLE schools
(
	shortname			VARCHAR(128)		NOT NULL,
	fullname			VARCHAR(1024)		NOT NULL,
	description			VARCHAR(8192)		NOT NULL,
	-- logo

	PRIMARY KEY (shortname)
);

CREATE TABLE assocs
(
	name				VARCHAR(1024),
	summary				VARCHAR(8192)		NOT	NULL		DEFAULT	'',
	school				VARCHAR(128)		NOT	NULL,
	
	deleted				BOOLEAN				NOT NULL		DEFAULT FALSE,
	
	creation_date		TIMESTAMP			NOT NULL		DEFAULT		LOCALTIMESTAMP,
	deletion_date		TIMESTAMP							DEFAULT		NULL,
	
	president			INTEGER,

	PRIMARY	KEY	(name),
	FOREIGN	KEY	(president)	REFERENCES	users(id),
	FOREIGN KEY	(school)	REFERENCES	schools(shortname)
);

CREATE TABLE members
(
	assoc				VARCHAR(1024)		NOT NULL,
	member				INTEGER				NOT NULL,
	desk				BOOLEAN				NOT NULL		DEFAULT FALSE,

	PRIMARY	KEY	(assoc, member),
	FOREIGN	KEY	(assoc)		REFERENCES	assocs(name),
	FOREIGN	KEY	(member)	REFERENCES	users(id)
);

CREATE TABLE members_history
(
	id					SERIAL 				NOT NULL,

	user_id				INTEGER				NOT NULL,
	modification_time	TIMESTAMP			NOT NULL		DEFAULT		LOCALTIMESTAMP,
	modification_type	VARCHAR(1024)		NOT NULL		DEFAULT		'Member joined.',

	PRIMARY	KEY	(id)
);