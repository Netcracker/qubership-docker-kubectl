FROM alpine:3.22

ENV HOME="/"

RUN set -x \
    && apk add --update --no-cache \
        curl \
        jq \
        bash \
        wget \
        apk-tools \
    && rm -rf /var/cache/apk/*

#Download necessary tools
RUN set -x \
    && wget \
        --no-check-certificate \
        -nv \
        -O /usr/bin/kubectl \
        "https://dl.k8s.io/v1.34.1/bin/darwin/amd64/kubectl" \
    && chmod +x /usr/bin/kubectl

# Upgrade all tools to avoid vulnerabilities
RUN set -x && apk upgrade --no-cache --available

USER 1001
ENTRYPOINT [ "kubectl" ]
