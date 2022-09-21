pipeline {
    agent any
    environment {
        REPO_URL = 'staloosh/litecoin'
        HELM_APPNAME = 'litecoin'
        HELM_CHART_PATH = 'kubernetes/litecoin-chart'
        NAMESPACE = 'crypto'
        registryCredential = 'docker-login'
        dockerImage = ''
    }
    stages {
        stage('Build docker image') {
            steps {
                script {
                    dockerImage = docker.build("${REPO_URL}:${env.BUILD_ID}")
                }
            }
        }
        stage('Test for vulnerabilities using Trivy') {
            steps {
                sh "trivy image ${REPO_URL}:${env.BUILD_ID}"
            }
        }
        stage('Test for vulnerabilities using Snyk') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh "docker scan ${REPO_URL}:${env.BUILD_ID} --accept-license"
                    exit 0
                }
            }
        }
        stage('Deploy docker image to dockerhub') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push("${env.BUILD_ID}")
                        dockerImage.push('latest')
                    }
                }
            }
        }
        stage('Cleanup - Remove unused dockerimages from node') {
            steps {
                sh "docker rmi ${REPO_URL}:${env.BUILD_ID}"
                sh "docker rmi ${REPO_URL}:latest"
            }
        }
        stage('Deploy to k3s') {
            steps {
                sh "kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -"
                sh "helm upgrade --install -f ${HELM_CHART_PATH}/values/test.yaml \
                ${HELM_APPNAME} ${HELM_CHART_PATH} -n ${NAMESPACE}"
                sh "helm get manifest -n ${NAMESPACE} ${HELM_APPNAME}"
            }
        }
    }
}
