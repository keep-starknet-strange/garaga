#!/bin/sh

# waits postgres to be ready
sleep 30

# applies the db schema
PGPASSWORD='indexer_password' psql -h $NETWORK-postgres -p 5432 -d indexer_db -U indexer_user -f db_schema.sql

# runs the indexer
apibara run indexer.ts --allow-env-from-env=NETWORK --allow-read=./abis/ -A $APIBARA_ACCESS_TOKEN
