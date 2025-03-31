#!/bin/bash
set -e

POSTGRES_DB=${POSTGRES_DB:-postgres}

wait_for_postgres() {
    until psql -U postgres -c "SELECT 1" >/dev/null 2>&1; do
        echo "Waiting for PostgreSQL to start..."
        sleep 2
    done
}

wait_for_postgres

echo "Configuring cron.database_name to: $POSTGRES_DB"
psql -U postgres -d postgres -c "ALTER SYSTEM SET cron.database_name = '$POSTGRES_DB';"
psql -U postgres -d postgres -c "SELECT pg_reload_conf();"

echo "Restarting PostgreSQL server to apply changes..."
pg_ctl -D /var/lib/postgresql/data -m fast -w restart

wait_for_postgres

echo "Installing pg_cron for database: $POSTGRES_DB"
psql -U postgres -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS pg_cron;"

for task in "VACUUM" "ANALYZE"; do
    if ! psql -U postgres -d "$POSTGRES_DB" -tc "SELECT 1 FROM cron.job WHERE command = '$task'" | grep -q 1; then
        schedule_time="0 $((3 + (${task} == "ANALYZE"))) * * *"
        echo "Scheduling $task for database: $POSTGRES_DB"
        psql -U postgres -d "$POSTGRES_DB" -c "SELECT cron.schedule('$schedule_time', '$task');"
    else
        echo "$task job already exists for database: $POSTGRES_DB"
    fi
done

