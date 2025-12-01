pipeline {
    agent any

    environment {
        IMAGE_NAME = "nour292/examen"
        TAG = "latest"
        DOCKERHUB_CREDS = "dockerhub-creds"
        SLACK_CHANNEL = "#general"         // Ton channel Slack
        SLACK_CREDENTIALS = "slack-token" // ID credentials Slack dans Jenkins
    }

    triggers {
        pollSCM('H/5 * * * *') // Vérifie le dépôt toutes les 5 minutes
    }

    stages {

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDS}",
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo "Connexion à DockerHub..."
                        echo "$PASS" | docker login -u "$USER" --password-stdin

                        echo "Construction de l'image Docker..."
                        docker build -t ${IMAGE_NAME}:${TAG} .

                        echo "Tagging de l'image..."
                        docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest

                        echo "Push de l'image vers DockerHub..."
                        docker push ${IMAGE_NAME}:${TAG}
                        docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }

        stage('Slack Notification') {
            steps {
                slackSend(
                    channel: "${SLACK_CHANNEL}",
                    color: 'good',
                    message: "Pipeline réussi : Image ${IMAGE_NAME}:${TAG} buildée et poussée !",
                    tokenCredentialId: "${SLACK_CREDENTIALS}"
                )
            }
        }
    }

    post {
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

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDS}",
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo "Connexion à DockerHub..."
                        echo "$PASS" | docker login -u "$USER" --password-stdin

                        echo "Construction de l'image Docker..."
                        docker build -t ${IMAGE_NAME}:${TAG} .

                        echo "Tagging de l'image..."
                        docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest

                        echo "Push de l'image vers DockerHub..."
                        docker push ${IMAGE_NAME}:${TAG}
                        docker push ${IMAGE_NAME}:latest
                    '''
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
