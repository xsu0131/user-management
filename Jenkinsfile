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
