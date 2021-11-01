#------------------------------------------------------------------------------
#   Storage Class, Persistence Volumne
#------------------------------------------------------------------------------


#kubernetes

output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = join("", aws_eks_cluster.eks.*.id)
}


data "aws_eks_cluster" "cluster" {
  name = join("", aws_eks_cluster.eks.*.id)
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}


# attaching storage class
resource "kubernetes_storage_class" "tf_efs_sc" {
  metadata {
    name = "tf-eks-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  reclaim_policy      = "Retain"
  storage_provisioner = "efs.csi.aws.com"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = "${data.aws_efs_file_system.efs-name.file_system_id}"
    directoryPerms : "777"
  }
  mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
  depends_on = [
    aws_eks_node_group.nodes_general,
  ]
}

# attaching persistent volume claim
resource "kubernetes_persistent_volume_claim" "tf_efs_pvc" {
  metadata {
    name = "tf-eks-pvc"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    #volume_name = "${kubernetes_persistent_volume.pv_example.metadata.0.name}"
    storage_class_name = kubernetes_storage_class.tf_efs_sc.id

  }
}




















data "aws_efs_file_system" "efs-name" {
  depends_on = [aws_efs_file_system.eks-efs]
}

#output "efs_details" {
#    value = data.aws_efs_file_system.efs-name.file_system_id
#}


































































































































































































