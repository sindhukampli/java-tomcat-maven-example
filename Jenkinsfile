pipeline {
    agent { label 'master' }
    environment {
        ACCOUNT_ID = "654654623396"
        REGION = "ap-south-1"
        ECR_REPO_NAME = "jenkins-docker"
        IMAGE_TAG = "${BUILD_NUMBER}"
        REPOSITORY_URI = "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/sindhukampli/java-tomcat-maven-example.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Login to AWS ECR
                    sh "aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}"

                    // Build Docker image
                    sh "docker build -t ${REPOSITORY_URI}:${IMAGE_TAG} ."
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    // Push Docker image to ECR
                    sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Deploy using Helm
                    sh "helm upgrade --install my-app ./helm --namespace dev --set image.repository=${REPOSITORY_URI},image.tag=${IMAGE_TAG}"
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
