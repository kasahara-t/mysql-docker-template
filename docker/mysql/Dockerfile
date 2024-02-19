FROM mysql:latest

EXPOSE 3306

# カスタム設定ファイルをコピー
COPY ./conf.d /etc/mysql/conf.d
# データベースの初期化用SQLファイルをコピー
COPY ./initdb.d /docker-entrypoint-initdb.d

CMD ["mysqld"]