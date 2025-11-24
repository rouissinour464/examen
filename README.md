 Contenu détaillé des livrables


Code source du CV One Page

Fichiers HTML5/CSS3 dans le dossier src/.



Scripts Ansible

playbook.yml pour orchestrer les rôles.
Rôles séparés pour :

Mise à jour du système.
Installation de Docker.
Installation de Terraform.
Installation de Jenkins.





Fichier Terraform

main.tf pour créer le conteneur Docker moncv basé sur l’image Docker Hub.
Configuration du port externe 8585.



Pipeline Jenkins

Jenkinsfile avec étapes :

Checkout GitHub.
Build image Docker.
Push vers Docker Hub.
Notification Slack.





Dockerfile

Basé sur Nginx pour servir le CV statique.



Manifests Kubernetes

deployment.yaml (2 replicas).
service.yaml (NodePort).
argo-app.yaml pour GitOps avec Argo CD.



Monitoring Grafana

Documentation grafana-config.md expliquant :

Intégration de la VM.
Monitoring Docker.
Monitoring K3s.
