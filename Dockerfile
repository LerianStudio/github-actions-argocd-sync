# Container image that runs your code
FROM public.ecr.aws/docker/library/alpine:latest

# set argocd version
ENV ARGO_VERSION="v3.0.6"

# Installl dependencies
RUN apk add bash git curl gzip --update --no-cache bash

# install argocd cli
RUN curl -sLO https://github.com/argoproj/argo-cd/releases/download/${ARGO_VERSION}/argocd-linux-amd64
RUN chmod +x argocd-linux-amd64
RUN mv ./argocd-linux-amd64 /usr/local/bin/argocd

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]