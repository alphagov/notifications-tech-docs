CF_ORG ?= govuk-notify
CF_APP = notify-tech-docs

DOCKER_BUILDER_IMAGE_NAME = govuk/notify-tech-docs
BUILD_TAG ?= notifications-tech-docs
DOCKER_CONTAINER_PREFIX = ${USER}-${BUILD_TAG}

.PHONY: test
test:
	./script/run_tests.sh

.PHONY: generate-manifest
generate-manifest:
	@erb manifest.yml.erb > manifest.yml

.PHONY: generate-tech-docs-yml
generate-tech-docs-yml:
	@erb config/tech-docs.yml.erb > config/tech-docs.yml

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

.PHONY: run-in-development
run-in-development: development generate-tech-docs-yml ## Runs the app in development
	bundle exec middleman server

.PHONY: generate-build-files
generate-build-files: generate-tech-docs-yml ## Generates the build files
	bundle exec middleman build

.PHONY: cf-deploy
cf-deploy: generate-manifest generate-build-files ## Deploys the app to Cloud Foundry
	$(if ${CF_ORG},,$(error Must specify CF_ORG))
	$(if ${CF_SPACE},,$(error Must specify CF_SPACE))
	cf target -o ${CF_ORG} -s ${CF_SPACE}
	@cf app --guid ${CF_APP} || exit 1
	cf rename ${CF_APP} ${CF_APP}-rollback
	cf push -f manifest.yml ${CF_APP}
	cf scale -i $$(cf curl /v2/apps/$$(cf app --guid ${CF_APP}-rollback) | jq -r ".entity.instances" 2>/dev/null || echo "1") ${CF_APP}
	cf stop ${CF_APP}-rollback
	# get the new GUID, and find all crash events for that. If there were any crashes we will abort the deploy.
	[ $$(cf curl "/v2/events?q=type:app.crash&q=actee:$$(cf app --guid ${CF_APP})" | jq ".total_results") -eq 0 ]
	cf delete -f ${CF_APP}-rollback

.PHONY: test-with-docker
test-with-docker: prepare-docker-runner-image ## Build inside a Docker container
	docker run -i --rm \
		--name "${DOCKER_CONTAINER_PREFIX}-build" \
		-v "`pwd`:/var/project" \
		-e http_proxy="${HTTP_PROXY}" \
		-e HTTP_PROXY="${HTTP_PROXY}" \
		-e https_proxy="${HTTPS_PROXY}" \
		-e HTTPS_PROXY="${HTTPS_PROXY}" \
		-e NO_PROXY="${NO_PROXY}" \
		${DOCKER_BUILDER_IMAGE_NAME} \
		make test

.PHONY: build-with-docker
build-with-docker: prepare-docker-runner-image ## Build inside a Docker container
	$(if ${CF_SPACE},,$(error Must specify CF_SPACE))
	docker run -i --rm \
		--name "${DOCKER_CONTAINER_PREFIX}-build" \
		-v "`pwd`:/var/project" \
		-e http_proxy="${HTTP_PROXY}" \
		-e HTTP_PROXY="${HTTP_PROXY}" \
		-e https_proxy="${HTTPS_PROXY}" \
		-e HTTPS_PROXY="${HTTPS_PROXY}" \
		-e NO_PROXY="${NO_PROXY}" \
		${DOCKER_BUILDER_IMAGE_NAME} \
		make ${CF_SPACE} generate-build-files

.PHONY: prepare-docker-runner-image
prepare-docker-runner-image: ## Prepare the Docker builder image
	docker pull `grep "FROM " Dockerfile | cut -d ' ' -f 2` || true
	docker build \
		--build-arg http_proxy="${HTTP_PROXY}" \
		--build-arg HTTP_PROXY="${HTTP_PROXY}" \
		--build-arg https_proxy="${HTTPS_PROXY}" \
		--build-arg HTTPS_PROXY="${HTTPS_PROXY}" \
		--build-arg NO_PROXY="${NO_PROXY}" \
		-t govuk/notify-tech-docs \
		.
