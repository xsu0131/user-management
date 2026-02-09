pipeline {
  agent any

  environment {
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
    PATH = "${JAVA_HOME}/bin:${env.PATH}"
  }

  stages {

    /* ===============================
       Checkout source code
       =============================== */
    stage('Checkout') {
      steps {
        git branch: 'Backend-Testing',
            url: 'https://github.com/xsu0131/user-management.git'
      }
    }

    /* ===============================
       Build Spring Boot backend
       =============================== */
    stage('Build Backend') {
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

    /* ===============================
       Generate Ansible inventory
       (NOT committed to Git)
       =============================== */
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

    /* ===============================
       Deploy backend using Ansible
       =============================== */
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

            # Resolve the built JAR from Jenkins workspace
            JAR_PATH=$(ls $WORKSPACE/user-management-backend/target/*.jar | head -n 1)
            echo "Using backend jar: $JAR_PATH"

            cd ansible
            ansible-playbook playbooks/site.yml \
              --limit backend \
              --private-key "$SSH_KEY" \
              -e backend_jar_path="$JAR_PATH"
          '''
        }
      }
    }
  }

  post {
    success {
      echo ' Backend build + deployment successful'
    }
    failure {
      echo ' Backend pipeline failed'
    }
  }
}
