ARG VERSION

FROM restic/restic:$VERSION

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="restic" \
    org.label-schema.description="These are docker images for restic." \
    org.label-schema.url="https://hub.docker.com/r/pfillion/restic" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/pfillion/restic" \
    org.label-schema.vendor="pfillion" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

RUN apk add --update --no-cache \
    bash

COPY rootfs /

ENTRYPOINT ["entrypoint.sh"]

CMD ["restic"]