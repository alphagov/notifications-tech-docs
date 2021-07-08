#!/bin/bash
DOCKER_IMAGE_NAME=notifications-tech-docs

docker run \
  --rm \
  -v "`pwd`:/var/project" \
  -it \
  ${DOCKER_ARGS} \
  ${DOCKER_IMAGE_NAME} \
  ${@}
