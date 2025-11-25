
pipeline {
  agent any

  environment {
    IMAGE_NAME        = "nour292/examen"        // Repo Docker Hub
    DOCKERHUB_CREDS   = "dockerhub-creds"       // Jenkins credentials ID (Username + Access Token)
    SLACK_CHANNEL     = "#general"              // Canal Slack (ex: #cicd)
    SLACK_CREDENTIALS = "slack-token"           // Jenkins credentials ID (Secret text du token Slack)
    BRANCH            = "main"                  // Branche Git
    GIT_URL           = "https://github.com/rouissinour464/examen.git"
    IMAGE_TAG         = ""                      // défini dynamiquement
  }

  // Poll SCM toutes les 5 minutes
  triggers {
    pollSCM('H/5 * * * *')
  }

  options {
    timestamps()
    ansiColor('xterm')
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
          // Récupérer le short SHA (Windows via git)
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
        echo "Construction de l’image Docker basée sur Nginx"
        bat """
          docker version
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
        """
      }
    }

    stage('Docker Push') {
      steps {
        echo "Push de l’image Docker vers Docker Hub"
        withCredentials([
          usernamePassword(credentialsId: "${DOCKERHUB_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')
        ]) {
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
      script {
        echo "✅ Pipeline réussi : Image ${IMAGE_NAME}:${IMAGE_TAG} buildée et poussée !"
        // Notification Slack via plugin
        slackSend(
          channel: "${SLACK_CHANNEL}",
          color: 'good',
          message: "✅ *SUCCÈS* — ${env.JOB_NAME} #${env.BUILD_NUMBER}\nTag: `${env.IMAGE_TAG}`\nImage: `${env.IMAGE_NAME}`\nVoir: ${env.BUILD_URL}",
          tokenCredentialId: "${SLACK_CREDENTIALS}"
        )
      }
    }
    failure {
      script {
        echo "❌ Pipeline échoué pour le projet ${IMAGE_NAME} !"
        slackSend(
          channel: "${SLACK_CHANNEL}",
          color: 'danger',
          message: "❌ *ÉCHEC* — ${env.JOB_NAME} #${env.BUILD_NUMBER}\nVoir: ${env.BUILD_URL}",
          tokenCredentialId: "${SLACK_CREDENTIALS}"
        )
      }
    }
    always {
      cleanWs()
    }
  }
}
