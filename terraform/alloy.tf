# resource "helm_release" "alloy" {
#   name       = "alloy"
#   chart      = "alloy"
#   repository = "https://grafana.github.io/helm-charts"
#   namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

#   values = [
#     templatefile("${path.module}/charts/alloy/values.yaml", {})
#   ]

#   timeout = 120

#   depends_on = [
#     helm_release.prometheus,
#     helm_release.loki,
#     helm_release.tempo
#   ]
# }
