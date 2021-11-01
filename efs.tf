#------------------------------------------------------------------------------
#   EKS
#------------------------------------------------------------------------------


# Security group for EFS
resource "aws_security_group" "sg-efs" {
  name        = "eks-sg-efs"
  description = "Communication to efs"
  vpc_id      = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    description = "Allow NFS traffic - TCP 2049"
    cidr_blocks = []
  }
  tags = {
    Name = "${var.environment}-efs-security-group"
  }
}


# Adding efs
resource "aws_efs_file_system" "eks-efs" {
  creation_token = var.efs_name
  encrypted      = "true"
  tags = {
    Name = "${var.environment}-efs"
  }
}


# Mount target for efs
resource "aws_efs_mount_target" "efs-mount-tg_1" {
  #count = length (aws_eks_node_group.nodes_general.subnet_ids)
  file_system_id  = aws_efs_file_system.eks-efs.id
  subnet_id       = aws_subnet.private_1.id
  security_groups = [aws_security_group.sg-efs.id]
}


resource "aws_efs_mount_target" "efs-mount-tg_2" {
  #count = length (aws_eks_node_group.nodes_general.subnet_ids)
  file_system_id  = aws_efs_file_system.eks-efs.id
  subnet_id       = aws_subnet.private_2.id
  security_groups = [aws_security_group.sg-efs.id]
}


