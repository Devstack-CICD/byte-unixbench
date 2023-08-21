pipeline {
  agent { kubernetes {inheritFrom 'default' } }
  parameters {
    choice(name: 'CHOICE_OVERLAY', choices: ['dev', 'stg'], description: '업데이트 할 환경(Overrlay)을 선택하세요')
  }
  environment{
    DOCKER_URL = "https://harbor.mlpipeline.io"
  }
  stages {
    stage ('Login Harbor') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: "harbor_cred",
          passwordVariable: "DOCKER_PASSWORD",
          usernameVariable: "DOCKER_ID")]
        ) {
          sh(
            label: 'login harbor registry',
            script: 'docker login -u $DOCKER_ID -p $DOCKER_PASSWORD ${DOCKER_URL}'
          )
        }
        script {
          changed = true
        }
      }
    }
    stage ('Build Image') {
      when { 
        beforeAgent true
        expression { changed == true } 
      }
      steps {
        sh "make build-image"
      }
    }
    stage ('Push Image') {
      when {
        expression { params.CHOICE_OVERLAY != 'NO_CHOICE' }
        beforeAgent true
      }
      steps {
        sh "DOCKER_PROJECT_NAME=${params.CHOICE_OVERLAY} make push-image"
      }
    }  
  }
}
