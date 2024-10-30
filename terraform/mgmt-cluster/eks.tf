resource "aws_iam_role" "conli24_eks_iam_role" {
  name = "conli24-eks-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "conli24_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.conli24_eks_iam_role.name
}

resource "aws_eks_cluster" "conli24_mgmt_cluster" {
  name     = "conli24-mgmt-cluster"
  role_arn = aws_iam_role.conli24_eks_iam_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.mgmt_private_eu_west_1a.id,
      aws_subnet.mgmt_public_eu_west_1a.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.conli24_AmazonEKSClusterPolicy]
}
