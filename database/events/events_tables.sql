/********************************************************
************************* EVENTS ************************
********************************************************/

CREATE TABLE events
(
	id					SERIAL				NOT NULL,
	
	/* Infos */
	name				VARCHAR(1024)		NOT NULL,
	summary 			VARCHAR(8192)		NOT NULL		DEFAULT '',
	premium				BOOLEAN				NOT NULL		DEFAULT FALSE,
	begin_date			TIMESTAMP			NOT NULL,
	end_date			TIMESTAMP			NOT NULL,

	/* Association */
	assoc				VARCHAR(1024)		NOT NULL,
	creator				VARCHAR(256)		NOT NULL,
	
	/* Administration */
	moderator_approved		BOOLEAN			NOT NULL		DEFAULT FALSE,
	president_approved		BOOLEAN			NOT NULL		DEFAULT FALSE,
	deleted					BOOLEAN			NOT NULL		DEFAULT FALSE,
	creation_date			TIMESTAMP		NOT NULL		DEFAULT	LOCALTIMESTAMP,
	deletion_date			TIMESTAMP						DEFAULT	NULL,

	PRIMARY	KEY	(id),
	UNIQUE (name),
	FOREIGN	KEY	(assoc)	REFERENCES	assocs(name),
	FOREIGN KEY (creator) REFERENCES users(login)
);

CREATE TABLE prices
(
	id					SERIAL				NOT NULL,
	event				VARCHAR(1024)		NOT NULL,
	price_name			VARCHAR(1024)		NOT NULL,
	price_value			REAL				NOT NULL,
	max_number			INTEGER				NOT NULL,
	
	assoc_only			BOOLEAN				NOT NULL		DEFAULT FALSE,
	epita_only			BOOLEAN				NOT NULL		DEFAULT FALSE,
	ionis_only			BOOLEAN				NOT NULL		DEFAULT FALSE,

	PRIMARY KEY (id),
	UNIQUE (event, price_name),
	FOREIGN	KEY	(event)	REFERENCES	events(name)
);

CREATE TABLE partners
(
	event				VARCHAR(1024)		NOT NULL,
	assoc				VARCHAR(1024)		NOT NULL,

	PRIMARY	KEY	(event, assoc),
	FOREIGN	KEY	(assoc)	REFERENCES	assocs(name),
	FOREIGN	KEY	(event)	REFERENCES	events(name)
);

CREATE TABLE participants
(
	id					SERIAL				NOT NULL,
	event				VARCHAR(1024)		NOT NULL,
	login				VARCHAR(256)		NOT NULL,
	price				INTEGER				NOT NULL,
	
	staff				BOOLEAN				NOT NULL,
	validated			BOOLEAN				NOT NULL		DEFAULT FALSE,
	is_inside			BOOLEAN				NOT NULL		DEFAULT FALSE,
	
	PRIMARY KEY (id),
	UNIQUE	(event, login),
	FOREIGN	KEY	(event)	REFERENCES	events(name),
	FOREIGN	KEY	(login)	REFERENCES	users(login),
	FOREIGN	KEY	(price)	REFERENCES	prices(id)
);

CREATE TABLE event_modification_history
(
	id					SERIAL 				NOT NULL,

	event				VARCHAR(1024)		NOT NULL,
	modification_time	TIMESTAMP			NOT NULL		DEFAULT		LOCALTIMESTAMP,
	modification_type	VARCHAR(1024)		NOT NULL		DEFAULT		'Event informations changed.',

	PRIMARY	KEY	(id)
);

CREATE TABLE payment_history
(
	id					SERIAL 				NOT NULL,

	login				VARCHAR(256)		NOT NULL,
	event				VARCHAR(1024)		NOT NULL,
	payment_date		TIMESTAMP			NOT NULL		DEFAULT		LOCALTIMESTAMP,
	amount				REAL				NOT NULL,

	PRIMARY	KEY	(id)
);