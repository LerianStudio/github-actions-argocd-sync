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
if ! argocd app get "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN" --grpc-web > /dev/null 2>&1; then
    echo -e "\033[0;31mERROR: Failed to get app $APP_TO_SYNC\033[0m"
    exit 1
fi
echo -e "\033[0;32mGetting app status... ✓\033[0m"

sleep 5

echo -e "\033[0;36m======> SYNC $APP_TO_SYNC \033[0m\n"
echo -e "\033[0;33mExecuting: argocd app sync \"$APP_TO_SYNC\" --server \"$ARGO_CD_URL\" --auth-token \"***\" --grpc-web\033[0m"

# Retry sync up to 5 times
RETRY_COUNT=0
MAX_RETRIES=5
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if argocd app sync "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN" --grpc-web > /dev/null 2>&1; then
        echo -e "\033[0;32mSyncing application... ✓\033[0m"
        break
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo -e "\033[0;33mSync attempt $RETRY_COUNT failed, retrying in 5 seconds...\033[0m"
            sleep 5
        else
            echo -e "\033[0;31mERROR: Failed to sync app $APP_TO_SYNC after $MAX_RETRIES attempts\033[0m"
            exit 1
        fi
    fi
done

echo -e "\033[0;36m======> WAIT SYNC $APP_TO_SYNC \033[0m\n"
echo -e "\033[0;33mExecuting: argocd app wait \"$APP_TO_SYNC\" --server \"$ARGO_CD_URL\" --auth-token \"***\" --grpc-web\033[0m"
if ! argocd app wait "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN" --grpc-web > /dev/null 2>&1; then
    echo -e "\033[0;31mERROR: Failed to wait for sync completion of app $APP_TO_SYNC\033[0m"
    exit 1
fi
echo -e "\033[0;32mWaiting for sync completion... ✓\033[0m"

echo -e "\033[0;36m======> DONE \033[0m\n"