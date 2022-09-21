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
        // Scanning first with Trivy as this is the recommended tool when it comes to CKS
        stage('Test for vulnerabilities using Trivy') {
            steps {
                sh "trivy image ${REPO_URL}:${env.BUILD_ID}"
            }
        }
        // Scanning with 'docker scan' which uses Snyk, implemented catch error due to the limited number of scans per month - 10
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
        // Deploying through helm but also outputing final manifests contents
        stage('Deploy to k3s') {
            steps {
                sh "kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -"
                sh "helm upgrade --install -f ${HELM_CHART_PATH}/values/test.yaml \
                ${HELM_APPNAME} ${HELM_CHART_PATH} -n ${NAMESPACE}"
                sh "helm get manifest -n ${NAMESPACE} ${HELM_APPNAME}"
            }
        }
        // The following stage will use helm to test service reachability, thus confirming that the service has the proper endpoints which are up and running
        // A sleep step was added to make sure the pod is running
        stage('Test deployment connection') {
            steps {
                sh 'sleep 30'
                sh "helm -n ${NAMESPACE} test ${HELM_APPNAME} --logs"
            }
        }
    }
}
