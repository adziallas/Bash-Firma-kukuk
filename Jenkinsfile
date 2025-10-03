pipeline {
    agent any

    environment {
        REGISTRY       = "docker.io/andziallas"
        BACKEND_IMAGE  = "${REGISTRY}/backend-kukuk"
        FRONTEND_IMAGE = "${REGISTRY}/kukuk-frontend"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Backend') {
            steps {
                sh '''
                    set -e
                    cd backend
                    mvn clean package -Pprod -DskipTests
                '''
            }
        }

        stage('Prepare Frontend') {
            steps {
                sh '''
                    set -e
                    echo "Statisches Frontend – keine Build-Schritte nötig"
                    ls -la frontend
                '''
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerlogin',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        set -e
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
                    sh '''
                        set -e
                        kubectl --kubeconfig=$KUBECONFIG get nodes | grep Ready
                        kubectl --kubeconfig=$KUBECONFIG apply -f k8s/dev/ --validate=false
                    '''
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
                            sh '''
                                set -e
                                kubectl --kubeconfig=$KUBECONFIG get nodes | grep Ready
                                kubectl --kubeconfig=$KUBECONFIG apply -f k8s/prod/ --validate=false
                            '''
                        }
                    } catch (err) {
                        echo "Prod-Deploy übersprungen: ${err}"
                    }
                }
            }
        }

        stage('Smoke-Test Backend') {
            steps {
                sh '''
                    set -e
                    if ! curl -s http://localhost:8080/index.html | grep -q "Willkommen bei Bash-Firma Kukuk"; then
                        echo "❌ Smoke-Test fehlgeschlagen: Text nicht gefunden"
                        exit 1
                    fi
                '''
            }
        }
    }
}
