# minikube-and-elk
Configuración e implementación de minikube, filebeat, elasticsearch, logstash y kibana

# comandos
-- para instalar minikube en windows usando docker desktop (debe de ser con perfil admin)
New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing

-- instalando el kubectl
link: https://kubernetes.io/es/docs/tasks/tools/included/install-kubectl-windows

-- para ver logs filebeat
kubectl -n logging logs -l k8s-app=filebeat


-- para cargar imagen local al minikube
minikube image load carlos89/quarkus-camel:latest


-- reiniciar logstash
docker-compose restart logstash


-- para construir la imagen del repositorio https://github.com/carloscalla89/quarkus-camel-rest
docker build -f src/main/docker/Dockerfile -t carlos89/quarkus-camel .