# Para instalar postgres en minikube (Usar valores por defecto): Creará la BD dragonballdb con usuario user_db
./postgres-dragonballdb-minikube-start.sh

# Esto conecta el puerto 5432 de tu PC al 5432 del pod en Minikube. Para conectarse desde algun ide (ejemplo DBeaver):
kubectl port-forward svc/dragonballdb-postgres-service 5432:5432 -n database

# Para borrar todo lo relacionado a la bd
kubectl delete namespace database

* Si usas kubectl delete -f postgres-minikube.yaml, a veces el PVC (PersistentVolumeClaim) se queda "colgando" o el volumen físico no se recicla correctamente en Minikube, y al reinstalar podrías encontrarte con errores de permisos o datos antiguos. Borrar el namespace es la forma segura de garantizar un "Hard Reset"
