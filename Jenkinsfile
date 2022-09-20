pipeline { 
    agent any 
    stages {
        stage('Build docker image') { 
            steps { 
                sh "echo 'building..'"
            }
        }
       
        stage('Test for vulnerabilities'){
            steps {
                sh "echo 'Testing...'" 
            }
        }
        stage('Push docker image') { 
            steps { 
                sh "echo 'building..'"
            }
        }
        stage('Deploy to k3s') {
            steps {
                sh "echo 'Deploying...'"
            }
        }
    }
}
