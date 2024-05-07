# https://hub.docker.com/_/mysql
FROM mysql:latest

EXPOSE 3306

# Copy the initial SQL file for database setup
COPY ./initdb.d /docker-entrypoint-initdb.d

CMD ["mysqld"]
