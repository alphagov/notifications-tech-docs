CF_ORG ?= govuk-notify
CF_APP = notify-tech-docs

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
