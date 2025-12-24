ARG VERSION=latest

FROM restic/restic:$VERSION

# Build-time metadata as defined at https://github.com/opencontainers/image-spec
ARG DATE
ARG VERSION
ARG COMMIT
ARG AUTHOR

LABEL \
    org.opencontainers.image.created=$DATE \
    org.opencontainers.image.url="https://hub.docker.com/r/pfillion/restic" \
    org.opencontainers.image.source="https://github.com/pfillion/restic" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$COMMIT \
    org.opencontainers.image.vendor="pfillion" \
    org.opencontainers.image.title="restic" \
    org.opencontainers.image.description="These are docker images for restic." \
    org.opencontainers.image.authors=$AUTHOR \
    org.opencontainers.image.licenses="MIT"

RUN apk add --update --no-cache \
    bash

COPY --chmod=0755 rootfs /

ENTRYPOINT ["entrypoint.sh"]