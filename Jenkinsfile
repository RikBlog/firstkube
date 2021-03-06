pipeline {
  agent any
  stages {
    stage('Docker Build') {
      steps {
        sh "docker build -t rikblog/devbakkie:${env.BUILD_NUMBER} ."
      }
    }
    stage('Docker Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh "docker push rikblog/devbakkie:${env.BUILD_NUMBER}"
        }
      }
    }
    stage('Docker Remove Image') {
      steps {
        sh "docker rmi rikblog/devbakkie:${env.BUILD_NUMBER}"
      }
    }
    stage('Apply Kubernetes Files') {
      steps {
          withKubeConfig([credentialsId: 'kubeconfigFile']) {
          sh 'cat deployment.yaml | sed "s/{{BUILD_NUMBER}}/$BUILD_NUMBER/g" | kubectl apply -f -'
          sh 'kubectl apply -f service.yaml'
          sh 'kubectl apply -f volume-devbakkie-data.yaml'
          sh 'kubectl apply -f volume-devbakkie-config.yaml'
          sh 'kubectl apply -f claim-devbakkie-config.yaml'
          sh 'kubectl apply -f claim-devbakkie-data.yaml'
        }
      }
  }
}

}
