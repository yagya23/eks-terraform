#------------------------------------------------------------------------------
#   TFVARS File
#------------------------------------------------------------------------------


environment              = "test"
region                   = "us-east-1"
availability_zone_1      = "us-east-1a"
availability_zone_2      = "us-east-1b"
eks_cluster_name         = "eks"
eks_cluster_version      = "1.21"
efs_name                 = "my-efs"
node_group_instance_type = "t3.small"
node_group               = ["system-application-node", "cpu-application-node","gpu-application-node"]
ami_type                 = "AL2_x86_64"
worker_node_disk_size    = 15
worker_node_desired_size = 1
worker_node_max_size     = 1
worker_node_min_size     = 1
ingress_nginx_name       = "ingress-nginx"
ingress_nginx_repo       = "https://kubernetes.github.io/ingress-nginx"
ingress_nginx_chart_name = "ingress-nginx"
ingress_nginx_version    = "4.0.6"
efs_esi_helm_chart_name = "aws-efs-csi-driver"
efs_esi_helm_chart_release_name = "aws-efs-csi-driver" 
efs_esi_helm_chart_repo = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
efs_esi_helm_chart_version = "2.2.0"



