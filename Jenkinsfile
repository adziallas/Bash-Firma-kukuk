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
                sh 'cd backend && mvn clean package -Pprod -DskipTests'
            }
        }

        stage('Prepare Frontend') {
            steps {
                sh 'echo "Statischer Frontend-Build – kein npm nötig"'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerlogin',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker build -t $BACKEND_IMAGE:latest backend
                        docker build -t $FRONTEND_IMAGE:latest frontend
                        docker push $BACKEND_IMAGE:latest
                        docker push $FRONTEND_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy to Dev') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-creds',
                                      variable: 'KUBECONFIG')]) {
                    sh 'kubectl --kubeconfig=$KUBECONFIG apply -f k8s/dev/'
                }
            }
        }

        stage('Deploy to Prod') {
            steps {
                script {
                    try {
                        input message: 'Prod deploy freigeben?', ok: 'Ja'
                        withCredentials([file(credentialsId: 'kubeconfig-creds',
                                              variable: 'KUBECONFIG')]) {
                            sh 'kubectl --kubeconfig=$KUBECONFIG apply -f k8s/prod/'
                        }
                    } catch (err) {
                        echo "Prod-Deploy übersprungen: ${err}"
                    }
                }
            }
        }

        stage('Smoke-Test Backend') {
            steps {
                sh 'curl -s http://localhost:8080/ | grep "Willkommen bei Bash-Firma Kukuk"'
            }
        }
    }
}
