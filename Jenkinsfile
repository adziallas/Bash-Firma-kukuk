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
                sh 'cd backend && mvn clean package -Pdev -DskipTests'
            }
        }

        stage('Build Frontend') {
            steps {
                echo "Installiere und baue Frontend..."
                sh 'cd frontend && npm install'
                sh 'cd frontend && npm run build'
            }
        }

        stage('Docker Build & Push') {
            steps {
                echo "Baue und pushe Docker-Images..."
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
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
                echo "Deploy nach Dev..."
                withCredentials([file(credentialsId: 'andrea-kubeconfig', variable: 'KUBECONFIG')]) {
                    sh 'kubectl --kubeconfig=$KUBECONFIG apply -f k8s/dev/'
                }
            }
        }

        stage('Deploy to Prod') {
            steps {
                script {
                    try {
                        input message: 'Prod deploy freigeben?', ok: 'Ja'
                        withCredentials([file(credentialsId: 'andrea-kubeconfig', variable: 'KUBECONFIG')]) {
                            sh 'kubectl --kubeconfig=$KUBECONFIG apply -f k8s/prod/'
                        }
                    } catch (err) {
                        echo "Prod-Deploy übersprungen: ${err}"
                    }
                }
            }
        }
    }
}
