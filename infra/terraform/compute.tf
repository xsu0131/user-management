resource "aws_instance" "backend_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.backend_instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              EOF

  tags = {
    Name = "${var.environment}-backend-server"
  }
}

resource "aws_instance" "database_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.database_instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              EOF

  tags = {
    Name = "${var.environment}-database-server"
  }
}

resource "aws_instance" "frontend_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.frontend_instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              EOF

  tags = {
    Name = "${var.environment}-frontend-server"
  }
}
