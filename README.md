# Kustomize ArgoCD manifests

GitHub action used kustomize applications manifests

## Inputs

- **app-name:** The App name;
- **argo-cd-token:** The ArgoCD token to authenticate;
- **argo-cd-url:** The ArgoCD URL;
- **env-prefix:** The app env prefix in argocd app name (dev|prd);

**OBS.:** All inputs are **required**

## Outputs

There are no outputs for this action

## Example usage

```yaml
      - name: ArgoCD Sync
        uses: <ORG NAME>/github-actions-argocd-sync@master
        with:
          app-name: <The application name>
          argo-cd-token: ${{ secrets.argo-cd-token }}
          argo-cd-url: <The ArgoCD URL>
          env-prefix: 'dev'
```

## How to send updates?
If you wants to update or make changes in module code you should use the **develop** branch of this repository, you can test your module changes passing the `@develop` in module calling. Ex.:

```yaml
      # Example using this actions
      - name: ArgoCD Sync
        uses: <ORG NAME>/github-actions-argocd-sync@develop
        with:
          app-name: <The application name>
          argo-cd-token: ${{ secrets.argo-cd-token }}
          argo-cd-url: <The ArgoCD URL>
          env-prefix: 'dev'

```
After execute all tests you can open a pull request to the master branch.