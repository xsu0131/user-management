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
# Jenkins Security Group
########################
resource "aws_security_group" "jenkins" {
  name   = "${var.name_prefix}-jenkins-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    description = "Jenkins UI"
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
  subnet_id     = aws_subnet.public.id
  key_name      = var.key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y ec2-instance-connect curl unzip
  EOF

  tags = {
    Name = "${var.name_prefix}-jenkins"
  }
}

########################
# Outputs (IMPORTANT)
########################
output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}
