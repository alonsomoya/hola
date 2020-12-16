#!/bin/bash

docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --no-cache -t josealo/hola:latest --push . && \
kubectl rollout restart deployment.apps/hola
