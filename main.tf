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
  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "ApplicationSet"
    metadata = {
      name      = "platform-custom-xrds"
      namespace = "argocd"
    }
    spec = {
      generators = [
        {
          scmProvider = {
            github = {
              organization = var.github_org
              tokenRef = {
                secretName = var.github_token_secret_name
                secretKey  = var.github_token_secret_key
              }
            }
            filters = [
              {
                labelMatch = "platform-custom-xrds"
              }
            ]
            cloneProtocol = "https"
          }
        }
      ]
      template = {
        metadata = {
          name = "xrd-{{repository}}"
          labels = {
            "managed-by" = "platform-custom-xrds-appset"
          }
        }
        spec = {
          project = "default"
          source = {
            repoURL        = "{{url}}"
            targetRevision = "main"
            path           = "."
          }
          destination = {
            server    = "https://kubernetes.default.svc"
            namespace = "crossplane-system"
          }
          syncPolicy = {
            automated = {
              prune    = true
              selfHeal = true
            }
            syncOptions = [
              "CreateNamespace=false"
            ]
          }
        }
      }
    }
  })
}
