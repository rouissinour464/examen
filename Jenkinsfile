pipeline {
    agent any

    environment {
        IMAGE_NAME = "nour292/examen"
        TAG = "latest"
        DOCKERHUB_CREDS = "dockerhub-creds"
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Récupération du code depuis GitHub"
                git branch: 'main',
                    url: 'https://github.com/rouissinour464/examen.git'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDS}",
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    script {
                        bat """
                            docker login -u %USER% -p %PASS%
                            docker build -t ${env.IMAGE_NAME}:${env.TAG} .
                            docker tag ${env.IMAGE_NAME}:${env.TAG} ${env.IMAGE_NAME}:latest
                            docker push ${env.IMAGE_NAME}:${env.TAG}
                            docker push ${env.IMAGE_NAME}:latest
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline réussi : Image ${env.IMAGE_NAME}:${env.TAG} buildée et poussée !"
        }
        failure {
            echo "Pipeline échoué pour le projet ${env.IMAGE_NAME} !"
        }
    }
}
