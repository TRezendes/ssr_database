/* When a new Reader is registered, initialize their entry in the reader_progress table. */

CREATE OR REPLACE FUNCTION AddToProgressFunc()
	RETURNS trigger
	AS $AddToProgress$
		BEGIN
			INSERT INTO reader_progress (reader_uuid)
			SELECT NEW.reader_uuid;
			RETURN NULL;
		END;
	$AddToProgress$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER AddToProgressTrigger
	AFTER INSERT ON reader
	FOR EACH ROW EXECUTE FUNCTION AddToProgressFunc();
	
---
---
---

/* Deletes question Answers from reader_progress table upon deletion of Reader due to their potential to contain identifying information about the Reader. */

CREATE OR REPLACE FUNCTION AnswerPurgeFunc()
	RETURNS trigger
	AS $AnswerPurgeFunc$
		BEGIN
			UPDATE reader_progress
			SET	answer_1 = Null,
				answer_2 = Null,
				answer_3 = Null
			WHERE reader_progress.reader_uuid = OLD.reader_uuid;
		RETURN Null;
		END;
	$AnswerPurgeFunc$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER AnswerPurgeTrigger
	AFTER DELETE ON reader
	FOR EACH ROW EXECUTE FUNCTION AnswerPurgeFunc();
	
---
---
---

/* Inserts Reader's Home Library based on ZIP Code at the time of Reader registration. */
CREATE OR REPLACE FUNCTION HomeLibraryFunc()
	RETURNS trigger
	AS $HomeLibraryFunc$
		BEGIN
		IF NEW.zip5_reader IN (SELECT zip_code FROM zip_service_library)
		THEN NEW.home_library = (SELECT library_name
									FROM zip_service_library
									WHERE zip_service_library.zip_code = NEW.zip5_reader);
		ELSEIF NEW.zip5_reader IN (SELECT TO_CHAR(zip, 'fm00000') FROM state_zip)
		THEN NEW.home_library = (SELECT 'Out of service area. ' || state_name
									FROM state_zip
									WHERE TO_CHAR(state_zip.zip, 'fm00000') = NEW.zip5_reader);
		ELSE NEW.home_library = (SELECT 'Out of service area.');
		END IF;
		RETURN NEW;
		END;
	$HomeLibraryFunc$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER HomeLibraryTrigger
	BEFORE INSERT ON reader
	FOR EACH ROW EXECUTE FUNCTION HomeLibraryFunc();

---
---
---

/* Archives non-identifying Reader information for statistical purposes when a Reader is deleted. */

CREATE OR REPLACE FUNCTION ReaderArchiveFunc()
	RETURNS trigger
	AS $ReaderArchiveFunc$
		BEGIN
			IF OLD.reader_uuid IN (SELECT reader_uuid FROM reader_progress)
			THEN INSERT INTO reader_archive (reader_uuid, home_library, reader_school, city_reader, state_abbr_reader, zip5_reader, age_at_deletion)
				VALUES (OLD.reader_uuid, OLD.home_library, OLD.reader_school, OLD.city_reader, OLD.state_abbr_reader, OLD.zip5_reader,
					(SELECT age FROM reader_age_level
					WHERE reader_age_level.reader_uuid = OLD.reader_uuid));
			END IF;
		RETURN OLD;
		END;
	$ReaderArchiveFunc$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER ReaderArchiveTrigger
	BEFORE DELETE ON reader
	FOR EACH ROW EXECUTE FUNCTION ReaderArchiveFunc();