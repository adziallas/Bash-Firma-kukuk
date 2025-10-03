 pipeline {
    agent any
    environment {
        REGISTRY       = "docker.io/andziallas"
        BACKEND_IMAGE  = "${REGISTRY}/backend-kukuk"
        FRONTEND_IMAGE = "${REGISTRY}/kukuk-frontend"
    }
    stages {
        stage('Build Backend') {
            steps {
                bat 'cd backend && mvn clean package -Pdev -DskipTests'
            }
        }
        stage('Build Frontend') {
            steps {
                bat 'cd frontend && npm install'
                bat 'cd frontend && npm run build'
            }
        }
        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                        docker build -t ${BACKEND_IMAGE}:latest backend
                        docker build -t ${FRONTEND_IMAGE}:latest frontend
                        docker push ${BACKEND_IMAGE}:latest
                        docker push ${FRONTEND_IMAGE}:latest
                        """
                }
            }
        }
        stage('Deploy to Dev') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-cred',
                                      variable: 'KUBECONFIG')]) {
                    bat 'kubectl --kubeconfig=%KUBECONFIG% apply -f k8s/dev/'
                }
            }
        }
        stage('Deploy to Prod') {
            steps {
                script {
                    try {
                        input message: 'Prod deploy freigeben?', ok: 'Ja'
                        withCredentials([file(credentialsId: 'kubeconfig-cred',
                                              variable: 'KUBECONFIG')]) {
                            bat 'kubectl --kubeconfig=%KUBECONFIG% apply -f k8s/prod/'
                        }
                    } catch (err) {
                        echo "Prod-Deploy übersprungen: ${err}"
                    }
                }
            }
        }
    }
 }