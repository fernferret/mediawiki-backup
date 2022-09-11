FROM alpine/k8s:1.23.7 as kubectl

FROM alpine:3.16
RUN apk add mariadb-client bash
COPY --from=kubectl /usr/bin/kubectl /usr/bin/kubectl
