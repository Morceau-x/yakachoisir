./drop.sh

echo $(psql -h localhost -U postgres  <<< "
CREATE DATABASE ticket;
\c ticket

\i users/users_tables.sql
\i users/users_functions.sql
\i users/users_data.sql

\i assoc/assoc_tables.sql
\i assoc/assoc_functions.sql
\i assoc/assoc_data.sql

\i events/events_tables.sql
\i events/events_functions.sql
\i events/events_data.sql

\q
")