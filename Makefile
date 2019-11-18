SHELL := /bin/bash

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
	$(if ${ROUTE},,$(error Must specify ROUTE))
	@sed -e "s/{{ROUTE}}/${ROUTE}/" manifest.yml.tpl > manifest.yml

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
cf-deploy: generate-manifest ## Deploys the app to Cloud Foundry
	$(if ${CF_ORG},,$(error Must specify CF_ORG))
	$(if ${CF_SPACE},,$(error Must specify CF_SPACE))
	cp -r build-${CF_SPACE} build
	cf target -o ${CF_ORG} -s ${CF_SPACE}
	@cf app --guid ${CF_APP} || exit 1

	# cancel any existing deploys to ensure we can apply manifest (if a deploy is in progress you'll see ScaleDisabledDuringDeployment)
	cf v3-cancel-zdt-push ${CF_APP} || true

	cf v3-apply-manifest ${CF_APP} -f manifest.yml
	cf v3-zdt-push ${CF_APP} -p ./build --wait-for-deploy-complete  # fails after 5 mins if deploy doesn't work

	rm -rf ./build/



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
	if [ -d build-${CF_SPACE} ]; then rm -rf build-${CF_SPACE}; fi
	echo "$(shell id -u `whoami`):$(shell id -g `whoami`)" > user_group_ids
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
	mv build build-${CF_SPACE}

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

.PHONY: build-paas-artifact
build-paas-artifact: ## Build the deploy artifact for PaaS
	rm -rf target
	mkdir -p target
	zip -y -q -r -x@deploy-exclude.lst target/notifications-tech-docs.zip ./

.PHONY: upload-paas-artifact
upload-paas-artifact: ## Upload the deploy artifact for PaaS
	$(if ${DEPLOY_BUILD_NUMBER},,$(error Must specify DEPLOY_BUILD_NUMBER))
	$(if ${JENKINS_S3_BUCKET},,$(error Must specify JENKINS_S3_BUCKET))
	aws s3 cp --region eu-west-1 --sse AES256 target/notifications-tech-docs.zip s3://${JENKINS_S3_BUCKET}/build/notifications-tech-docs/${DEPLOY_BUILD_NUMBER}.zip
