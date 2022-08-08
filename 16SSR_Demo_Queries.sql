SELECT * FROM reader_info_composite
WHERE home_library = 'Lancaster Public Library';

SELECT r.full_name_reader, a.age, p.*
FROM reader r, reader_age_level a, reader_progress p
WHERE r.reader_uuid = a.reader_uuid AND a.reader_uuid = p.reader_uuid
AND age >=9
ORDER BY a.age;


SELECT * FROM reader
WHERE home_library = 'Ephrata Public Library';

DELETE FROM reader
WHERE full_name_reader = 'Susy Ciric';

SELECT * FROM reader_archive;

insert into reader (user_id, reader_school, full_name_reader, date_of_birth, mailing_address_reader, city_reader, state_abbr_reader, zip5_reader, zip4_reader, home_library) values ('a1c8a495-602b-4d6d-9083-cd36862ffeac', 'Solanco HS', 'Aaron Adams', '7/15/2009', null, 'Sadsbury Township', 'PA', 17322, 7636, 'Shuts Environmental Library');


SELECT * FROM reader WHERE full_name_reader = 'Gery Stiegars';





