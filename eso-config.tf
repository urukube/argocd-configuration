################################################################################
# ESO ClusterSecretStore + ExternalSecrets
#
# Placed here (not in orchestrator-custom-addons) because the kubectl provider
# caches API discovery at init time. When ESO CRDs are installed in the same
# apply as these resources, the provider doesn't know about the CRDs yet.
# Running in a separate component (after orchestrator-custom-addons) guarantees
# ESO is fully installed and CRDs are registered before this apply starts.
################################################################################

resource "kubectl_manifest" "eso_cluster_secret_store" {
  server_side_apply = true
  wait              = true

  yaml_body = yamlencode({
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = "aws-secrets-manager"
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.aws_region
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = var.eso_service_account_name
                namespace = var.eso_namespace
              }
            }
          }
        }
      }
    }
  })
}

resource "kubectl_manifest" "eso_argocd_github_token" {
  server_side_apply = true
  wait              = true

  yaml_body = yamlencode({
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata = {
      name      = "argocd-github-token"
      namespace = "argocd"
    }
    spec = {
      refreshInterval = "1h"
      secretStoreRef = {
        kind = "ClusterSecretStore"
        name = "aws-secrets-manager"
      }
      target = {
        name           = "argocd-github-token"
        creationPolicy = "Owner"
      }
      data = [{
        secretKey = "token"
        remoteRef = {
          key = "platform/github/github-token"
        }
      }]
    }
  })

  depends_on = [kubectl_manifest.eso_cluster_secret_store]
}

resource "kubectl_manifest" "eso_argocd_admin_password" {
  server_side_apply = true
  wait              = true

  yaml_body = yamlencode({
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata = {
      name      = "argocd-admin-password"
      namespace = "argocd"
    }
    spec = {
      refreshInterval = "1h"
      secretStoreRef = {
        kind = "ClusterSecretStore"
        name = "aws-secrets-manager"
      }
      target = {
        name           = "argocd-secret"
        creationPolicy = "Merge"
      }
      data = [{
        secretKey = "admin.password"
        remoteRef = {
          key = "platform/argocd/admin-password"
        }
      }]
    }
  })

  depends_on = [kubectl_manifest.eso_cluster_secret_store]
}
