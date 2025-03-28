resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  version    = "8.5.1"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

  values = [
    file("${path.module}/charts/grafana/values.yaml")
  ]

  timeout = 120

  depends_on = [
    kubernetes_namespace.monitoring_namespaces,
    helm_release.prometheus,
    helm_release.loki,
    helm_release.tempo
  ]
}

resource "kubernetes_ingress_v1" "grafana_ingress" {
  metadata {
    name      = "fiap-hachathon-grafana-ingress"
    namespace = kubernetes_namespace.monitoring_namespaces.metadata[0].name

    annotations = {
      "nginx.ingress.kubernetes.io/x-forwarded-port" = "true"
      "nginx.ingress.kubernetes.io/x-forwarded-host" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path      = "/grafana"
          path_type = "Prefix"

          backend {
            service {
              name = "grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.grafana
  ]
}
