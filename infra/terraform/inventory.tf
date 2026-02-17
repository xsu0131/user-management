resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    backend_ip  = aws_instance.backend_server.public_ip
    database_ip = aws_instance.database_server.public_ip
    frontend_ip = aws_instance.frontend_server.public_ip
    key_name    = var.key_name
  })

  filename = "${path.module}/../ansible/inventory/hosts"
}
