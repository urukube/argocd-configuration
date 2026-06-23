# argocd-configuration

Terraform module that creates ArgoCD ApplicationSets for the urukube orchestrator platform.

## ApplicationSet: platform-custom-xrds

Discovers all GitHub repos in the organisation tagged with the topic **`platform-custom-xrds`** and creates one ArgoCD Application per repo. Each repo holds Crossplane XRDs / Compositions that are synced to the orchestrator cluster's `crossplane-system` namespace from the `main` branch.

### Prerequisites

A Kubernetes secret must exist in the `argocd` namespace before applying:

```bash
kubectl create secret generic argocd-github-token \
  --from-literal=token=<GitHub-PAT> \
  -n argocd
```

The PAT requires: `repo` (read) and `read:org` scopes.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
