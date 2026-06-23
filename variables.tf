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
