.DEFAULT_GOAL := help
BASE_IMG ?= nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04
COMPOSE_FILE ?= pytorch/compose_testGPUAccess.yml
DOCKERHUB_REPO ?= rr5555/gpu_access_test:test_both
DOCKER_FILE ?= Dockerfile

docker-build: ## Build the test img with pytorch & pynvml
	docker build --tag $(DOCKERHUB_REPO) --build-arg BASE_IMG=$(BASE_IMG) -f $(DOCKER_FILE) .

docker-build-no-cache: ## Build the test img with pytorch & pynvml with no cache
	docker build --no-cache --tag $(DOCKERHUB_REPO) --build-arg BASE_IMG=$(BASE_IMG) -f $(DOCKER_FILE) .

docker-build-nvidia-smi: ## Build the test img for nvidia-smi (raw cuda container)
	DOCKER_FILE=nvidia-smi/Dockerfile DOCKERHUB_REPO=rr5555/gpu_access_test:test_nvidia_smi $(MAKE) docker-build

docker-build-pytorch: ## Build the test img with pytorch
	DOCKER_FILE=pytorch/Dockerfile DOCKERHUB_REPO=rr5555/gpu_access_test:test_pytorch $(MAKE) docker-build

docker-build-pynvml: ## Build the test img with pynvml
	DOCKER_FILE=pynvml/Dockerfile DOCKERHUB_REPO=rr5555/gpu_access_test:test_pynvml $(MAKE) docker-build

dockerhub-push: ## Push the test img with pytorch & pynvml to DockerHub
	docker push $(DOCKERHUB_REPO)

dockerhub-push-nvidia-smi: ## Push the test img for nvidia-smi to DockerHub
	docker push rr5555/gpu_access_test:test_nvidia_smi

dockerhub-push-pytorch: ## Push the test img with pytorch to DockerHub
	docker push rr5555/gpu_access_test:test_pytorch

dockerhub-push-pynvml: ## Push the test img with pynvml to DockerHub
	docker push rr5555/gpu_access_test:test_pynvml

launch-test: ## Launch the test by launching the right docker compose
	docker compose -f $(COMPOSE_FILE) up

stop-test: ## Stop the launched docker compose
	docker compose -p gpu_access_test down

docker-clean: ## Remove the test img
	docker rmi $(DOCKERHUB_REPO)

docker-clean-nvidia-smi: ## Remove the test img
	docker rmi rr5555/gpu_access_test:test_nvidia_smi

docker-clean-pytorch: ## Remove the test img
	docker rmi rr5555/gpu_access_test:test_pytorch

docker-clean-pynvml: ## Remove the test img
	docker rmi rr5555/gpu_access_test:test_pynvml

trunc-test: ## Launch test from already pushed test img (no cleaning included)
	$(MAKE) launch-test
	$(MAKE) stop-test


all-nvidia-smi-tests: ## Run all pytorch tests
	@echo
	@echo 'Testing nvidia-smi processes:'
	COMPOSE_FILE=nvidia-smi/compose_testGPUAccess_dummy_load.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing wo restrictions:'
	COMPOSE_FILE=nvidia-smi/compose_testGPUAccess.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `device_ids`:'
	COMPOSE_FILE=nvidia-smi/compose_testGPUAccess_device_ids.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `GPU_ID`:'
	COMPOSE_FILE=nvidia-smi/compose_testGPUAccess_GPU_ID.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `CUDA_VISIBLE_DEVICES`:'
	COMPOSE_FILE=nvidia-smi/compose_testGPUAccess_CUDA_VISIBLE_DEVICES.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `NVIDIA_VISIBLE_DEVICES`:'
	COMPOSE_FILE=nvidia-smi/compose_testGPUAccess_NVIDIA_VISIBLE_DEVICES.yml $(MAKE) trunc-test

all-pytorch-tests: ## Run all pytorch tests
	@echo
	@echo 'Testing wo restrictions:'
	COMPOSE_FILE=pytorch/compose_testGPUAccess.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `device_ids`:'
	COMPOSE_FILE=pytorch/compose_testGPUAccess_device_ids.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `GPU_ID`:'
	COMPOSE_FILE=pytorch/compose_testGPUAccess_GPU_ID.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `CUDA_VISIBLE_DEVICES`:'
	COMPOSE_FILE=pytorch/compose_testGPUAccess_CUDA_VISIBLE_DEVICES.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `NVIDIA_VISIBLE_DEVICES`:'
	COMPOSE_FILE=pytorch/compose_testGPUAccess_NVIDIA_VISIBLE_DEVICES.yml $(MAKE) trunc-test

all-pynvml-tests: ## Run all pytorch tests
	@echo
	@echo 'Testing wo restrictions:'
	COMPOSE_FILE=pynvml/compose_testGPUAccess.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `device_ids`:'
	COMPOSE_FILE=pynvml/compose_testGPUAccess_device_ids.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `GPU_ID`:'
	COMPOSE_FILE=pynvml/compose_testGPUAccess_GPU_ID.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `CUDA_VISIBLE_DEVICES`:'
	COMPOSE_FILE=pynvml/compose_testGPUAccess_CUDA_VISIBLE_DEVICES.yml $(MAKE) trunc-test
	@echo
	@echo 'Testing with `NVIDIA_VISIBLE_DEVICES`:'
	COMPOSE_FILE=pynvml/compose_testGPUAccess_NVIDIA_VISIBLE_DEVICES.yml $(MAKE) trunc-test




# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
