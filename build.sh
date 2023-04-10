#!/bin/sh
VERS=$(yq e '.version' _config.yml)
REGISTRY=ghcr.io/rgstephens
IMAGE=mdi
K8S_DEPLOYMENT=mdi
K8S_NAMESPACE=websites

echo Building ${REGISTRY}/${IMAGE}:${VERS}
if [ -z "$CR_PAT" ]; then
  echo "must set CR_PAT"
  exit 1
fi
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
#time docker buildx build --platform linux/amd64 --output=type=registry --tag ${REGISTRY}/${IMAGE}:${VERS} --tag ${REGISTRY}/${IMAGE}:latest .
time docker buildx build --platform linux/amd64,linux/arm64 --output=type=registry --tag ${REGISTRY}/${IMAGE}:${VERS} --tag ${REGISTRY}/${IMAGE}:latest .
if [ $? -ne 0 ]; then
  echo "Build failed"
  exit 1
fi
#docker push ${REGISTRY}/${IMAGE} --all-tags
#kubectl config use-context default
#kubectl rollout restart deploy ${K8S_DEPLOYMENT} -n ${K8S_NAMESPACE}
#docker pull ${REGISTRY}/${IMAGE}:${VERS}
