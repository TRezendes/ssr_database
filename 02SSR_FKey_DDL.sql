ALTER TABLE reader 
	ADD CONSTRAINT fkey_reader_school FOREIGN KEY(reader_school) REFERENCES school(school_name),
	ADD CONSTRAINT fkey_reader_user FOREIGN KEY(user_id) REFERENCES user_info(user_id)
;

ALTER TABLE school 
	ADD CONSTRAINT fkey_school_district FOREIGN KEY(district_name) REFERENCES school_district(district_name)
;	

ALTER TABLE staff 
	ADD CONSTRAINT fkey_staff_user FOREIGN KEY(user_id) REFERENCES user_info(user_id),
	ADD CONSTRAINT fkey_staff_library FOREIGN KEY(employer) REFERENCES library(library_name)
;

ALTER TABLE user_info
	ADD CONSTRAINT fkey_user_login FOREIGN KEY(user_id) REFERENCES login_info(uuid)
;
	