
resource "kubernetes_namespace" "k8s_dashboard" {
  metadata {
    annotations = {
      name = "kubernetes-dashboard"
    }
    name = "kubernetes-dashboard"
  }
}

resource "kubernetes_service_account" "admin_user" {
  metadata {
    name = "admin-user"
    namespace = kubernetes_namespace.k8s_dashboard.metadata.0.name
  }
}

resource "kubernetes_cluster_role_binding" "admin_user_crb" {
  metadata {
    name = "admin-user"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "admin-user"
    namespace = kubernetes_namespace.k8s_dashboard.metadata.0.name
  }
}


resource "helm_release" "dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  #version    = "6.0.1"
  namespace  = kubernetes_namespace.k8s_dashboard.metadata.0.name
}


