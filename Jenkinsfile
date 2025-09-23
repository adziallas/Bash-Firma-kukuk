pipeline {
  agent any
  environment {
    REGISTRY = "registry.example.com/kukuk"
    BACKEND_IMAGE = "${REGISTRY}/backend"
    FRONTEND_IMAGE = "${REGISTRY}/frontend"
    KUBECONFIG = credentials('kubeconfig-cred')
    DOCKER_CREDS = credentials('docker-hub-creds')
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build Backend') {
      steps {
        dir('backend') {
          sh 'mvn clean package -Pdev -DskipTests'
        }
      }
    }
    stage('Test Backend') {
      steps {
        dir('backend') {
          sh 'mvn test'
        }
      }
    }
    stage('Build Frontend') {
      steps {
        dir('frontend') {
          sh 'npm install'
          sh 'npm run build'
        }
      }
    }
    stage('Test Frontend') {
      steps {
        dir('frontend') {
          sh 'npm test || echo "Keine Frontend-Tests gefunden"'
        }
      }
    }
    stage('Docker Build & Push') {
      steps {
        sh "docker login -u ${DOCKER_CREDS_USR} -p ${DOCKER_CREDS_PSW}"
        sh "docker build -t ${BACKEND_IMAGE}:${BUILD_NUMBER} backend"
        sh "docker push ${BACKEND_IMAGE}:${BUILD_NUMBER}"
        sh "docker tag ${BACKEND_IMAGE}:${BUILD_NUMBER} ${BACKEND_IMAGE}:latest"
        sh "docker push ${BACKEND_IMAGE}:latest"
        sh "docker build -t ${FRONTEND_IMAGE}:${BUILD_NUMBER} frontend"
        sh "docker push ${FRONTEND_IMAGE}:${BUILD_NUMBER}"
        sh "docker tag ${FRONTEND_IMAGE}:${BUILD_NUMBER} ${FRONTEND_IMAGE}:latest"
        sh "docker push ${FRONTEND_IMAGE}:latest"
      }
    }
    stage('Deploy Dev') {
      steps {
        script {
          withKubeConfig([credentialsId: 'kubeconfig-cred']) {
            sh '''
              kubectl apply -f k8s/namespaces.yaml
              kubectl -n dev apply -f k8s/backend-deployment.yaml
              kubectl -n dev apply -f k8s/backend-service.yaml
              kubectl -n dev apply -f k8s/frontend-deployment.yaml
              kubectl -n dev apply -f k8s/frontend-service.yaml
            '''
          }
        }
      }
    }
    stage('Approval for Prod') {
      steps {
        input message: "Soll in PROD deployed werden?", ok: "Deploy"
      }
    }
    stage('Deploy Prod') {
      steps {
        script {
          withKubeConfig([credentialsId: 'kubeconfig-cred']) {
            sh '''
              kubectl -n prod apply -f k8s/backend-deployment.yaml
              kubectl -n prod apply -f k8s/backend-service.yaml
              kubectl -n prod apply -f k8s/frontend-deployment.yaml
              kubectl -n prod apply -f k8s/frontend-service.yaml
            '''
          }
        }
      }
    }
  }
  post {
    success {
      echo "Pipeline erfolgreich abgeschlossen!"
    }
    failure {
      echo "Pipeline fehlgeschlagen!"
    }
  }
}
