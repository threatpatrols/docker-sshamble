# runZeroInc/sshamble

# https://hub.docker.com/_/golang/tags
FROM golang:1.24-bullseye AS build

# https://github.com/runZeroInc/sshamble/tags
ARG COMMIT_TAG="main+ac2db94"
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
FROM debian:stable-slim AS badkeys

COPY --from=build /build/sshamble /usr/local/bin/sshamble

RUN set -x \
    && apt-get update \
    && apt-get install -y ca-certificates \
    && /usr/local/bin/sshamble badkeys-update \
    && mv /root/.cache/badkeys /badkeys


# https://hub.docker.com/_/debian/tags
FROM debian:stable-slim

# OCI Labels
LABEL org.opencontainers.image.title="Docker SSHamble"
LABEL org.opencontainers.image.authors="Nicholas de Jong <ndejong@threatpatrols.com>"
LABEL org.opencontainers.image.source="https://github.com/threatpatrols/docker-sshamble"

COPY --from=build /build/sshamble /usr/local/bin/sshamble
COPY --from=badkeys /badkeys /badkeys

RUN set -x \
    && mkdir -p /.cache \
    && ln -s /badkeys /.cache/badkeys \
    \
    && mkdir -p /root/.cache \
    && ln -s /badkeys /root/.cache/badkeys


ENTRYPOINT ["/usr/local/bin/sshamble"]
