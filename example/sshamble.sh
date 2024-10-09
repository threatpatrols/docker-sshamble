#!/bin/sh

DOCKER_IMAGE=threatpatrols/sshamble:latest
DOCKER_RUN_OWNERSHIP="-u $(id -u):$(id -g)"
DOCKER_RUN_WORKDIR="-v $PWD:$PWD -w $PWD"
test -t 1 && DOCKER_RUN_USE_TTY="-it"  # Check for interactive tty

docker pull "$DOCKER_IMAGE"  # Always run latest version
docker \
  run --rm \
  ${DOCKER_RUN_USE_TTY} \
  ${DOCKER_RUN_WORKDIR} \
  ${DOCKER_RUN_OWNERSHIP} \
  ${DOCKER_IMAGE} \
  ${@}
