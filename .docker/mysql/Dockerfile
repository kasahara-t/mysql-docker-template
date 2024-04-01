FROM mysql:latest

EXPOSE 3306

# カスタム設定ファイルをコピー
COPY ./conf.d /etc/mysql/conf.d

CMD ["mysqld"]
