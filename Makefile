.DEFAULT_GOAL := help
SHELL := /bin/bash

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: bootstrap
bootstrap: ## Install dependencies
	bundle install

.PHONY: run
run: development generate-tech-docs-yml ## Runs the app in development
	bundle exec middleman server

.PHONY: generate-tech-docs-yml
generate-tech-docs-yml: ## Generate the tech-docs.yml file
	@erb config/tech-docs.yml.erb > config/tech-docs.yml

.PHONY: bootstrap-with-docker
bootstrap-with-docker: ## Prepare the Docker builder image
	docker build -f docker/Dockerfile --target ruby_build -t notifications-tech-docs .

.PHONY: run-with-docker
run-with-docker: ## Runs the app with Docker
	export DOCKER_ARGS="-p 127.0.0.1:4567:4567 -p 127.0.0.1:35729:35729" && \
		./scripts/run_with_docker.sh make run

.PHONY: development
development: ## Set environment to development
	$(eval export HOST='http://localhost:4567')
	@true

.PHONY: preview
preview: ## Set environment to preview
	$(eval export HOST='https://docs.notify.works')
	@true

.PHONY: production
production: ## Set environment to production
	$(eval export HOST='https://docs.notifications.service.gov.uk')
	@true
