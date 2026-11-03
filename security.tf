#################################
# ALB SECURITY GROUP
#################################

resource "aws_security_group" "alb_sg" {

  name        = "alb-sg"
  description = "ALB Security Group"

  vpc_id = aws_vpc.main.id

  ingress {

    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "HTTPS"

    from_port = 443
    to_port   = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "alb-security-group"
    }
  )
}

#################################
# EC2 SECURITY GROUP
#################################

resource "aws_security_group" "ec2_sg" {

  name        = "ec2-sg"
  description = "EC2 Security Group"

  vpc_id = aws_vpc.main.id

  ingress {

    description = "Allow HTTP from ALB"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "ec2-security-group"
    }
  )
}

#################################
# RDS SECURITY GROUP
#################################

resource "aws_security_group" "rds_sg" {

  name        = "rds-sg"
  description = "RDS Security Group"

  vpc_id = aws_vpc.main.id

  ingress {

    description = "PostgreSQL from EC2"

    from_port = 5432
    to_port   = 5432

    protocol = "tcp"

    security_groups = [
      aws_security_group.ec2_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "rds-security-group"
    }
  )
}