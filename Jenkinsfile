pipeline {
    agent { label 'master' }
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_REPO = 'docker1-jenkins'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/sindhukampli/java-tomcat-maven-example.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernameColonPassword(credentialsId: 'docker', variable: 'docker')]) ) {
                        sh """
                            echo $DOCKERHUB_PASSWORD | docker login --username $DOCKERHUB_USERNAME --password-stdin
                            docker build -t $DOCKERHUB_REPO:$IMAGE_TAG .
                        """
                    }
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernameColonPassword(credentialsId: 'docker', variable: 'docker')])  {
                        sh """
                            docker push $DOCKERHUB_REPO:$IMAGE_TAG
                        """
                    }
                }
            }
        }
        stage('Deploy Stage') {
            steps {
                script {
                    sh """
                        helm upgrade --install service-a ./helm -n dev
                    """
                }
            }
        }
    }
    post {
        always {
            cleanWs()  // Clean workspace after build
        }
    }
}
