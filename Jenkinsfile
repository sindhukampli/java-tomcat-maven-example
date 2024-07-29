pipeline {
    agent { label 'master' }
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
        AWS_REGION = 'ap-south-1'
        ECR_REPO_NAME = 'service-a' 
        ECR_REGISTRY = '654654623396.dkr.ecr.ap-south-1.amazonaws.com' 
    }
    stages {
        stage('Git Checkout Stage') {
            steps {
                git branch: 'main', url: 'https://github.com/sindhukampli/java-tomcat-maven-example.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
                        docker build -t $ECR_REGISTRY/$ECR_REPO_NAME:$IMAGE_TAG .
                    """
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    sh """
                        docker push $ECR_REGISTRY/$ECR_REPO_NAME:$IMAGE_TAG
                    """
                }
            }
        }
        stage('Deploy Stage') {
            steps {
                script {
                    sh """
                        helm install helm ./helm -n dev
                    """
                }
            }
        }
    }
}
