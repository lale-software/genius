genius.sqlite

CREATE TABLE alghorithms (
	id integer NOT NULL ON CONFLICT FAIL PRIMARY KEY ON CONFLICT FAIL AUTOINCREMENT UNIQUE ON CONFLICT FAIL,
	phase integer NOT NULL ON CONFLICT FAIL
)

CREATE TABLE alg_lines (
	alg_id integer NOT NULL ON CONFLICT FAIL,
	tx_line integer NOT NULL ON CONFLICT FAIL,
	fn varchar NOT NULL ON CONFLICT FAIL,
	fn_index integer,
	op integer NOT NULL ON CONFLICT FAIL,
	sn varchar NOT NULL ON CONFLICT FAIL,
	sn_index integer,
	PRIMARY KEY (alg_id,tx_line)
)


genius_user.sqlite

CREATE TABLE scores (
	id integer NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	level integer NOT NULL ON CONFLICT ABORT,
	score integer NOT NULL ON CONFLICT ABORT,
	date date NOT NULL ON CONFLICT ABORT
)

CREATE TABLE user_data (
	id integer PRIMARY KEY ON CONFLICT FAIL AUTOINCREMENT UNIQUE ON CONFLICT FAIL,
	name text NOT NULL ON CONFLICT FAIL UNIQUE ON CONFLICT FAIL,
	value text
)

INSERT INTO user_data (name, value) VALUES ('HiScore', '0')