FROM mysql:latest

EXPOSE 3306

# 初期化スクリプトをコピー
COPY ./initdb.d /docker-entrypoint-initdb.d

# カスタム設定ファイルをコピー
COPY ./conf.d /etc/mysql/conf.d

CMD ["mysqld"]
