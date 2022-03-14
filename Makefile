.DEFAULT_GOAL := help
SHELL := /bin/bash

PAAS_API ?= api.london.cloud.service.gov.uk
PAAS_ORG ?= mhclg-energy-performance
PAAS_SPACE ?= ${STAGE}

define check_space
	@echo "Checking PaaS space is active..."
	$(if ${PAAS_SPACE},,$(error Must specify PAAS_SPACE))
	@[ $$(cf target | grep -i 'space' | cut -d':' -f2) = "${PAAS_SPACE}" ] || (echo "${PAAS_SPACE} is not currently active cf space" && exit 1)
endef

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: generate-manifest
generate-manifest: ## Generate manifest file for PaaS
	$(if ${DEPLOY_APPNAME},,$(error Must specify DEPLOY_APPNAME))
	$(if ${PAAS_SPACE},,$(error Must specify PAAS_SPACE))
	@scripts/generate-paas-manifest.sh ${DEPLOY_APPNAME} ${PAAS_SPACE} > manifest.yml

.PHONY: generate-autoscaling-policy
generate-autoscaling-policy: ## Generate policy for Cloud Foundry App Auto-Scaler
	$(if ${PAAS_SPACE},,$(error Must specify PAAS_SPACE))
	@scripts/generate-autoscaling-policy.sh ${PAAS_SPACE} > autoscaling-policy.json

.PHONY: frontend-build
frontend-build: ## Run the frontend build process to compile sass and move asset files to public
	@echo "Building frontend assets..."
	STAGE=${DEPLOY_APPNAME} ruby ./compile_assets.rb

frontend-build-watch:
	@$(SHELL) ./scripts/frontend-build-watch.sh

.PHONY: deploy-app
deploy-app: ## Deploys the app to PaaS
	$(call check_space)
	$(if ${DEPLOY_APPNAME},,$(error Must specify DEPLOY_APPNAME))

	@$(MAKE) assets-version
	@$(MAKE) frontend-build
	@$(MAKE) generate-manifest
	@$(MAKE) generate-autoscaling-policy

	cf apply-manifest -f manifest.yml

	cf set-env "${DEPLOY_APPNAME}" EPB_AUTH_CLIENT_ID "${EPB_AUTH_CLIENT_ID}"
	cf set-env "${DEPLOY_APPNAME}" EPB_AUTH_CLIENT_SECRET "${EPB_AUTH_CLIENT_SECRET}"
	cf set-env "${DEPLOY_APPNAME}" EPB_AUTH_SERVER "${EPB_AUTH_SERVER}"
	cf set-env "${DEPLOY_APPNAME}" EPB_API_URL "${EPB_API_URL}"
	cf set-env "${DEPLOY_APPNAME}" EPB_UNLEASH_URI "${EPB_UNLEASH_URI}"
	cf set-env "${DEPLOY_APPNAME}" STAGE "${PAAS_SPACE}"
	cf set-env "${DEPLOY_APPNAME}" SENTRY_DSN "${SENTRY_DSN}"
	cf set-env "${DEPLOY_APPNAME}" GTM_PROPERTY_FINDING "${GTM_PROPERTY_FINDING}"
	cf set-env "${DEPLOY_APPNAME}" GTM_PROPERTY_GETTING "${GTM_PROPERTY_GETTING}"
	cf set-env "${DEPLOY_APPNAME}" EPB_RECAPTCHA_SITE_KEY "${EPB_RECAPTCHA_SITE_KEY}"
	cf set-env "${DEPLOY_APPNAME}" EPB_RECAPTCHA_SITE_SECRET "${EPB_RECAPTCHA_SITE_SECRET}"
	cf set-env "${DEPLOY_APPNAME}" EPB_SUSPECTED_BOT_USER_AGENTS "${subst ",\",${EPB_SUSPECTED_BOT_USER_AGENTS}}"
	cf set-env "${DEPLOY_APPNAME}" STATIC_START_PAGE_FINDING_EN "${STATIC_START_PAGE_FINDING_EN}"
	cf set-env "${DEPLOY_APPNAME}" STATIC_START_PAGE_GETTING_EN "${STATIC_START_PAGE_GETTING_EN}"
	cf set-env "${DEPLOY_APPNAME}" STATIC_START_PAGE_FINDING_CY "${STATIC_START_PAGE_FINDING_CY}"
	cf set-env "${DEPLOY_APPNAME}" STATIC_START_PAGE_GETTING_CY "${STATIC_START_PAGE_GETTING_CY}"
	cf set-env "${DEPLOY_APPNAME}" PERMANENTLY_BANNED_IP_ADDRESSES "${subst ",\",${PERMANENTLY_BANNED_IP_ADDRESSES}}"
	cf set-env "${DEPLOY_APPNAME}" WHITELISTED_IP_ADDRESSES "${subst ",\",${WHITELISTED_IP_ADDRESSES}}"

	cf push "${DEPLOY_APPNAME}" --strategy rolling

	cf attach-autoscaling-policy "${DEPLOY_APPNAME}" autoscaling-policy.json

.PHONY: test
test:
	@bundle exec rspec
	@npm run test

.PHONY: hosts
hosts:
	@scripts/configure-tests-hosts.sh

.PHONY: assets-version
assets-version:
	@scripts/write-assets-version.sh

.PHONY: run
run:
	@bundle exec rackup -p 9292 ${ARGS}

.PHONY: format
format:
	@bundle exec rubocop --auto-correct || true

.PHONY: journey
journey:
	@bundle exec rspec --tag journey
