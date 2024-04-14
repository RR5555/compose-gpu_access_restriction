# syntax = docker/dockerfile

# Last Pytorch supported version of cuda on 2024/02/25
ARG BASE_IMG=nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04
FROM $BASE_IMG

RUN apt-get update
# RUN apt-get dist-upgrade -y
RUN apt-get install -y curl python3-pip git
RUN python3 -m pip install -U pip
RUN pip3 install torch
RUN pip3 install pynvml

ENTRYPOINT ["/bin/bash"]

