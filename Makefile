SHELL := /bin/bash

.PHONY: bootstrap
bootstrap: ## Install dependencies
	bundle install

.PHONY: run
run: development generate-tech-docs-yml ## Runs the app in development
	bundle exec middleman server

.PHONY: generate-tech-docs-yml
generate-tech-docs-yml:
	@erb config/tech-docs.yml.erb > config/tech-docs.yml

.PHONY: bootstrap-with-docker
bootstrap-with-docker: ## Prepare the Docker builder image
	docker build -f docker/Dockerfile --target ruby_build -t notifications-tech-docs .

.PHONY: run-with-docker
run-with-docker:
	export DOCKER_ARGS="-p 4567:4567 -p 35729:35729" && \
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
