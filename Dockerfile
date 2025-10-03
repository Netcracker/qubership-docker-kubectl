FROM alpine:3.22

ENV HOME="/"

RUN set -x \
    && apk add --update --no-cache \
        curl \
        jq \
        bash \
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

# Download BusyBox static binary (truly static, no musl/glibc deps)
RUN set -x \
    && curl -fsSL -o /bin/busybox \
       "https://busybox.net/downloads/binaries/1.36.1-defconfig-multiarch-musl/busybox-x86_64" \
    && chmod 0755 /bin/busybox \
    && ln -sf /bin/busybox /bin/sh \
    && ln -sf /bin/busybox /bin/which

# Upgrade all tools to avoid vulnerabilities
RUN set -x && apk upgrade --no-cache --available

USER 1001
ENTRYPOINT [ "kubectl" ]
