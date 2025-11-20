
resource "aws_instance" "jenkins" {
  ami           = local.ami_id
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = "subnet-06fb23e3398df992b" #replace your Subnet

  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("jenkins.sh")
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-jenkins"
    }
  )
}

resource "aws_instance" "jenkins_agent" {
  ami           = local.ami_id
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = "subnet-06fb23e3398df992b" #replace your Subnet

  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("jenkins-agent.sh")
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-jenkins-agent"
    }
  )
}

resource "aws_security_group" "main" {
  name        =  "${var.project}-${var.environment}-jenkins"
  description = "Created to attatch Jenkins and its agents"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

 ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-jenkins"
    }
  )
}

resource "aws_route53_record" "jenkins" {
  zone_id = var.zone_id
  name    = "jenkins.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.jenkins.public_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "jenkins-agent" {
  zone_id = var.zone_id
  name    = "jenkins-agent.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.jenkins_agent.private_ip]
  allow_overwrite = true
}

#############################################
# resource "aws_instance" "jenkins" {
#   ami                    = data.aws_ami.joindevops.id
#   instance_type          = "t3.micro"
#   vpc_security_group_ids = ["sg-0d77b6722a0b541f4"]
#   subnet_id              = "subnet-06fb23e3398df992b"
#   user_data = file("jenkins.sh")

#   root_block_device {
#     volume_size = 50  # Set root volume size to 50GB
#     volume_type = "gp3"  # Use gp3 for better performance (optional)
#   }
#   tags = merge(
#     var.common_tags,
#     {
#         Name = "Jenkins"
#     }
#   )
# }

# resource "aws_instance" "jenkins-agent" {
#   ami                    = data.aws_ami.joindevops.id
#   instance_type          = "t3.micro"
#   vpc_security_group_ids = ["sg-0d77b6722a0b541f4"]
#   subnet_id              = "subnet-06fb23e3398df992b"
#   user_data = file("jenkins-agent.sh")

#   root_block_device {
#     volume_size = 50  # Set root volume size to 50GB
#     volume_type = "gp3"  # Use gp3 for better performance (optional)
#   }
#   tags = merge(
#     var.common_tags,
#     {
#         Name = "Jenkins-agent"
#     }
#   )
# }

# resource "aws_route53_record" "jenkins" {
#   zone_id = var.zone_id
#   name    = "jenkins"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.jenkins.public_ip]
# }

# resource "aws_route53_record" "jenkins_agent" {
#   zone_id = var.zone_id
#   name    = "jenkins-agent"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.jenkins-agent.private_ip]
# }
# resource "aws_route53_record" "jenkins_private" {
#   count   = aws_instance.jenkins.private_ip != "" ? 1 : 0
#   zone_id = var.zone_id
#   name    = "jenkins-private"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.jenkins.private_ip]
# }


###############################

# resource "aws_route53_record" "jenkins_private" {
#   count   = aws_instance.jenkins.private_ip != "" ? 1 : 0
#   zone_id = var.zone_id
#   name    = "jenkins-private"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.jenkins.private_ip]
# }

############
# resource "aws_route53_record" "expense" {
#   for_each = aws_instance.expense
#   zone_id = var.zone_id
#   #backend.ramana3490.online
#   name            = each.key  == "frontend" ? var.domain_name : "${each.key}.${var.domain_name}"
#   type            = "A"
#   ttl             = 1
#   records         = each.key  == "frontend" ? [each.value.public_ip] : [each.value.private_ip]
#   allow_overwrite = true
# }

# module "jenkins" {
#   source = "terraform-aws-modules/ec2-instance/aws"

#   name = "jenkins"

#   instance_type          = "t3.small"
#   vpc_security_group_ids = ["sg-03b0627228bbe37c5"]   # replace your SG
#   subnet_id              = "subnet-08f729b0eec39634f" # replace your Subnet
#   ami                    = data.aws_ami.ami_info.id
#   user_data              = file("jenkins.sh")

#   tags = {
#     Name = "jenkins"
#   }

#   # Correct root block device (object)
#   root_block_device = {
#     volume_size           = 50
#     volume_type           = "gp3"
#     delete_on_termination = true
#   }
# }

# module "jenkins_agent" {
#   source = "terraform-aws-modules/ec2-instance/aws"

#   name = "jenkins-agent"

#   instance_type          = "t3.small"
#   vpc_security_group_ids = ["sg-03b0627228bbe37c5"]
#   subnet_id              = "subnet-08f729b0eec39634f"
#   ami                    = data.aws_ami.ami_info.id
#   user_data              = file("jenkins-agent.sh")

#   tags = {
#     Name = "jenkins-agent"
#   }

#   # Correct root block device (object)
#   root_block_device = {
#     volume_size           = 50
#     volume_type           = "gp3"
#     delete_on_termination = true
#   }
# }

# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "~> 2.0"

#   zone_name = var.zone_name

#   records = [
#     {
#       name            = "jenkins"
#       type            = "A"
#       ttl             = 1
#       records         = [module.jenkins.public_ip]
#       allow_overwrite = true
#     },
#     {
#       name            = "jenkins-agent"
#       type            = "A"
#       ttl             = 1
#       records         = [module.jenkins_agent.private_ip]
#       allow_overwrite = true
#     }
#   ]
# }





# module "jenkins" {
#   source = "terraform-aws-modules/ec2-instance/aws"

#   name = "jenkins"

#   instance_type          = "t3.small"
#   vpc_security_group_ids = ["sg-0c86d154202a71583"]   #replace your SG
#   subnet_id              = "subnet-08f729b0eec39634f" #replace your Subnet
#   ami                    = data.aws_ami.ami_info.id
#   user_data              = file("jenkins.sh")
#   tags = {
#     Name = "jenkins"
#   }

#   # Define the root volume size and type
#   root_block_device = [
#     {
#       volume_size           = 50    # Size of the root volume in GB
#       volume_type           = "gp3" # General Purpose SSD (you can change it if needed)
#       delete_on_termination = true  # Automatically delete the volume when the instance is terminated
#     }
#   ]
# }

# module "jenkins_agent" {
#   source = "terraform-aws-modules/ec2-instance/aws"

#   name = "jenkins-agent"

#   instance_type          = "t3.small"
#   vpc_security_group_ids = ["sg-0c86d154202a71583"]
#   subnet_id              = "subnet-08f729b0eec39634f"
#   ami                    = data.aws_ami.ami_info.id
#   user_data              = file("jenkins-agent.sh")
#   tags = {
#     Name = "jenkins-agent"
#   }

#   root_block_device = [
#     {
#       volume_size           = 50    # Size of the root volume in GB
#       volume_type           = "gp3" # General Purpose SSD (you can change it if needed)
#       delete_on_termination = true  # Automatically delete the volume when the instance is terminated
#     }
#   ]
# }


# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "~> 2.0"

#   zone_name = var.zone_name

#   records = [
#     {
#       name = "jenkins"
#       type = "A"
#       ttl  = 1
#       records = [
#         module.jenkins.public_ip
#       ]
#       allow_overwrite = true
#     },
#     {
#       name = "jenkins-agent"
#       type = "A"
#       ttl  = 1
#       records = [
#         module.jenkins_agent.private_ip
#       ]
#       allow_overwrite = true
#     }
#   ]

# }