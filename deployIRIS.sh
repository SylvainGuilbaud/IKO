# script de déploiement d'IRIS for Health avec Kubernetes
# Ce script suppose que kubectl est déjà installé et configuré
# Assurez-vous que le contexte kubectl est configuré pour pointer vers votre cluster Kubernetes
#!/bin/bash
# Vérifier si kubectl est installé
if ! command -v kubectl &>/dev/null; then
    echo "kubectl n'est pas installé. Veuillez installer kubectl avant de continuer."
    exit 1
fi
# Vérifier si le contexte kubectl est configuré
if ! kubectl config current-context &>/dev/null; then
    echo "Aucun contexte kubectl configuré. Veuillez configurer kubectl pour pointer vers votre cluster Kubernetes."
    exit 1
fi  
# Déployer IRIS for Health
echo "Déploiement d'IRIS for Health..."
# Remplacez le nom de l'image et le tag par ceux que vous utilisez
IMAGE_NAME="intersystems/irishealth-community:latest"
# Créer un fichier de déploiement Kubernetes
cat <<EOF > iris-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iris-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: iris
  template:
    metadata:
      labels:
        app: iris
    spec:
      containers:
      - name: iris
        image: $IMAGE_NAME
        ports:
        - containerPort: 52773
        env:
        - name: ISC_DATA_DIRECTORY
          value: "/irisdata"
        volumeMounts:
        - name: iris-data
          mountPath: /irisdata
      volumes:
      - name: iris-data
        persistentVolumeClaim:
          claimName: iris-data-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: iris-service
spec:
  selector:
    app: iris
  ports:
  - protocol: TCP
    port: 52773
    targetPort: 52773
  type: LoadBalancer
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: iris-data-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
EOF 
# Appliquer le fichier de déploiement
kubectl apply -f iris-deployment.yaml   
# Vérifier le statut du déploiement
echo "Vérification du statut du déploiement..."
kubectl rollout status deployment/iris-deployment
# Afficher les services pour obtenir l'IP externe
echo "Services déployés :"
kubectl get services
# Afficher les pods pour vérifier que tout fonctionne
echo "Pods déployés :"
kubectl get pods
# Afficher les logs du pod IRIS
POD_NAME=$(kubectl get pods -l app=iris -o jsonpath="{.items[0].metadata.name}")
echo "Logs du pod IRIS :"
kubectl logs $POD_NAME
# Afficher l'URL d'accès à IRIS for Health
echo "IRIS for Health est déployé. Vous pouvez y accéder via l'URL suivante :"
EXTERNAL_IP=$(kubectl get service iris-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ -z "$EXTERNAL_IP" ]; then
    echo "L'IP externe n'est pas encore disponible. Veuillez réessayer après quelques instants."
else
    echo "http://$EXTERNAL_IP:52773/csp/health"
fi
# Nettoyer les fichiers temporaires
# rm -f iris-deployment.yaml
echo "Déploiement terminé."
# Fin du script de déploiement d'IRIS for Health

