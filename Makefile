.DEFAULT_GOAL := help
BASE_IMG ?= nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04
COMPOSE_FILE ?= compose_testGPUAccess.yml
DOCKERHUB_REPO ?= rr5555/gpu_access_test:test

docker-build: ## Build the test img
	docker build --tag $(DOCKERHUB_REPO) --build-arg BASE_IMG=$(BASE_IMG) -f Dockerfile_testGPUAccess .

dockerhub-push: ## Push the test img to DockerHub
	docker push $(DOCKERHUB_REPO)

docker-build-push: ## Build the test img & Push the test img to DockerHub
	$(MAKE) docker-build
	$(MAKE) dockerhub-push

launch-test: ## Launch the test by launching the right docker compose
	docker compose -f $(COMPOSE_FILE) up

stop-test: ## Stop the launched docker compose
	docker compose -p gpu_access_test down

docker-clean: ## Remove the test img
	docker rmi $(DOCKERHUB_REPO)


trunc-test: ## Launch test from already pushed test img (no cleaning included)
	$(MAKE) launch-test
	$(MAKE) stop-test


all-tests: ## Run all tests
	@echo
	@echo 'Testing wo restrictions:'
	COMPOSE_FILE=compose_testGPUAccess.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `device_ids`:'
	COMPOSE_FILE=compose_testGPUAccess_device_ids.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `GPU_ID`:'
	COMPOSE_FILE=compose_testGPUAccess_GPU_ID.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `CUDA_VISIBLE_DEVICES`:'
	COMPOSE_FILE=compose_testGPUAccess_CUDA_VISIBLE_DEVICES.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `NVIDIA_VISIBLE_DEVICES`:'
	COMPOSE_FILE=compose_testGPUAccess_NVIDIA_VISIBLE_DEVICES.yml $(MAKE) trunc-test



# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
