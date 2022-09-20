pipeline { 
    agent any
    environment {
    REPO_URL = "staloosh/litecoin"
    HELM_APPNAME = "litecoin"
    HELM_CHART_PATH = "kubernetes/litecoin-chart"
    }
    stages {
        stage('Build docker image') {
            steps {
              withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh 'docker login --username="${USERNAME}" --password="${PASSWORD}"'
                sh "docker build -t ${REPO_URL}:${BUILD_NUMBER} ."
                sh 'docker images'
              }
           }
        }
        stage('Push docker image') {
            steps {
              withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh 'docker images'
                sh "docker push ${REPO_URL}:${BUILD_NUMBER}"
              }
            }
        }
        stage('Test for vulnerabilities using Trivy'){
            steps {
                sh "trivy image ${REPO_URL}:${BUILD_NUMBER}"
            }
        }
        stage('Test for vulnerabilities using Snyk'){
            steps {
                sh "docker scan --file Dockerfile ${REPO_URL}:${BUILD_NUMBER}" 
            }
        }
        stage('Deploy to k3s') {
            steps {
                sh "echo 'Deploying...'"
            }
        }
    }
}
