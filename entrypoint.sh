#!/bin/sh -l

# Exit on any error
set -e

# ENV_PREFIX
APP_NAME=$1
ARGO_CD_TOKEN=$2
ARGO_CD_URL=$3
ENV_PREFIX=$4
APP_TO_SYNC="$APP_NAME-$ENV_PREFIX"

echo -e "\033[0;36m ======> APP $APP_TO_SYNC \033[0m\n"
echo -e "\033[0;33mExecuting: argocd app get \"$APP_TO_SYNC\" --server \"$ARGO_CD_URL\" --auth-token \"***\" --grpc-web\033[0m"
if ! argocd app get "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN" --grpc-web; then
    echo -e "\033[0;31mERROR: Failed to get app $APP_TO_SYNC\033[0m"
    exit 1
fi

sleep 5

echo -e "\033[0;36m======> SYNC $APP_TO_SYNC \033[0m\n"
echo -e "\033[0;33mExecuting: argocd app sync \"$APP_TO_SYNC\" --server \"$ARGO_CD_URL\" --auth-token \"***\" --grpc-web\033[0m"
if ! argocd app sync "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN" --grpc-web; then
    echo -e "\033[0;31mERROR: Failed to sync app $APP_TO_SYNC\033[0m"
    exit 1
fi

echo -e "\033[0;36m======> WAIT SYNC $APP_TO_SYNC \033[0m\n"
echo -e "\033[0;33mExecuting: argocd app wait \"$APP_TO_SYNC\" --server \"$ARGO_CD_URL\" --auth-token \"***\" --grpc-web\033[0m"
if ! argocd app wait "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN" --grpc-web; then
    echo -e "\033[0;31mERROR: Failed to wait for sync completion of app $APP_TO_SYNC\033[0m"
    exit 1
fi

echo -e "\033[0;36m======> DONE \033[0m\n"