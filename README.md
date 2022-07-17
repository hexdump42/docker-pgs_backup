hexdump42/docker-pgs_backup
===========================

Docker image to backup postgresql database using pg_dump & optionally copy to S3 bucket.

## Usage

Connect to a remote postgres server or attach a target postgres container to this container, and mount a volume to container's `/backup` folder. Backups will appear in this volume. The backup is created as a directory-format archive suitable for input into pg_restore.

If AWS auth & bucket environment variables are provided, the backup archive will be copied to the S3 bucket.

## Environment Variables:
| Variable | Required? | Default | Description |
| -------- |:--------- |:------- |:----------- |
| `PGUSER` | Required | postgres | The user for accessing the database |
| `PGPASSWORD` | Optional | `None` | The password for accessing the database |
| `PGDB` | Optional | postgres | The name of the database |
| `PGHOST` | Optional | db | The hostname of the database |
| `PGPORT` | Optional | `5432` | The port for the database |
| `DELETE_OLDER_THAN` | Optional | `None` | Optionally, delete files older than `DELETE_OLDER_THAN` minutes. Do not include `+` or `-`. |
| `AWS_ACCESS_KEY` | Required for copy to S3 | `None` | Access key for AWS IAM user that has permission to create/update an object in the target bucket |
| `AWS_SECRET_KEY` | Required for copy to S3 | `None` | Secret key for AWS IAM user |
| `AWS_BUCKET` | Required for copy to S3 | `None` | S3 bucket name |
| `AWS_PREFIX` | Optional | `None` | Text prefixed to the name of the copied file |

Example:
```
postgres-backup:
  image: hexdump42/docker-pgs_backup
  container_name: postgres-backup
  links:
    - postgres:db #Maps postgres as "db"
  environment:
    - PGUSER=postgres
    - PGPASSWORD=SumPassw0rdHere
    - DELETE_OLDER_THAN=1 #Optionally delete backup directories & files older than $DELETE_OLDER_THAN minutes.
  #  - PGDB=postgres # The name of the database to backup
  #  - PGHOST=db # The hostname of the PostgreSQL database to backup
  volumes:
    - /backup
  command: backup
```

Run backup & exit, use "mybackup" as backup file prefix, shell will ask for password:

    docker run -ti --rm \
        -v /path/to/target/folder:/backup \   # where to put db backups
        -e PREFIX=mybackup \
        --link my-postgres-container:db \   # linked container running postgresql
        hexdump42/docker-pgs_backup backup

Run backup, copy archive file to s3 bucket & exit. Use "mybackup" as backup file prefix:

    docker run -ti --rm \
        -v /path/to/target/folder:/backup \   # where to put db backups
        -e PREFIX=mybackup \
        -e PGPASSWORD=NotSoSecretPassword
        -e AWS_ACCESS_KEY=AAAG012345EEE
        -e AWS_SECRET_KEY=abcdefgh9876543210
        -e AWS_BUCKET=my-bucket
        -e AWS_PREFIX=20220101/
        --link my-postgres-container:db \   # linked container running postgresql
        hexdump42/docker-pgs_backup backup