#!/bin/bash

#
# drop-database.sh
# Sam Matthews
# Drop Postgres database and user, including tables.
#

DBNAME=${APP_NAME}

echo "Create Postgres Database"
sudo -u postgres createdb ${DBNAME}

psql << EOF

		CREATE DATABASE ${APP_NAME} WITH owner = 'sam'SELECT FROM load_stg_table('$FILE', '$CURR_DATE');

EOF

ERR_STATUS=$?
if [[ ${ERR_STATUS} -ne 0 ]]; then
  echo "Error: $0: Error creating database."
  exit 10
fi




