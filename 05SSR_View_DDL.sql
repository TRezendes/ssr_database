/* Calculates program statistics by library */

CREATE VIEW library_statistics AS
    SELECT home_library AS library,
        count(reader_uuid) AS total_readers,
        sum(goals_completed::integer) AS readers_completed,
        avg(age)::numeric(4, 1) AS average_age,
        sum(time_read) AS total_time_read,
        sum(books_read) AS total_books_read,
        sum(activities_completed) AS total_activities_completed
    FROM reader_info_composite
    GROUP BY home_library
;

/* Allows for association of prizes with the Reader Levels they apply to in a many to many relationship. */

CREATE VIEW prize_level AS 
	SELECT plv.prize_uuid, plv.prize_desc, plv.sponsor_url, plv.sponsor_logo, plv.reader_level
	FROM
	((SELECT p.prize_uuid, p.prize_desc, p.sponsor_url, p.sponsor_logo, 'Level 1' AS reader_level
	FROM prize p
	WHERE 'Level 1'=ANY(p.prize_levels))
	UNION
	(SELECT p.prize_uuid, p.prize_desc, p.sponsor_url, p.sponsor_logo, 'Level 2' AS reader_level
	FROM prize p
	WHERE 'Level 2'=ANY(p.prize_levels))
	UNION
	(SELECT p.prize_uuid, p.prize_desc, p.sponsor_url, p.sponsor_logo, 'Level 3' AS reader_level
	FROM prize p
	WHERE 'Level 3'=ANY(p.prize_levels))
	UNION
	(SELECT p.prize_uuid, p.prize_desc, p.sponsor_url, p.sponsor_logo, 'Level 4' AS reader_level
	FROM prize p
	WHERE 'Level 4'=ANY(p.prize_levels))
	) AS plv
;


/* Calculates a Reader's age using their date of birth and then uses the age to associate the Reader with the approprioate Level */

CREATE VIEW reader_age_level AS
	SELECT 	r.reader_uuid,
		a.age,
		l.level AS	reader_level
	FROM
		(SELECT
				extract (year from age(date_of_birth))::int4 AS age,
				reader_uuid AS id
		FROM 	reader) AS a,
		reader AS r,
		levels AS l
	WHERE
		r.reader_uuid = a.id AND
		a.age <@	 l.age_range
;


/* Associates a Reader with the program Goals appropriate to their Level */

CREATE VIEW reader_goal AS
	SELECT 	r.reader_uuid,
			r.reader_level,
			g.minutes_to_read,
			g.books_to_read,
			g.number_of_activities,
			g.question_1,
			g.question_2,
			g.question_3
	FROM		reader_age_level AS r,
			goal AS g
	WHERE	r.reader_level = g.goal_level
;


/* Compiles information about Readers from various tables to be used for calculating program statistics */

CREATE VIEW reader_info_composite AS
SELECT r.reader_uuid, r.home_library, r.reader_school, r.city_reader, r.state_abbr_reader, r.zip5_reader, a.age, p.time_read, p.books_read, p.activities_completed, p.goals_completed
	FROM reader r
		LEFT JOIN reader_age_level a ON r.reader_uuid = a.reader_uuid
		LEFT JOIN reader_progress p ON a.reader_uuid = p.reader_uuid
;
		
		
/* Calculates summary statistics about the summer reading program. */

CREATE VIEW summary_statistics AS
SELECT a3.total_readers, a3.total_time_read, a4.average_time_read, a3.total_books_read, a3.average_age
	FROM
	(SELECT count(a1.reader_uuid) AS total_readers, sum(a1.time_read) AS total_time_read, sum(a1.books_read) AS total_books_read, avg(a1.age)::numeric(4,1) AS average_age
	FROM
		(SELECT r.reader_uuid, r.home_library, r.reader_school, r.city_reader, r.state_abbr_reader, r.zip5_reader, a.age, p.time_read, p.books_read, p.activities_completed
			FROM reader r
				LEFT JOIN reader_age_level a ON r.reader_uuid = a.reader_uuid
				LEFT JOIN reader_progress p ON a.reader_uuid = p.reader_uuid) as a1) as a3,
	(SELECT avg(COALESCE(a2.time_read, '00:00:00')) AS average_time_read
		FROM
		(SELECT p.time_read, r.reader_uuid
			FROM reader r
				LEFT JOIN reader_age_level a ON r.reader_uuid = a.reader_uuid
				LEFT JOIN reader_progress p ON a.reader_uuid = p.reader_uuid
				WHERE r.reader_uuid = a.reader_uuid AND a.reader_level IN ('Level 2', 'Level 3', 'Level 4')) AS a2) as a4
;

/* Allows a ZIP Code to be used to associate a Reader with their Home Library. */

CREATE VIEW	zip_service_library AS
	SELECT	l.service_area AS service_area_code,
			m.zip_code,
			m.municipality_name,
			l.library_name
	FROM	 	library AS l,
			municipality AS m
	WHERE	l.service_area = m.service_area_code
	ORDER BY m.municipality_name
;				
				

