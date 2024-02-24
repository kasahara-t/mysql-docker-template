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

# MySQLに接続確認
echo "Waiting for MySQL to start..."
retries=25
tries=0
until mysql -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" -e "show databases;" &> /dev/null; do
    if [ "$tries" -eq "$retries" ]; then
        >&2 echo "Failed to connect to MySQL after $retries retries - exiting"
        exit 1
    fi
    >&2 echo "MySQL is unavailable - sleeping"
    sleep 1
    tries=$((tries + 1))
done
echo "MySQL is up - executing command"

# マイグレーションの実行
migrate -path /app/histories -database "mysql://${USER}:${PASSWORD}@tcp(${HOST}:${PORT})/${DATABASE}?multiStatements=true" up