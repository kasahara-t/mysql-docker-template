ROOT_DIR := $(shell git rev-parse --show-toplevel)
SECRETS_DIR := $(ROOT_DIR)/.docker/mysql/secrets
DEFAULT_DB_NAME := mysql_docker_template
DEFAULT_USER_NAME := mysql_docker_template_user

generate_random_string = head /dev/urandom | tr -dc A-Za-z0-9 | head -c $(1)

$(SECRETS_DIR)/database.txt:
	@echo "Creating database.txt"; \
	read -p "Enter the database name (Press enter for default: $(DEFAULT_DB_NAME)): " database; \
	database=$${database:-$(DEFAULT_DB_NAME)}; \
	echo "$$database" > $(SECRETS_DIR)/database.txt

$(SECRETS_DIR)/user.txt:
	@echo "Creating user.txt"; \
	read -p "Enter the user name (Press enter for default: $(DEFAULT_USER_NAME)): " username; \
	username=$${username:-$(DEFAULT_USER_NAME)}; \
	echo "$$username" > $(SECRETS_DIR)/user.txt

$(SECRETS_DIR)/root_password.txt:
	@echo "Creating root_password.txt"; \
	read -p "Enter the root password (Press enter for a random value): " root_password; \
	root_password=$${root_password:-$$( $(call generate_random_string,13) )}; \
	echo "$$root_password" > $(SECRETS_DIR)/root_password.txt

$(SECRETS_DIR)/password.txt:
	@echo "Creating password.txt"; \
	read -p "Enter the password (Press enter for a random value): " password; \
	password=$${password:-$$( $(call generate_random_string,13) )}; \
	echo "$$password" > $(SECRETS_DIR)/password.txt

.PHONY: init-database
init-database: $(SECRETS_DIR)/database.txt $(SECRETS_DIR)/user.txt $(SECRETS_DIR)/root_password.txt $(SECRETS_DIR)/password.txt
	@echo "Initialization of database settings complete."

.env:
	@if [ ! -f $(ROOT_DIR)/.env ]; then \
		echo "Creating root .env from template"; \
		cp $(ROOT_DIR)/.env.template $(ROOT_DIR)/.env; \
	fi

.PHONY: init
init: .env init-database
	@echo "Initialization complete."