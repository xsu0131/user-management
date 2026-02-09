pipeline {
  agent any

  environment {
    ANSIBLE_HOST_KEY_CHECKING = 'False'
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/xsu0131/user-management.git'
      }
    }

    stage('Generate Ansible Inventory') {
      steps {
        sh '''
          cd ansible
          mkdir -p inventory

          cat > inventory/inventory.ini <<EOF
[jenkins]
jenkins1 ansible_host=35.87.104.222

[frontend]
frontend1 ansible_host=35.167.2.22

[backend]
backend1 ansible_host=54.184.29.2

[db]
db1 ansible_host=44.249.35.75

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/project1u.pem
EOF
        '''
      }
    }

    stage('Deploy Backend') {
      steps {
        sh '''
          cd ansible
          ansible-playbook playbooks/site.yml --limit backend
        '''
      }
    }
  }

  post {
    success {
      echo ' Backend deployment successful'
    }
    failure {
      echo ' Backend deployment failed'
    }
  }
}
