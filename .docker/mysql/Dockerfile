FROM mysql:latest

EXPOSE 3306

# 初期化スクリプトをコピー
COPY ./initdb.d /docker-entrypoint-initdb.d

CMD ["mysqld"]
