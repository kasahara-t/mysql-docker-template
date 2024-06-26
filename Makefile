ROOT_DIR := $(shell git rev-parse --show-toplevel)
SECRETS_DIR := $(ROOT_DIR)/.docker/mysql/secrets
DEFAULT_DB_NAME := mysql_docker_template
DEFAULT_USER_NAME := mysql_docker_template_user

# Disable built-in rules
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

# Default target
.PHONY: start
start: init
	docker-compose up -d

.PHONY: stop
stop:
	docker-compose down

.PHONY: rebuild
rebuild: init
	docker-compose down
	docker-compose up --build -d

.PHONY: clean-app
clean-app:
	docker compose down --rmi all --remove-orphans --volumes

# Define helper functions
# Generate a random string
generate_random_string = head /dev/urandom | tr -dc A-Za-z0-9 | head -c $(1)

# Prompt for a value and create a file if it does not exist
define prompt_for_value
@if [ ! -f $(1) ]; then \
	read -p $(2) input; \
	input=$${input:-$(3)}; \
	echo "$$input" > $(1); \
	echo "Creating $(1) with value: $$input"; \
else \
	echo "$1 already exists."; \
fi
endef

# Database configuration
$(SECRETS_DIR)/database.txt:
	$(call prompt_for_value,$@,"Enter the database name (Press enter for default: $(DEFAULT_DB_NAME)):",$(DEFAULT_DB_NAME))

$(SECRETS_DIR)/user.txt:
	$(call prompt_for_value,$@,"Enter the user name (Press enter for default: $(DEFAULT_USER_NAME)):",$(DEFAULT_USER_NAME))

$(SECRETS_DIR)/root_password.txt:
	$(call prompt_for_value,$@,"Enter the root password (Press enter for a random value):",$$( $(call generate_random_string,13) ))

$(SECRETS_DIR)/password.txt:
	$(call prompt_for_value,$@,"Enter the user password (Press enter for a random value):",$$( $(call generate_random_string,13) ))

.PHONY: init-database
init-database: $(SECRETS_DIR)/database.txt $(SECRETS_DIR)/user.txt $(SECRETS_DIR)/root_password.txt $(SECRETS_DIR)/password.txt
	@echo "Initialization of database settings complete."

.PHONY: clean-database
clean-database:
	rm -f $(SECRETS_DIR)/database.txt
	rm -f $(SECRETS_DIR)/user.txt
	rm -f $(SECRETS_DIR)/root_password.txt
	rm -f $(SECRETS_DIR)/password.txt

# Project setup
.env:
	@if [ ! -f $(ROOT_DIR)/.env ]; then \
		echo "Creating root .env from template"; \
		cp $(ROOT_DIR)/.env.template $(ROOT_DIR)/.env; \
	else \
		echo "$(ROOT_DIR)/.env already exists."; \
	fi

.PHONY: init-project
init-project: .env
	@echo "Initialization of project complete."

.PHONY: clean-project
clean-project:
	rm -f $(ROOT_DIR)/.env

.PHONY: init
init: init-database init-project
	@echo "Initialization complete."

.PHONY: clean
clean: clean-app clean-database clean-project
	@echo "Clean complete."