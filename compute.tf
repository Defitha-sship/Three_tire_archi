#################################
# AMAZON LINUX 2023
#################################

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {

    name = "name"

    values = ["al2023-ami-*-x86_64"]
  }
}
#################################
# LAUNCH TEMPLATE
#################################

resource "aws_launch_template" "app" {

  name_prefix = "app-template"

  image_id = data.aws_ami.amazon_linux.id

  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  iam_instance_profile {

    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(
    file("${path.module}/userdata.sh")
  )

  tag_specifications {

    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "app-server"
      }
    )
  }
}

#################################
# AUTO SCALING GROUP
#################################

resource "aws_autoscaling_group" "app" {

  name = "app-asg"

  desired_capacity = 2

  min_size = 2

  max_size = 4

  vpc_zone_identifier = [
    aws_subnet.private_app.id
  ]

  launch_template {

    id = aws_launch_template.app.id

    version = "$Latest"
  }

  health_check_type = "EC2"

  tag {

    key = "Name"

    value = "asg-instance"

    propagate_at_launch = true
  }
}
