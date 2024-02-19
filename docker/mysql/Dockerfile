FROM mysql:latest

EXPOSE 3306

# カスタム設定ファイルをコピー
COPY ./conf.d /etc/mysql/conf.d
# データベースの初期化用SQLファイルをコピー
COPY ./initdb.d/init.sql /docker-entrypoint-initdb.d/init.sql

CMD ["mysqld"]