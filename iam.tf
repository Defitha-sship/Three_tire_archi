#################################
# IAM ROLE
#################################

resource "aws_iam_role" "ec2_role" {

  name = "ec2-instance-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

#################################
# SSM POLICY
#################################

resource "aws_iam_role_policy_attachment" "ssm_policy" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#################################
# INSTANCE PROFILE
#################################

resource "aws_iam_instance_profile" "ec2_profile" {

  name = "ec2-instance-profile"

  role = aws_iam_role.ec2_role.name
}