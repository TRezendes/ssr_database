    activity_uuid uuid CONSTRAINT pkey_activity PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_desc text NOT NULL,
    reader_level text NOT NULL,
    activity_icon text
);
COMMENT ON COLUMN activity.activity_icon IS 'Stores the path/filename for an image to be inserted programatically via Jinja templating.';

CREATE TABLE completed_activities (
    reader_uuid uuid,
    activity_uuid uuid,
    CONSTRAINT pkey_comp_acts PRIMARY KEY (reader_uuid, activity_uuid)
);

CREATE TABLE goal (
    goal_level text CONSTRAINT pkey_goal PRIMARY KEY,
    minutes_to_read interval NOT NULL DEFAULT '00:00:00'::interval,
    number_of_activities integer NOT NULL DEFAULT 0,
    books_to_read integer DEFAULT 0,
	question_1 text,
    question_2 text,
    question_3 text
);

CREATE TABLE id_check (
	employee_id text CONSTRAINT pkey_emp_id PRIMARY KEY,
	staff_role text DEFAULT 'staff' NOT NULL
);

CREATE TABLE levels (
	level , CONSTRAINT pkey_levels PRIMARY KEY,
	age_range int4range
);

CREATE TABLE library (
	library_name text CONSTRAINT pkey_library PRIMARY KEY,
	mailing_address_library text,
	apt_box_library text,
	city_library text NOT NULL,
	state_abbr_library char(2) NOT NULL,
	zip5_library char(5) NOT NULL,
	zip4_library char(4),
	phone_number_library varchar(18),
	library_website_url text,
	library_logo text,
	service_area text
);
COMMENT ON COLUMN library.library_logo IS 'Stores the path/filename for an image to be inserted programatically via Jinja templating.';

CREATE TABLE login_info (
	uuid uuid CONSTRAINT pkey_login PRIMARY KEY DEFAULT gen_random_uuid (),
	username text UNIQUE NOT NULL,
	password_hash text NOT NULL
);

CREATE TABLE municipality (
	municipality_name text,
	service_area_code text,
	zip_code character(5),
	CONSTRAINT pkey_municipality PRIMARY KEY (municipality_name, zip_code)
);

CREATE TABLE prize (
	prize_uuid uuid CONSTRAINT pkey_prize PRIMARY KEY DEFAULT gen_random_uuid (),
	prize_desc text NOT NULL,
	sponsor_url text NOT NULL,
	sponsor_logo text,
    prize_levels text[]
);
COMMENT ON COLUMN prize.sponsor_logo IS 'Stores the path/filename for an image to be inserted programatically via Jinja templating.';

CREATE TABLE reader (
	reader_uuid uuid CONSTRAINT pkey_reader PRIMARY KEY DEFAULT gen_random_uuid (),
	user_id uuid NOT NULL,
	home_library text,
	reader_school text,
	full_name_reader text NOT NULL,
	date_of_birth date NOT NULL,
	mailing_address_reader text,
	city_reader text NOT NULL,
	state_abbr_reader char(2) NOT NULL,
	zip5_reader char(5) NOT NULL,
	zip4_reader char(4)
);
COMMENT ON COLUMN reader.full_name_reader IS 'Full Name, as opposed to First Name and Last Name. It is important to me not to run up against the "Falsehoods Programmers Believe About Names" (https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/), and in this context, a divided name field does not have much if any added utility.';

CREATE TABLE reader_archive (
    reader_uuid uuid CONSTRAINT pkey_archive PRIMARY KEY,
    home_library text,
    reader_school text,
    city_reader text,
    state_abbr_reader character(2),
    zip5_reader character(5),
    age_at_deletion integer NOT NULL
);
COMMENT ON TABLE reader_archive IS 'If a reader is deleted from the database, this table retains information useful for statistical purposes without storing any data to spcifically identify the reader.';

CREATE TABLE reader_progress (
	reader_uuid uuid CONSTRAINT pkey_progress PRIMARY KEY,
	time_read interval NOT NULL DEFAULT '00:00:00'::interval,
	books_read integer NOT NULL DEFAULT 0,
	activities_completed integer NOT NULL DEFAULT 0,
	answer_1 text,
	answer_2 text,
	answer_3 TEXT,
    goals_completed boolean NOT NULL DEFAULT false
);

CREATE TABLE school (
	nces_school char(12) CONSTRAINT pkey_school PRIMARY KEY,
	nces_dist char(7) NOT NULL,
	school_name text NOT NULL UNIQUE,
	district_name text,
	public bool NOT NULL,
	mailing_address_school text,
	city_school text NOT NULL,
	state_abbr_school char(2) NOT NULL,
	zip5_school char(5) NOT NULL,
	zip4_school char(4),
	phone_number_school varchar(18)
);
COMMENT ON TABLE school IS 'School data from the National Center for Education Statistics - https://nces.ed.gov/ccd/elsi/';

CREATE TABLE school_district (
	nces_dist char(7) CONSTRAINT pkey_school_district PRIMARY KEY,
	district_name text NOT NULL UNIQUE
);
COMMENT ON TABLE school_district IS 'School district data from the National Center for Education Statistics - https://nces.ed.gov/ccd/elsi/';

CREATE TABLE service_area (
	municipality_name TEXT CONSTRAINT pkey_serv_area PRIMARY KEY,
	service_area_code INTEGER,
	library_name text NOT NULL
);

CREATE TABLE staff (
	staff_id text CONSTRAINT pkey_staff PRIMARY KEY,
	user_id uuid,
	employer text,
	job_title text,
	staff_role text
);

CREATE TABLE state_zip (
	zip numeric(5, 0) CONSTRAINT pkey_zip PRIMARY KEY,
	state_id char(2) NOT NULL,
	state_name text NOT NULL
);
COMMENT ON TABLE state_zip IS 'State & Zip Code table adapted from SimpleMaps - https://simplemaps.com/data/us-zips. Used under a Creative Commons Attribution 4.0 International (CC BY 4.0) license - https://creativecommons.org/licenses/by/4.0/';

CREATE TABLE user_info (
	user_id uuid CONSTRAINT pkey_user PRIMARY KEY,
	full_name_user text NOT NULL,
	email_address_user text NOT NULL,
	phone_number_user text
);
COMMENT ON COLUMN user_info.full_name_user IS 'Full Name, as opposed to First Name and Last Name. It is important to me not to run up against the "Falsehoods Programmers Believe About Names" (https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/), and in this context, a divided name field does not have much if any added utility.';
