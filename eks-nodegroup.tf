#------------------------------------------------------------------------------
#   EKS Nodegroups
#------------------------------------------------------------------------------

resource "aws_iam_role" "nodes_general" {
  # The name of the role
  name = "eks-node-group-general"

  # The policy that grants an entity permission to assume the role.
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  # The ARN of the policy you want to apply.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  # The role the policy should be applied to
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  # The ARN of the policy you want to apply.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  # The role the policy should be applied to
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  # The ARN of the policy you want to apply.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  # The role the policy should be applied to
  role = aws_iam_role.nodes_general.name
}


resource "aws_eks_node_group" "nodes_general" {

  count = length(var.node_group)

  # Name of the EKS Cluster.
  cluster_name = aws_eks_cluster.eks.name

  # Name of the EKS Node Group.
  node_group_name = var.node_group[count.index]

  # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
  node_role_arn = aws_iam_role.nodes_general.arn

  # Identifiers of EC2 Subnets to associate with the EKS Node Group. 
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,

  ]


  # Configuration block with scaling settings
  scaling_config {
    # Desired number of worker nodes.
    desired_size = var.worker_node_desired_size

    # Maximum number of worker nodes.
    max_size = var.worker_node_max_size

    # Minimum number of worker nodes.
    min_size = var.worker_node_min_size
  }

  # Type of Amazon Machine Image (AMI) associated with the EKS Node Group.
  ami_type = var.ami_type


  # Disk size in GiB for worker nodes
  disk_size = var.worker_node_disk_size

  # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
  #force_update_version = false

  # List of instance types associated with the EKS Node Group
  instance_types = [var.node_group_instance_type]

  labels = {
    role = var.node_group[count.index]
  }

  # Kubernetes version
  version = var.eks_cluster_version

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]


}







