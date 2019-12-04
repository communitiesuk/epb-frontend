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
	@scripts/generate-paas-manifest.sh ${DEPLOY_APPNAME} > manifest.yml

.PHONY: frontend-build
frontend-build: ## Run the frontend build process to compile sass and move asset files to public
	@echo "Building frontend assets..."
	ruby ./compile_assets.rb

.PHONY: deploy-app
deploy-app: ## Deploys the app to PaaS
	$(call check_space)
	$(if ${DEPLOY_APPNAME},,$(error Must specify DEPLOY_APPNAME))

	@$(MAKE) frontend-build
	@$(MAKE) generate-manifest

	cf v3-apply-manifest -f manifest.yml
	cf v3-zdt-push "${DEPLOY_APPNAME}" --wait-for-deploy-complete

.PHONY: test
test:
	rake spec

.PHONY: run
run:
	rackup

.PHONY: format
format:
	bundle exec rbprettier --write '**/*.rb'
