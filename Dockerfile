FROM alpine
ENV DB_NAME=
ENV MONGO_HOST=
ENV BACKUP_FOLDER=
ENV ARCHIVE_NAME=
ENV DATE_DIR_FILE=

RUN apk add mongodb-tools

COPY mongoBackup.sh /
RUN chmod 700 mongoBackup.sh

WORKDIR /

# The double quotes around $@ ensure that a parameter containing is transfered as a single parameter to mongoBackup.sh
ENTRYPOINT ["/bin/ash", "-c", "$0 \"$@\"", "./mongoBackup.sh"]
