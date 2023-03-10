#!/bin/bash

## install packages: postgresql-15 php8.2-pgsql postgresql-server-dev-all
# sudo -i -u postgres
# createuser --interactive
# createdb datadbname
# dropdb mydb
## enter sql commands
# psql -U dbusername -W

## create dbs
# psql
# alter user "dbusername" with password 'pass';
# grant all privileges on database "datadbname" to "dbusername";
# commit

set -e

IFS=' ' read -r -a dbtargets <<< "$DBNAMES"
params="-b -C -Fc -Z 6"

if [ "$1" = "restore" ]; then
        echo "restoring backups"
        for dbname in "${dbtargets[@]}"; do
                echo "restoring $dbname with pg_restore"
                # add pgrestore
                # pg_restore -C -d $dbname $dbname.db.backup
        done
else
        for dbname in "${dbtargets[@]}"; do
                echo "backing up $dbname with pg_dump"
                pg_dump $params $dbname > $dbname.db.backup
        done
fi