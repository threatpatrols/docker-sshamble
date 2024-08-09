# runZeroInc/sshamble

# https://hub.docker.com/_/golang/tags
FROM golang:1.22-bullseye AS build

# https://github.com/runZeroInc/sshamble/tags
ARG COMMIT_TAG="main+5ae73e8"
ARG SOURCE_REPO="https://github.com/runZeroInc/sshamble.git"

WORKDIR "/build"

RUN set -x \
    && export SOURCE_COMMIT_ID="$(echo ${COMMIT_TAG} | cut -d'+' -f2)" \
    && export SOURCE_TAG_BRANCH="$(echo ${COMMIT_TAG} | cut -d'+' -f1)" \
    && git clone --config advice.detachedHead=false --depth 1 --branch "${SOURCE_TAG_BRANCH}" "${SOURCE_REPO}" "/build" \
    && git reset --hard "${SOURCE_COMMIT_ID}" \
    && git log

RUN set -x \
    && go build \
    && ./sshamble -h

# ===

# https://hub.docker.com/_/debian/tags
FROM debian:stable-slim

COPY --from=build /build/sshamble /usr/local/bin/sshamble

ENTRYPOINT ["/usr/local/bin/sshamble"]
