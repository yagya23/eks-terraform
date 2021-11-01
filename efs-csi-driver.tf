#------------------------------------------------------------------------------
#   EKS CSI Driver
#------------------------------------------------------------------------------

# Namespace for efs-csi-driver installation
resource "kubernetes_namespace" "kubernetes_efs_csi_driver" {
  depends_on = [var.mod_dependency]
  count      = (var.enabled && var.create_namespace && var.efs_esi_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.efs_esi_namespace
  }
}

# Open id connect provider
resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = aws_eks_cluster.eks.identity.0.oidc.0.issuer
}


# Helm chart for csi driver
resource "helm_release" "kubernetes_efs_csi_driver" {


  name       = var.efs_esi_helm_chart_name
  chart      = var.efs_esi_helm_chart_release_name
  repository = var.efs_esi_helm_chart_repo
  version    = var.efs_esi_helm_chart_version
  namespace  = var.efs_esi_namespace

  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.efs_csi_driver[0].arn
  }

  set {
    name  = "node.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "node.serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "node.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.efs_csi_driver[0].arn
  }

  values = [
    yamlencode(var.settings)
  ]
}


# aws_iam_role
data "aws_iam_policy_document" "efs_csi_driver" {
  count = var.enabled ? 1 : 0

  statement {
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "elasticfilesystem:CreateAccessPoint"
    ]
    resources = ["*"]
    effect    = "Allow"
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    actions = [
      "elasticfilesystem:DeleteAccessPoint"
    ]
    resources = ["*"]
    effect    = "Allow"
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "efs_csi_driver" {
  depends_on  = [var.mod_dependency]
  count       = var.enabled ? 1 : 0
  name        = "${var.eks_cluster_name}-efs-csi-driver"
  path        = "/"
  description = "Policy for the EFS CSI driver"

  policy = data.aws_iam_policy_document.efs_csi_driver[0].json
}

# Role
data "aws_iam_policy_document" "efs_csi_driver_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.efs_esi_namespace}:${var.service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "efs_csi_driver" {
  count              = var.enabled ? 1 : 0
  name               = "${var.eks_cluster_name}-efs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.efs_csi_driver_assume[0].json
}

resource "aws_iam_role_policy_attachment" "efs_csi_driver" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.efs_csi_driver[0].name
  policy_arn = aws_iam_policy.efs_csi_driver[0].arn
}


