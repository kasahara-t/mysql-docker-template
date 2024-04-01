#!/bin/sh

# mysql接続情報の取得
HOST="${MYSQL_HOST:-localhost}"
PORT="${MYSQL_PORT:-3306}"
USER="${MYSQL_USER:-root}"
PASSWORD="${MYSQL_PASSWORD:-}"
DATABASE="${MYSQL_DATABASE:-}"

# _fileの環境変数があればそれを優先
if [ -n "$MYSQL_USER_FILE" ] && [ -f "$MYSQL_USER_FILE" ]; then
    USER=$(cat "$MYSQL_USER_FILE")
fi
if [ -n "$MYSQL_PASSWORD_FILE" ] && [ -f "$MYSQL_PASSWORD_FILE" ]; then
    PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
fi
if [ -n "$MYSQL_DATABASE_FILE" ] && [ -f "$MYSQL_DATABASE_FILE" ]; then
    DATABASE=$(cat "$MYSQL_DATABASE_FILE")
fi

# マイグレーションの実行
migrate -path /app/histories -database "mysql://${USER}:${PASSWORD}@tcp(${HOST}:${PORT})/${DATABASE}?multiStatements=true" up