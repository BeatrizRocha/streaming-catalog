# Streaming Catalog Makefile
# Helper commands for Docker-based Rails development

.PHONY: build up down restart ps logs shell console routes test rspec rspec-file rubocop \
        db-create db-migrate db-rollback db-seed db-reset db-status \
        generate bundle clean help ensure-running setup

# Docker compose command prefix
# Try to detect which docker compose command is available
ifeq ($(shell which docker-compose 2>/dev/null),)
  DC = docker compose
else
  DC = docker-compose
endif

# Default target
.DEFAULT_GOAL := help

# Colors for terminal output
GREEN = \033[0;32m
YELLOW = \033[0;33m
NC = \033[0m # No Color

help: ## Show this help
	@echo "Streaming Catalog Makefile Commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

# Docker commands
build: ## Build or rebuild the Docker containers
	$(DC) build

up: ## Start the application
	$(DC) up

up-d: ## Start the application in detached mode
	$(DC) up -d

down: ## Stop and remove containers
	$(DC) down

restart: ## Restart the application
	$(DC) restart

ps: ## Show running containers
	$(DC) ps

logs: ## View output from containers
	$(DC) logs -f

logs-web: ## View output from web container only
	$(DC) logs -f web

# Helper to check if containers are running
ensure-running:
	@if [ -z "$$($(DC) ps -q web 2>/dev/null)" ]; then \
		echo "$(YELLOW)Starting containers in detached mode...$(NC)"; \
		$(DC) up -d; \
		echo "$(GREEN)Waiting for containers to be ready...$(NC)"; \
		sleep 5; \
	fi

# Setup command to install dependencies
setup: ensure-running ## Install dependencies and prepare the application
	@echo "$(YELLOW)Installing bundle dependencies...$(NC)"
	$(DC) exec web bundle install
	@echo "$(GREEN)Setup completed!$(NC)"

# Rails commands
shell: ensure-running ## Open a bash shell in the web container
	$(DC) exec web bash

console: setup ## Open Rails console
	$(DC) exec web bundle exec rails console

routes: setup ## Show Rails routes
	$(DC) exec web bundle exec rails routes

test: setup ## Run all tests
	$(DC) exec web bundle exec rails test

rspec: setup ## Run RSpec tests
	$(DC) exec web bundle exec rspec

rspec-file: setup ## Run a specific RSpec file (usage: make rspec-file ARGS="spec/path/to/file_spec.rb")
	$(DC) exec web bundle exec rspec $(ARGS)

rubocop: setup ## Run Rubocop
	$(DC) exec web bundle exec rubocop

# Database commands
db-create: setup ## Create the database
	$(DC) exec web bundle exec rails db:create

db-migrate: setup ## Run database migrations
	$(DC) exec web bundle exec rails db:migrate

db-rollback: setup ## Rollback the last database migration
	$(DC) exec web bundle exec rails db:rollback

db-seed: setup ## Seed the database
	$(DC) exec web bundle exec rails db:seed

db-reset: setup ## Reset the database (drop, create, migrate, seed)
	$(DC) exec web bundle exec rails db:reset

db-status: setup ## Show migration status
	$(DC) exec web bundle exec rails db:migrate:status

# Rails generators
generate: setup ## Run Rails generate command (usage: make generate ARGS="model User name:string")
	$(DC) exec web bundle exec rails generate $(ARGS)

g: generate ## Alias for generate

# Bundle commands
bundle: ensure-running ## Run bundle install
	$(DC) exec web bundle install

bundle-update: setup ## Run bundle update
	$(DC) exec web bundle update $(ARGS)

# Cleaning commands
clean: ensure-running ## Remove temporary files
	$(DC) exec web rm -rf tmp/cache tmp/pids

clean-logs: ensure-running ## Clean log files
	$(DC) exec web rm -f log/*.log
