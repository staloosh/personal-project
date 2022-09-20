pipeline { 
    agent any 
    def REPO_URL = "staloosh/litecoin"
    def HELM_APPNAME = "litecoin"
    def HELM_CHART_PATH = "kubernetes/litecoin-chart"
    stages {
        stage('Build docker image') { 
           withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh 'docker login --username="${USERNAME}" --password="${PASSWORD}"'
                sh "docker build -t ${REPO_URL}:${BUILD_NUMBER} ."
                sh 'docker images' 
        }
       
        stage('Test for vulnerabilities'){
            steps {
                sh "docker scan --file Dockerfile ${REPO_URL}:${BUILD_NUMBER} " 
            }
        }
        stage('Push docker image') { 
            withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh 'docker images'
                sh "docker push ${REPO_URL}:${BUILD_NUMBER}"
              }   
        }
        stage('Deploy to k3s') {
            steps {
                sh "echo 'Deploying...'"
            }
        }
    }
}
