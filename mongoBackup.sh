#!/bin/ash

set -o pipefail

function cleanup()
{
    # Kill the background task if it exists before removing the backup file
    kill %1 2> /dev/null
    if [ -f $BACKUP_FILE ]; then
        rm -f $BACKUP_FILE
    fi
    exit 2
}

trap 'cleanup' SIGINT
trap 'cleanup' SIGTERM

# Read parameters from command line if there are at least one parameters.
# Otherwise, the environment variables are assumed to be already defined.
if [ -n "$1" ]; then
    DB_NAME="$1"
    MONGO_HOST="$2"
    BACKUP_FOLDER="$3"
    ARCHIVE_NAME="$4"
fi

# Verify if arguments exist
ERR=0
if [ -z "$DB_NAME" ]; then
    echo 'Error. No Database name specified.'
    ERR=1
fi
if [ -z "$MONGO_HOST" ]; then
    echo 'Error. No host specified.'
    ERR=1
fi
if [ -z "$BACKUP_FOLDER" ]; then
    echo 'Error. No backup folder specified.'
    ERR=1
fi
if [ -z "$ARCHIVE_NAME" ]; then
    echo 'Error. No archive name specified.'
    ERR=1
fi

# Verify if backup volume exist.
if [ ! -d /media/backup ]; then
    echo 'Error: /media/backup is not a directory. A volume should be mounted at that location.'
    ERR=1
fi

if [ $ERR = 1 ]; then
     exit 3
fi;

echo '----------------------------------------'
echo 'Begin Mongo backup.'

# Create directory if it doesn't exist.
mkdir -p /media/backup/$BACKUP_FOLDER
# Backup the databases specified
BACKUP_FILE=/media/backup/$BACKUP_FOLDER/${ARCHIVE_NAME}_$(date +%Y-%m-%d_%H-%M-%S).bson.bz2
mongodump --host=$MONGO_HOST --db=$DB_NAME --archive | bzip2 -cz9 > $BACKUP_FILE &
# The process is started in background and we wait for its completion. This allow the script to treat a signal
# immediatly instead of waiting for the end of the command.
wait $!

ERR_CODE="$?"
if [ "$ERR_CODE" != 0 ]; then
    echo "Mongo backup failed with error code $ERR_CODE"
else
    echo 'Mongo backup completed.'
fi
echo -e '----------------------------------------\n'
