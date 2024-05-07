# https://hub.docker.com/_/golang
FROM golang:1.22-alpine

WORKDIR /app

# マイグレーションツールのインストール
RUN go install -tags 'mysql' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

# マイグレーションファイルのコピー
COPY ./histories /app/histories
# マイグレーションスクリプトのコピー
COPY ./migrate.sh /app/migrate.sh
RUN chmod +x /app/migrate.sh

RUN adduser -D nonrootuser
USER nonrootuser

CMD ["sh", "migrate.sh"]
