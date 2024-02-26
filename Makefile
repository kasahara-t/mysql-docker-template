ROOT_DIR := $(shell git rev-parse --show-toplevel)
SECRETS_DIR := $(ROOT_DIR)/docker/mysql/secrets
DEFAULT_DB_NAME := default_database
DEFAULT_USER_NAME := default_user

.PHONY: database.txt user.txt root_password.txt password.txt init-database install-tools init

database.txt:
	@echo "Creating database.txt"; \
	echo "Enter the database name (Press enter for default: $(DEFAULT_DB_NAME)):"; \
	read database; \
	database=$${database:-$(DEFAULT_DB_NAME)}; \
	echo "$$database" > $(SECRETS_DIR)/database.txt

user.txt:
	@echo "Creating user.txt"; \
	echo "Enter the user name (Press enter for default: $(DEFAULT_USER_NAME)):"; \
	read username; \
	username=$${username:-$(DEFAULT_USER_NAME)}; \
	echo "$$username" > $(SECRETS_DIR)/user.txt

root_password.txt:
	@echo "Creating root_password.txt"; \
	echo "Enter the root password (Press enter for a random value):"; \
	read root_password; \
	root_password=$${root_password:-$$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)}; \
	echo "$$root_password" > $(SECRETS_DIR)/root_password.txt

password.txt:
	@echo "Creating password.txt"; \
	echo "Enter the password (Press enter for a random value):"; \
	read password; \
	password=$${password:-$$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)}; \
	echo "$$password" > $(SECRETS_DIR)/password.txt

install-tools:
	@while read line; do \
		lang=$$(echo $$line | cut -d ' ' -f1); \
		version=$$(echo $$line | cut -d ' ' -f2); \
		asdf plugin add $$lang || true; \
		asdf install $$lang $$version; \
		asdf local $$lang $$version; \
	done < .tool-versions

init-database: database.txt user.txt root_password.txt password.txt
	@echo "Initialization of database settings complete."

init: install-tools init-database
	@echo "Initialization complete."
