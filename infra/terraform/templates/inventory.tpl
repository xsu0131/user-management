[backend]
${backend_ip}

[database]
${database_ip}

[frontend]
${frontend_ip}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ubuntu/.ssh/project1u.pem
ansible_python_interpreter=/usr/bin/python3