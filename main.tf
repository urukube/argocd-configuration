################################################################################
# ArgoCD ApplicationSet — Platform Custom XRDs
#
# Discovers all repos in the GitHub org tagged with the topic
# "platform-custom-xrds" and creates one ArgoCD Application per repo.
# Each repo is expected to hold Crossplane XRDs / Compositions on its main branch.
#
# Prerequisites:
#   - ArgoCD must be installed on the cluster
#   - A Kubernetes secret must exist in the argocd namespace:
#       kubectl create secret generic <github_token_secret_name> \
#         --from-literal=<github_token_secret_key>=<PAT> \
#         -n argocd
#   - The PAT needs at minimum: repo (read) + read:org scopes
################################################################################

resource "kubectl_manifest" "platform_xrds_appset" {
  yaml_body = templatefile("${path.module}/yamls/platform-xrds-appset.yaml", {
    github_org               = var.github_org
    github_token_secret_name = var.github_token_secret_name
    github_token_secret_key  = var.github_token_secret_key
  })
}

resource "kubectl_manifest" "platform_tenant_registry_app" {
  yaml_body = templatefile("${path.module}/yamls/platform-tenant-registry-app.yaml", {
    github_org = var.github_org
  })
}
