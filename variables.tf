#------------------------------------------------------------------------------
#   Variables 
#------------------------------------------------------------------------------

variable "environment" {
  description = "Define environment such as dev/prod/test"
}

variable "region" {
  description = "Specifies AWS region"
}

variable "availability_zone_1" {
  description = "Specifies first availability zone"
}
variable "availability_zone_2" {
  description = "Specifies second availability zone"
}

variable "efs_name" {
  description = "Specifies EFS name to be created"
}

variable "eks_cluster_name" {
  description = "Specifies EKS Kubernetes name"
}

variable "eks_cluster_version" {
  description = "Specifies EKS Kubernetes version"
}


variable "node_group" {
  type        = list(any)
  description = "define environment such as dev/prod/test"
}

variable "node_group_instance_type" {
  description = "Specifies Node Group EC2 instance type"
}

variable "ami_type" {
  description = "Specifies EC2 instance AMI to be used to create instance .Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64"
}

variable "worker_node_disk_size" {
  description = "Specifies EC2 worker node disk size"
  type        = number
}

variable "worker_node_desired_size" {
  description = "Specifies desired size of replicas"
  type        = number
}

variable "worker_node_max_size" {
  description = "Specifies maximin number of replicas"
  type        = number
}

variable "worker_node_min_size" {
  description = "Specifies minimum number of replicas"
  type        = number
}

variable "eks_sg_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "test"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "test"
    },
  ]
}

# nginx-ingress-controller vars
variable "ingress_nginx_name" {
  description = "Specifies ingress nginx name"
}

variable "ingress_nginx_repo" {
  description = "Specifies helm repo for ingress nginx "
}
variable "ingress_nginx_chart_name" {
  description = "Specifies chart name of ingress nginx "
}
variable "ingress_nginx_version" {
  description = "Specifies version to be installed of ingress nginx"
}

#efs-cs-driver vars
variable "enabled" {
  type    = bool
  default = true
}


variable "efs_esi_helm_chart_name" {
  type        = string
  description = "Amazon EFS CSI Driver chart name."
}

variable "efs_esi_helm_chart_release_name" {
  type        = string
  description = "Amazon EFS CSI Driver release name."
}

variable "efs_esi_helm_chart_repo" {
  type        = string
  description = "Amazon EFS CSI Driver repository name."
}

variable "efs_esi_helm_chart_version" {
  type        = string
  description = "Amazon EFS CSI Driver chart version."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create k8s namespace with name defined by `namespace`."
}

variable "efs_esi_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy EFS CSI Driver Helm chart."
}

variable "service_account_name" {
  type        = string
  default     = "aws-efs-csi-driver"
  description = "Amazon EFS CSI Driver service account name."
}

variable "storage_class_name" {
  type        = string
  default     = "efs-sc"
  description = "Storage class name for EFS CSI driver."
}

variable "create_storage_class" {
  type        = bool
  default     = true
  description = "Whether to create Storage class for EFS CSI driver."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/kubernetes-sigs/aws-efs-csi-driver."
}