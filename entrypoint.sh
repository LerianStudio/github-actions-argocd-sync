#!/bin/sh -l

# ENV_PREFIX
APP_NAME=$1
ARGO_CD_TOKEN=$2
ARGO_CD_URL=$3
ENV_PREFIX=$4
APP_TO_SYNC="$APP_NAME-$ENV_PREFIX"

echo -e "\033[0;36m ======> APP $APP_TO_SYNC \033[0m\n"
argocd app get "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN"

sleep 5

echo -e "\033[0;36m======> SYNC $APP_TO_SYNC \033[0m\n"
argocd app sync "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN"

echo -e "\033[0;36m======> WAIT SYNC $APP_TO_SYNC \033[0m\n"
argocd app wait "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN"

echo -e "\033[0;36m======> DONE \033[0m\n"