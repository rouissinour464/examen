pipeline {
    agent any

    environment {
        IMAGE_NAME = "nour292/examen"
        TAG = "latest"
        DOCKERHUB_CREDS = "dockerhub-creds" // ID des credentials Docker Hub dans Jenkins
        // SLACK_CHANNEL = "#general"        // Slack désactivé pour l'instant
        // SLACK_CREDENTIALS = "slack-token"
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
                bat """
                    docker build -t %IMAGE_NAME%:%TAG% .
                    docker tag %IMAGE_NAME%:%TAG% %IMAGE_NAME%:latest
                """
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
                    bat """
                        echo %PASS% | docker login -u %USER% --password-stdin
                        docker push %IMAGE_NAME%:%TAG%
                        docker push %IMAGE_NAME%:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline réussi : Image %IMAGE_NAME%:%TAG% buildée et poussée avec succès !"
            // Pour activer Slack, décommente le bloc ci-dessous et installe le plugin Slack
            /*
            slackSend(
                channel: "${SLACK_CHANNEL}",
                color: 'good',
                message: "Pipeline réussi : Image ${IMAGE_NAME}:${TAG} buildée et poussée avec succès !",
                tokenCredentialId: "${SLACK_CREDENTIALS}"
            )
            */
        }
        failure {
            echo "Pipeline échoué pour le projet %IMAGE_NAME% !"
            /*
            slackSend(
                channel: "${SLACK_CHANNEL}",
                color: 'danger',
                message: "Pipeline échoué pour le projet ${IMAGE_NAME} !",
                tokenCredentialId: "${SLACK_CREDENTIALS}"
            )
            */
        }
    }
}
