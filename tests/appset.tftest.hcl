mock_provider "kubectl" {}

run "creates_platform_xrds_applicationset" {
  command = plan

  assert {
    condition     = kubectl_manifest.platform_xrds_appset.yaml_body != ""
    error_message = "ApplicationSet yaml_body must not be empty"
  }
}
