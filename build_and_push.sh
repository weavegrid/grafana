#!/bin/bash

set -ex

ECR_REPO=464910097692.dkr.ecr.us-west-2.amazonaws.com
DOCKER_APP=grafana
DOCKER_TAG=12.1.1-wg

# Build and push multiarch image
cd "$(dirname "${BASH_SOURCE[0]}")"

docker buildx build \
  --builder wg-builder \
  --platform linux/amd64,linux/arm64 \
  --provenance=false \
  --build-arg BINGO=false \
  --build-arg COMMIT_SHA=$(git rev-parse HEAD) \
  --build-arg BUILD_BRANCH=$(git rev-parse --abbrev-ref HEAD) \
  -t "${ECR_REPO}/${DOCKER_APP}:${DOCKER_TAG}" \
  --push \
  .

set +x
echo ""
echo "Successfully built and pushed multiarch Grafana image!"
echo "Image: ${ECR_REPO}/${DOCKER_APP}:${DOCKER_TAG}"
echo ""
echo "To inspect the manifest:"
echo "  docker buildx imagetools inspect ${ECR_REPO}/${DOCKER_APP}:${DOCKER_TAG}"
