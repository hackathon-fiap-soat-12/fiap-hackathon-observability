resource "kubernetes_namespace" "monitoring_namespaces" {
  metadata {
    name = "monitoring"
  }
}
