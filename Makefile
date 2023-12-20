SHELL := /bin/bash

CF_ORG ?= govuk-notify
CF_APP = notify-tech-docs
CF_MANIFEST_PATH ?= manifest.yml

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
	docker build -t notifications-tech-docs .

.PHONY: run-with-docker
run-with-docker:
	export DOCKER_ARGS="-p 4567:4567 -p 35729:35729" && \
		./scripts/run_with_docker.sh make run

.PHONY: generate-manifest
generate-manifest:
	$(if ${ROUTE},,$(error Must specify ROUTE))
	@sed -e "s/{{ROUTE}}/${ROUTE}/" manifest.yml.tpl > ${CF_MANIFEST_PATH}

.PHONY: development
development: ## Set environment to development
	$(eval export ROUTE='localhost:4567')
	$(eval export HOST='http://localhost:4567')
	@true

.PHONY: preview
preview: ## Set environment to preview
	$(eval export CF_SPACE=preview)
	$(eval export ROUTE='docs.notify.works')
	$(eval export HOST='https://docs.notify.works')
	@true

.PHONY: production
production: ## Set environment to production
	$(eval export CF_SPACE=production)
	$(eval export ROUTE='docs.notifications.service.gov.uk')
	$(eval export HOST='https://docs.notifications.service.gov.uk')
	@true

.PHONY: cf-deploy
cf-deploy: generate-manifest ## Deploys the app to Cloud Foundry
	$(if ${CF_ORG},,$(error Must specify CF_ORG))
	$(if ${CF_SPACE},,$(error Must specify CF_SPACE))
	cp -r build-${CF_SPACE} build
	cf target -o ${CF_ORG} -s ${CF_SPACE}
	@cf app --guid ${CF_APP} || exit 1

	# cancel any existing deploys to ensure we can apply manifest (if a deploy is in progress you'll see ScaleDisabledDuringDeployment)
	cf cancel-deployment ${CF_APP} || true

	cf push ${CF_APP} -p ./build --strategy=rolling -f ${CF_MANIFEST_PATH}

	rm -rf ./build/
