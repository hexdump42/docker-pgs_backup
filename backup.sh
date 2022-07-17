#!/bin/bash

set -e

echo "Backup job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/${PREFIX}-${DATE}"

pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -f "$BACKUP_DIR" -d "$PGDB" -Fd
tar -cvf ${BACKUP_DIR}.tar ${BACKUP_DIR}/

if [ ! -z "$AWS_ACCESS_KEY" ]; then
	s3cmd put ${BACKUP_DIR}.tar s3://${AWS_BUCKET}/${AWS_PREFIX}
fi

if [ ! -z "$DELETE_OLDER_THAN" ]; then
	echo "Deleting old backups: $DELETE_OLDER_THAN"
	find /dump/* -mmin "+$DELETE_OLDER_THAN" -exec rm {} \;
fi

echo "Backup job finished: $(date)"