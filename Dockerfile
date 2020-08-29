FROM alpine
ENV DB_NAME=
ENV MONGO_HOST=
ENV BACKUP_FOLDER=
ENV ARCHIVE_NAME=

RUN apk add mongodb-tools

COPY mongoBackup.sh /
RUN chmod 700 mongoBackup.sh

WORKDIR /

# The exec call to a /bin/ash is made to be able to resolve the variables to their value. It is not Docker who process the
# environment variables, but the shell executed by Docker. With only the script name (and without exec), the string $DB_NAME 
# and other variable names are passed directly to mongoBackup.sh script without being interpreted.
ENTRYPOINT ["/bin/ash", "-c", "$0 \"$@\"", "./mongoBackup.sh"]
