FROM mysql:latest

EXPOSE 3306

# データベースの初期化用SQLファイルをコピー
COPY ./initdb.d/init.sql /docker-entrypoint-initdb.d/init.sql

CMD ["mysqld"]