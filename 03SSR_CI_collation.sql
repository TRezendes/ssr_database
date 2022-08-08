/* With thanks to user8870331 at https://stackoverflow.com/a/59101567/16832874 */

CREATE COLLATION case_insensitive (
      provider = icu,
      locale = 'und-u-ks-level2',
      deterministic = false
);
COMMENT ON COLLATION case_insensitive IS $colcom$This collation allows for username search from the app (for the purposes of checking uniqueness at registration and for logging in) to be case insensitive while still allowing the preferred capitalization of Users' usernames. With thanks to user8870331 at https://stackoverflow.com/a/59101567/16832874 for the details.$colcom$;

ALTER TABLE login_info
ALTER COLUMN username SET DATA TYPE text COLLATE case_insensitive;