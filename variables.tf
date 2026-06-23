variable "aws_region" {
  description = "AWS region where Secrets Manager secrets are stored"
  type        = string
  default     = "us-east-1"
}

variable "eso_namespace" {
  description = "Kubernetes namespace where ESO is installed"
  type        = string
  default     = "external-secrets"
}

variable "eso_service_account_name" {
  description = "Name of the ESO Kubernetes service account (must have IRSA annotation for Secrets Manager access)"
  type        = string
  default     = "eso-service-account"
}

variable "github_org" {
  description = "GitHub organisation to scan for repos tagged with platform-custom-xrds"
  type        = string
  default     = "urukube"
}

variable "github_token_secret_name" {
  description = "Name of the Kubernetes secret in the argocd namespace that holds the GitHub token"
  type        = string
  default     = "argocd-github-token"
}

variable "github_token_secret_key" {
  description = "Key within the secret that holds the GitHub token value"
  type        = string
  default     = "token"
}
