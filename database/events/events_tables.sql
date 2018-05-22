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
	assoc				VARCHAR(128)		NOT NULL,

	/* Administration */
	moderator_approved		BOOLEAN			NOT NULL		DEFAULT FALSE,
	president_approved		BOOLEAN			NOT NULL		DEFAULT FALSE,
	deleted					BOOLEAN			NOT NULL		DEFAULT FALSE,
	creation_date			TIMESTAMP		NOT NULL,
	deletion_date			TIMESTAMP,

	PRIMARY	KEY	(id),
	FOREIGN	KEY	(assoc)	REFERENCES	assocs(name)
);

CREATE TABLE prices
(
	event_id			INTEGER				NOT NULL,
	price_name			VARCHAR(128)		NOT NULL,
	price_value			REAL				NOT NULL,
	
	assoc_only			BOOLEAN				NOT NULL		DEFAULT FALSE,
	epita_only			BOOLEAN				NOT NULL		DEFAULT FALSE,

	PRIMARY KEY (event_id, price_name),
	FOREIGN	KEY	(event_id)	REFERENCES	events(id)
);

CREATE TABLE partners
(
	event_id			INTEGER				NOT NULL,
	assoc				VARCHAR(128)		NOT NULL,

	PRIMARY	KEY	(event_id, assoc),
	FOREIGN	KEY	(assoc)	REFERENCES	assocs(name),
	FOREIGN	KEY	(event_id)	REFERENCES	events(id)
);

CREATE TABLE participants
(
	id					SERIAL				NOT NULL,
	event_id			INTEGER				NOT NULL,
	user_id				INTEGER				NOT NULL,
	staff				BOOLEAN				NOT NULL,
	validated			BOOLEAN				NOT NULL		DEFAULT FALSE,

	PRIMARY KEY (id),
	UNIQUE	(event_id, user_id),
	FOREIGN	KEY	(event_id)	REFERENCES	events(id),
	FOREIGN	KEY	(user_id)	REFERENCES	users(id)
);

CREATE TABLE modification_history
(
	id					SERIAL 				NOT NULL,

	event_id			INTEGER				NOT NULL,
	modification_time	TIMESTAMP			NOT NULL		DEFAULT		LOCALTIMESTAMP,
	modification_type	VARCHAR(1024)		NOT NULL		DEFAULT		'Event informations changed.',

	PRIMARY	KEY	(id)
);

CREATE TABLE payment_history
(
	id					SERIAL 				NOT NULL,

	user_id				INTEGER				NOT NULL,
	event_id			INTEGER				NOT NULL,
	payment_date		TIMESTAMP			NOT NULL		DEFAULT		LOCALTIMESTAMP,
	amount				REAL				NOT NULL,

	PRIMARY	KEY	(id)
);