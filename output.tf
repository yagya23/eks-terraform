#------------------------------------------------------------------------------
#   Output variables
#------------------------------------------------------------------------------


output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id."
}


output "eks_cluster_info" {
  value = aws_eks_cluster.eks
}