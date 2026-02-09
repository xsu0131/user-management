########################
# AMI (Ubuntu 22.04)
########################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

########################
# Default VPC & Subnet
########################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

########################
# Locals
########################
locals {
  ec2_instance_connect_cidr = "18.206.107.24/29"

  jenkins_user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y ec2-instance-connect openjdk-17-jdk

    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null

    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null

    apt-get update -y
    apt-get install -y jenkins

    systemctl enable jenkins
    systemctl start jenkins
  EOF
}

########################
# Security Group
########################
resource "aws_security_group" "jenkins" {
  name        = "jenkins-sg"
  description = "Jenkins Security Group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.ec2_instance_connect_cidr]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################
# Jenkins EC2
########################
resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  key_name      = var.key_name

  subnet_id = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins.id]

  user_data = local.jenkins_user_data

  tags = {
    Name = "jenkins-server"
  }
}
