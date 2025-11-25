
pipeline {
    agent any

    environment {
        IMAGE_NAME        = "nour292/examen"
        DOCKERHUB_CREDS   = "dockerhub-creds"
        SLACK_CHANNEL     = "#general"
        SLACK_CREDENTIALS = "slack-token"
        BRANCH            = "main"
        GIT_URL           = "https://github.com/rouissinour464/examen.git"
        IMAGE_TAG         = ""
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Récupération du code depuis GitHub"
                git branch: env.BRANCH, url: env.GIT_URL
            }
        }

        stage('Set Tag') {
            steps {
                script {
                    def commit = bat(script: 'git rev-parse --short HEAD', returnStdout: true)
                                  .trim()
                                  .split("\\r?\\n")
                                  .last()
                                  .trim()
                    env.IMAGE_TAG = "${env.BUILD_NUMBER}-${commit}"
                    echo "Tag d'image = ${env.IMAGE_TAG}"
                }
            }
        }

        stage('Docker Build') {
            steps {
                bat """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    bat """
                        echo %PASS% | docker login -u %USER% --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                        docker logout
                    """
                }
            }
        }
    }

    post {
        success {
            slackSend(
                channel: "${SLACK_CHANNEL}",
                color: 'good',
                message: "✅ Pipeline réussi : Image ${IMAGE_NAME}:${IMAGE_TAG} buildée et poussée avec succès !",
                tokenCredentialId: "${SLACK_CREDENTIALS}"
            )
        }
        failure {
            slackSend(
                channel: "${SLACK_CHANNEL}",
                color: 'danger',
                message: "❌ Pipeline échoué pour le projet ${IMAGE_NAME} !",
                tokenCredentialId: "${SLACK_CREDENTIALS}"
            )
        }
    }
}
