.PHONY: help

DOCKER_IMAGE_NAME ?= byte-unixbench
DOCKER_REPOSITORY_NAME ?= harbor.mlpipeline.io
DOCKER_PROJECT_NAME ?= dev
DOCKER_IMAGE_VERSION ?= $(shell git describe)
DOCKER_REPOSITORY := $(DOCKER_REPOSITORY_NAME)/$(DOCKER_PROJECT_NAME)/$(DOCKER_IMAGE_NAME)
COMMIT_MSG ?= [$(DOCKER_PROJECT_NAME)] Update $(DOCKER_IMAGE_NAME) with tag $(DOCKER_IMAGE_VERSION)
GIT_EMAIL ?= hrlee@devstack.co.kr
GIT_USERNAME ?= username
GIT_BRANCH ?= main

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build-image: ## Build image
	docker build --network=host -t $(DOCKER_REPOSITORY_NAME):latest .
	docker tag $(DOCKER_REPOSITORY):latest $(DOCKER_REPOSITORY):$(DOCKER_IMAGE_VERSION)

push-image: build-image ## Push image
	docker push $(DOCKER_REPOSITORY):$(DOCKER_IMAGE_VERSION)
	docker rmi $(DOCKER_REPOSITORY):$(DOCKER_IMAGE_VERSION)
