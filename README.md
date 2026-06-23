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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.platform_xrds_appset](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | GitHub organisation to scan for repos tagged with platform-custom-xrds | `string` | `"urukube"` | no |
| <a name="input_github_token_secret_key"></a> [github\_token\_secret\_key](#input\_github\_token\_secret\_key) | Key within the secret that holds the GitHub token value | `string` | `"token"` | no |
| <a name="input_github_token_secret_name"></a> [github\_token\_secret\_name](#input\_github\_token\_secret\_name) | Name of the Kubernetes secret in the argocd namespace that holds the GitHub token | `string` | `"argocd-github-token"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_applicationset_name"></a> [applicationset\_name](#output\_applicationset\_name) | Name of the ArgoCD ApplicationSet that discovers platform XRD repos |
<!-- END_TF_DOCS -->
