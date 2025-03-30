resource "helm_release" "alloy" {
  name       = "alloy"
  chart      = "alloy"
  repository = "https://grafana.github.io/helm-charts"
  version    = "0.12.4"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

  values = [
    templatefile("${path.module}/charts/alloy/values.yaml", {})
  ]

  timeout = 80

  depends_on = [
    helm_release.loki,
    helm_release.tempo,
    helm_release.prometheus,
    kubernetes_namespace.monitoring_namespaces
  ]
}
