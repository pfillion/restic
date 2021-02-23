SHELL = /bin/sh
.PHONY: help
.DEFAULT_GOAL := help

# Version
DATE = $(shell date -u +"%Y-%m-%dT%H:%M:%S")
COMMIT := $(shell git rev-parse HEAD)
AUTHOR := $(firstword $(subst @, ,$(shell git show --format="%aE" $(COMMIT))))

# Bats parameters
TEST_FOLDER ?= $(shell pwd)/tests

# Docker parameters
NS ?= pfillion
VERSION ?= 0.12.0
IMAGE_NAME ?= restic
CONTAINER_NAME ?= restic
CONTAINER_INSTANCE ?= default

help: ## Show the Makefile help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bats-test: ## Test bash scripts
	bats $(TEST_FOLDER)

docker-build: ## Build the image form Dockerfile
	docker build \
		--build-arg DATE=$(DATE) \
		--build-arg VERSION=$(VERSION) \
		--build-arg COMMIT=$(COMMIT) \
		--build-arg AUTHOR=$(AUTHOR) \
		-t $(NS)/$(IMAGE_NAME):$(VERSION) \
		-t $(NS)/$(IMAGE_NAME):latest \
		-f Dockerfile .

docker-push: ## Push the image to a registry
ifdef DOCKER_USERNAME
	@echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
endif
	docker push $(NS)/$(IMAGE_NAME):$(VERSION)
    
docker-shell: ## Run shell command in the container
	docker run -it --rm --entrypoint bash --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

docker-test: ## Run docker container tests
	container-structure-test test --image $(NS)/$(IMAGE_NAME):$(VERSION) --config $(TEST_FOLDER)/config.yaml

build: docker-build ## Build all

test: bats-test docker-test ## Run all tests

release: build test docker-push ## Build and push the image to a registry