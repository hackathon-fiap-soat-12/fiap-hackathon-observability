resource "helm_release" "alloy" {
  name       = "alloy"
  chart      = "alloy"
  repository = "https://grafana.github.io/helm-charts"
  version    = "0.12.4"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

  values = [
    templatefile("${path.module}/charts/alloy/values.yaml", {})
  ]

  timeout = 180

  depends_on = [
    helm_release.loki,
    helm_release.tempo,
    helm_release.prometheus,
    kubernetes_namespace.monitoring_namespaces
  ]
}


resource "kubernetes_ingress_v1" "alloy_ingress" {
  metadata {
    name      = "fiap-hackathon-alloy-ingress"
    namespace = kubernetes_namespace.monitoring_namespaces.metadata[0].name

    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
      "nginx.ingress.kubernetes.io/use-regex"      = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path      = "/alloy(/|$)(.*)"
          path_type = "Prefix"

          backend {
            service {
              name = "alloy"
              port {
                number = 4318
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.alloy]
}
