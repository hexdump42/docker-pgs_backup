hexdump42/docker-pgs_backup
===========================

Docker image to backup postgresql database using pg_dump run as a startup task. 

## Usage

Attach a target postgres container to this container and mount a volume to container's `/backup` folder. Backups will appear in this volume. The backup is created as a directory-format archive suitable for input into pg_restore.

## Environment Variables:
| Variable | Required? | Default | Description |
| -------- |:--------- |:------- |:----------- |
| `PGUSER` | Required | postgres | The user for accessing the database |
| `PGPASSWORD` | Optional | `None` | The password for accessing the database |
| `PGDB` | Optional | postgres | The name of the database |
| `PGHOST` | Optional | db | The hostname of the database |
| `PGPORT` | Optional | `5432` | The port for the database |
| `DELETE_OLDER_THAN` | Optional | `None` | Optionally, delete files older than `DELETE_OLDER_THAN` minutes. Do not include `+` or `-`. |

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

Run backup once & exit, use "mybackup" as backup file prefix, shell will ask for password:

    docker run -ti --rm \
        -v /path/to/target/folder:/backup \   # where to put db backups
        -e PREFIX=mybackup \
        --link my-postgres-container:db \   # linked container running postgresql
        hexdump42/docker-pgs_backup backup