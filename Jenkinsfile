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

    stage('Build Backend') {
      environment {
        JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
      }
      steps {
        sh '''
          echo "=== Java toolchain check ==="
          java -version
          javac -version
          mvn -v

          echo "=== Building backend ==="
          cd user-management-backend
          mvn clean package -DskipTests
        '''
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
EOF
        '''
      }
    }

    stage('Deploy Backend') {
      steps {
        withCredentials([
          sshUserPrivateKey(
            credentialsId: 'ec2-ssh-key',
            keyFileVariable: 'SSH_KEY'
          )
        ]) {
          sh '''
            chmod 600 "$SSH_KEY"

            cd ansible
            ansible-playbook playbooks/site.yml \
              --limit backend \
              --private-key "$SSH_KEY" \
              -e backend_jar_path=../user-management-backend/target/*.jar
          '''
        }
      }
    }
  }

  post {
    success {
      echo ' Backend build and deployment successful'
    }
    failure {
      echo ' Backend pipeline failed'
    }
  }
}
