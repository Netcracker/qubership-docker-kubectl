FROM alpine:3.22

ENV HOME="/"

RUN set -x \
    && apk add --update --no-cache \
        curl \
        jq \
        bash \
        busybox-static \
    && rm -rf /var/cache/apk/*

ARG TARGETARCH

#Download necessary tools
RUN set -x \
    && wget \
        --no-check-certificate \
        -nv \
        -O /usr/bin/kubectl \
        "https://dl.k8s.io/v1.34.1/bin/linux/${TARGETARCH}/kubectl" \
    && chmod +x /usr/bin/kubectl

# Use the static busybox as /bin/sh and provide `which`
# busybox-static usually installs /bin/busybox (static) on Alpine
RUN set -eux \
  && cp /bin/busybox.static /bin/busybox \
  && chmod 0755 /bin/busybox

# Upgrade all tools to avoid vulnerabilities
RUN set -x && apk upgrade --no-cache --available

USER 1001
ENTRYPOINT [ "kubectl" ]
