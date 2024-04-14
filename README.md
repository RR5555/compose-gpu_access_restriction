# Test: Docker Compose -- GPU access restrictions

([Execute python program from command line without script file](https://stackoverflow.com/a/50986459/8612123))


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
