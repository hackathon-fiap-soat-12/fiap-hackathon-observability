resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "27.7.0"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

  timeout = 120

  values = [
    file("${path.module}/charts/prometheus/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.monitoring_namespaces
  ]
}