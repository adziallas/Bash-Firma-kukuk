pipeline {
    agent any

    environment {
        REGISTRY = "docker.io/andziallas"
        BACKEND_IMAGE = "${REGISTRY}/backend-kukuk"
        FRONTEND_IMAGE = "${REGISTRY}/kukuk-frontend"
    }

    stages {
        stage('Build Backend') {
            steps {
                echo "Baue Backend mit Maven..."
                sh '''
                    set -x
                    cd backend
                    mvn clean package -Pdev -DskipTests
                '''
            }
        }

        stage('Build Frontend') {
            steps {
                echo "Installiere und baue Frontend..."
                sh '''
                    set -x
                    cd frontend
                    npm install
                    npm run build
                '''
            }
        }

        stage('Docker Build & Push') {
            steps {
                echo "Baue und pushe Docker-Images..."
                withCredentials([string(credentialsId: 'docker-hub-token', variable: 'DOCKER_TOKEN')]) {
                    sh '''
                        echo "$DOCKER_TOKEN" | docker login -u "andziallas" --password-stdin
                        docker build -t ${BACKEND_IMAGE}:latest backend
                        docker build -t ${FRONTEND_IMAGE}:latest frontend
                        docker push ${BACKEND_IMAGE}:latest
                        docker push ${FRONTEND_IMAGE}:latest
                    '''
                }
            }
        }

        stage('Deploy to Dev') {
            steps {
                echo "Deploy nach Dev..."
                withCredentials([file(credentialsId: 'andrea-kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        set -x
                        kubectl --kubeconfig=$KUBECONFIG apply -f k8s/dev/
                    '''
                }
            }
        }

        stage('Deploy to Prod') {
            steps {
                script {
                    try {
                        input message: 'Prod deploy freigeben?', ok: 'Ja'
                        withCredentials([file(credentialsId: 'andrea-kubeconfig', variable: 'KUBECONFIG')]) {
                            sh '''
                                set -x
                                kubectl --kubeconfig=$KUBECONFIG apply -f k8s/prod/
                            '''
                        }
                    } catch (err) {
                        echo "Prod-Deploy übersprungen: ${err}"
                    }
                }
            }
        }
    }
}
