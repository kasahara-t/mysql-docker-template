#!/bin/sh

# Set the environment variables
HOST="${MYSQL_HOST:-localhost}"
PORT="${MYSQL_PORT:-3306}"
USER="${MYSQL_USER:-root}"
PASSWORD="${MYSQL_PASSWORD:-}"
DATABASE="${MYSQL_DATABASE:-}"

# If the environment variables are set in a file, use them
if [ -n "$MYSQL_USER_FILE" ] && [ -f "$MYSQL_USER_FILE" ]; then
    USER=$(cat "$MYSQL_USER_FILE")
fi
if [ -n "$MYSQL_PASSWORD_FILE" ] && [ -f "$MYSQL_PASSWORD_FILE" ]; then
    PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
fi
if [ -n "$MYSQL_DATABASE_FILE" ] && [ -f "$MYSQL_DATABASE_FILE" ]; then
    DATABASE=$(cat "$MYSQL_DATABASE_FILE")
fi

URL="mysql://${USER}:${PASSWORD}@tcp(${HOST}:${PORT})/${DATABASE}?multiStatements=true"

# Run the migrations
migrate -path /app/histories -database $URL up