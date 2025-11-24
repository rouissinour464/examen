pipeline {
    agent any

    environment {
        IMAGE_NAME = "nour292/examen"
        TAG = "latest"
        DOCKERHUB_CREDS = "dockerhub-creds" // ID des credentials Docker Hub
        SLACK_CHANNEL = "#general"          // mettre ton channel Slack
        SLACK_CREDENTIALS = "slack-token"   // token ou credentials Slack dans Jenkins
    }

    triggers {
        pollSCM('H/5 * * * *') // Scrute le dépôt toutes les 5 minutes
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Récupération du code depuis GitHub"
                git branch: 'main',
                    url: 'https://github.com/rouissinour464/examen.git'
            }
        }

        stage('Docker Build') {
            steps {
                echo "Construction de l’image Docker basée sur Nginx"
                sh '''
                    docker build -t ${IMAGE_NAME}:${TAG} .
                    docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Docker Push') {
            steps {
                echo "Push de l’image Docker vers Docker Hub"
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDS}",
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push ${IMAGE_NAME}:${TAG}
                        docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            slackSend(
                channel: "${SLACK_CHANNEL}",
                color: 'good',
                message: "Pipeline réussi : Image ${IMAGE_NAME}:${TAG} buildée et poussée avec succès !",
                tokenCredentialId: "${SLACK_CREDENTIALS}"
            )
        }
        failure {
            slackSend(
                channel: "${SLACK_CHANNEL}",
                color: 'danger',
                message: "Pipeline échoué pour le projet ${IMAGE_NAME} !",
                tokenCredentialId: "${SLACK_CREDENTIALS}"
            )
        }
    }
}
