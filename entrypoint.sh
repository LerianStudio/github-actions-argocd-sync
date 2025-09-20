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
# Function to show loading animation
show_loading() {
    local message="$1"
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r\033[0;33m%s %c\033[0m" "$message" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r\033[0;32m%s ✓\033[0m\n" "$message"
}

echo -e "\033[0;33mExecuting: argocd app get \"$APP_TO_SYNC\" --server \"$ARGO_CD_URL\" --auth-token \"***\" --grpc-web\033[0m"
argocd app get "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN" --grpc-web > /dev/null 2>&1 &
show_loading "Getting app status..."
wait $!
if [ $? -ne 0 ]; then
    echo -e "\033[0;31mERROR: Failed to get app $APP_TO_SYNC\033[0m"
    exit 1
fi

sleep 5

echo -e "\033[0;36m======> SYNC $APP_TO_SYNC \033[0m\n"
echo -e "\033[0;33mExecuting: argocd app sync \"$APP_TO_SYNC\" --server \"$ARGO_CD_URL\" --auth-token \"***\" --grpc-web\033[0m"
argocd app sync "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN" --grpc-web > /dev/null 2>&1 &
show_loading "Syncing application..."
wait $!
if [ $? -ne 0 ]; then
    echo -e "\033[0;31mERROR: Failed to sync app $APP_TO_SYNC\033[0m"
    exit 1
fi

echo -e "\033[0;36m======> WAIT SYNC $APP_TO_SYNC \033[0m\n"
echo -e "\033[0;33mExecuting: argocd app wait \"$APP_TO_SYNC\" --server \"$ARGO_CD_URL\" --auth-token \"***\" --grpc-web\033[0m"
argocd app wait "$APP_TO_SYNC" --server "$ARGO_CD_URL" --auth-token "$ARGO_CD_TOKEN" --grpc-web > /dev/null 2>&1 &
show_loading "Waiting for sync completion..."
wait $!
if [ $? -ne 0 ]; then
    echo -e "\033[0;31mERROR: Failed to wait for sync completion of app $APP_TO_SYNC\033[0m"
    exit 1
fi

echo -e "\033[0;36m======> DONE \033[0m\n"