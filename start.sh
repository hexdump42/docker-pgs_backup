#!/bin/bash

set -e

COMMAND=${1:-backup}
PREFIX=${PREFIX:-backup}
PGUSER=${PGUSER:-postgres}
PGDB=${PGDB:-postgres}
PGHOST=${PGHOST:-db}
PGPORT=${PGPORT:-5432}


if [[ "$COMMAND" == 'backup' ]]; then
    exec /app/backup.sh
else
    echo "Unknown command $COMMAND"
    echo "Available commands: backup"
    exit 1
fi