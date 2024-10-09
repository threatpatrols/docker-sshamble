# SSHamble: Unexpected Exposures in SSH in Docker

Dockerization of the awesome [SSHamble](https://SSHamble.com) by [HD Moore](https://github.com/hdm)

Source: https://github.com/runZeroInc/sshamble

## Usage

```commandline
docker run --rm -it threatpatrols/sshamble:latest scan -o - 10.0.0.0/24
```

## Extended Usage Example
Thanks to [jcormier](https://github.com/jcormier) for this extended usage [example](https://github.com/threatpatrols/docker-sshamble/issues/1) 
suggestion using a `sshamble.sh` wrapper script. 

**sshamble.sh**
```shell
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
```

```commandline
./sshamble.sh scan -o scan-results.json 10.0.0.0/24
./sshamble.sh analyze -o results-directory scan-results.json
```

## Notes
The docker build image includes a `badkeys-update` step that pulls the latest [badkeys](https://badkeys.info/) 
data into the image - this data is fairly slow moving and should not become too stale quickly. 
