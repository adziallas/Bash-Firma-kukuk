pipeline {
    agent any

    environment {
        REGISTRY        = "docker.io/andziallas"
        BACKEND_IMAGE   = "${REGISTRY}/backend-kukuk"
        FRONTEND_IMAGE  = "${REGISTRY}/kukuk-frontend"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Backend (Dev)') {
            steps {
                sh '''
                    set -e
                    cd backend
                    mvn clean package -Pdev -DskipTests
                '''
            }
        }

        stage('Test Backend (Dev)') {
            steps {
                sh '''
                    set -e
                    cd backend
                    mvn test -Pdev
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

        stage('Docker Build & Push (Dev)') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerlogin',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        set -e
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker build -t $BACKEND_IMAGE:dev backend
                        docker build -t $FRONTEND_IMAGE:dev frontend
                        docker push $BACKEND_IMAGE:dev
                        docker push $FRONTEND_IMAGE:dev
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

        stage('Build & Test Backend (Prod)') {
            steps {
                sh '''
                    set -e
                    cd backend
                    mvn clean package -Pprod -DskipTests
                    mvn test -Pprod
                '''
            }
        }

        stage('Docker Build & Push (Prod)') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerlogin',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        set -e
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker build -t $BACKEND_IMAGE:prod backend
                        docker build -t $FRONTEND_IMAGE:prod frontend
                        docker push $BACKEND_IMAGE:prod
                        docker push $FRONTEND_IMAGE:prod
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
    }
}
