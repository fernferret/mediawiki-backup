FROM alpine/k8s:1.25.6 as kubectl

FROM alpine:3.16
RUN apk add mariadb-client bash
COPY --from=kubectl /usr/bin/kubectl /usr/bin/kubectl
LABEL org.opencontainers.image.source="https://github.com/fernferret/mediawiki-backup"
