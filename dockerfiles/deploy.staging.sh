#!/bin/bash

PROJECT_NAME=$1
CONTAINER_NAME=$2
TAG=$3
IMAGE=storjlabs/${PROJECT_NAME}:${TAG}

kubectl config set-cluster storj-nonprod
kubectl --namespace storj-staging patch deployment ${PROJECT_NAME} -p"{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"${CONTAINER_NAME}\",\"image\":\"${IMAGE}\"}]}}}}"
