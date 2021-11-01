#------------------------------------------------------------------------------
#   Nginx Ingress Controller
#------------------------------------------------------------------------------

# Helm
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

# Installing nginx controller

resource "helm_release" "nginx_ingress" {

  name       = var.ingress_nginx_name
  repository = var.ingress_nginx_repo
  chart      = var.ingress_nginx_chart_name
  version    = var.ingress_nginx_version

  values = [<<EOF
controller:
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
    type: LoadBalancer
EOF
  ]

  depends_on = [
    aws_eks_node_group.nodes_general,
  ]
}
