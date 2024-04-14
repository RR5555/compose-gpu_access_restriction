# Test: Docker Compose -- GPU access restrictions

([Execute python program from command line without script file](https://stackoverflow.com/a/50986459/8612123))






docker-build-no-cache if docker-build fails at apt install cannot find the repo.s:\
[error building docker image 'executor failed running [/bin/sh -c apt-get -y update]'](https://stackoverflow.com/a/68849691/8612123):\
''
In my case, docker was still using the cached RUN apt update && apt upgrade command, thus not updating the package sources.

The solution was to build the docker image once with the --no-cache flag:
```bash
docker build --no-cache .
```
''

```bash
# Build and push:
make docker-build-push
# Test:
make trunc-test
# Clean:
make docker-clean
```


```bash
# Build and push (if not already done):
make docker-build-push
# Test:
make all-tests
```

Test out the GPU access restrictions:
```bash
docker build --tag rr5555/gpu_access_test --build-arg BASE_IMG=nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04 .
docker compose -f compose_testGPUAccess.yml up
docker compose -p gpu_access_test down
```




```bash
pip3 install torch
printf 'import torch\nprint(f"torch.cuda.is_available():{torch.cuda.is_available()}")\nprint(f"torch.cuda.device_count():{torch.cuda.device_count()}")' | python3
```
To run the following:
```python
import torch
print(f"torch.cuda.is_available():{torch.cuda.is_available()}")
print(f"torch.cuda.device_count():{torch.cuda.device_count()}")
```
