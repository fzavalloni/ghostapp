output "chart" {
  description = "The name of this Helm chart."
  value = {
    for release in helm_release.this :
    release.name => release.chart
  }
}
output "namespace" {
  description = "The namespace of this release on Kubernetes."
  value = {
    for release in helm_release.this :
    release.name => release.namespace
  }
}
output "status" {
  description = "Status of this release on Kubernetes."
  value = {
    for release in helm_release.this :
    release.name => release.status
  }
}
output "version" {
  description = "A SemVer 2 conformant version string of this Helm chart."
  value = {
    for release in helm_release.this :
    release.name => release.version
  }
}
output "values" {
  description = " The compounded values from values and set attributes for this Helm chart."
  value = {
    for release in helm_release.this :
    release.name => release.values
  }
}
