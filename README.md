# Docker image to backup mongo databases
This image creates bz2 archive from a mongo database dump. The archive is created in location /media/backup/$BACKUP_FOLDER/$(date +%Y-%m-%d\_%H-%M-%S) with the name ${ARCHIVE\_NAME}.bson.bz2. The location /media/backup must exists in order to make the backup. It means you must mount a volume at that location.

The information to specify to make the backup can be either with environment variables or with command line arguments. The parameters are the following:
| Position | Variable   | Description                                        |
|:---:| --------------- | -------------------------------------------------- |
| 1   | $DB_NAME        | The name of the database to backup. Only one database name can be specified. |
| 2   | $MONGO_HOST     | The host address to communicate with.              |
| 3   | $BACKUP_FOLDER  | The archive file will be put inside that folder. The folder will be created if it is missing. |
| 4   | $ARCHIVE_NAME   | The name of the archive to create. The suffix .bzon.bz2 is appended.  |
| 5   | $DATE_DIR_FILE  | Indicate the file to read the date folder name where the backup will be written to. If nothing is specified, the current date in the container is taken. |

## Examples of execution
You can run the backup by specifying the parameters with environment variables.
> docker run --env DB_NAME=my_database --env MONGO_HOST=my_mongo_host --env BACKUP_FOLDER=my_mongo_backups --env ARCHIVE_NAME=my_database --network mongodb --mount src=my_test_backup,dst=/media/backup backup_mongo

You can also run the backup by specifying the parameters with command line parameters in the order DB_NAME, MONGO_HOST, BACKUP_FOLDER and ARCHIVE_PREFIX.
> docker run --network mongodb --mount src=my_test_backup,dst=/media/backup backup_mongo my_database my_mongo_host my_mongo_backups my_database
