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
                    sh """
                        echo "Connexion à DockerHub..."
                        echo "$PASS" | docker login -u "$USER" --password-stdin

                        echo "Construction de l'image Docker..."
                        docker build -t ${IMAGE_NAME}:${TAG} .

                        echo "Tagging de l'image..."
                        docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest

                        echo "Push de l'image vers DockerHub..."
                        docker push ${IMAGE_NAME}:${TAG}
                        docker push ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline réussi : Image ${IMAGE_NAME}:${TAG} buildée et poussée !"
        }
        failure {
            echo "Pipeline échoué pour le projet ${IMAGE_NAME} !"
        }
    }
}
