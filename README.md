# Descripción
Configuración e implementación de minikube, filebeat, elasticsearch, logstash y kibana

# Minikube
(para instalar minikube en windows usando docker desktop ,debe de ser con perfil admin)

**Descargar minikube.exe**

New-Item -Path 'D:\programas\minikube' -ItemType Directory -Force

Invoke-WebRequest -Uri "https://storage.googleapis.com/minikube/releases/latest/minikube-windows-amd64.exe" -OutFile "D:\programas\minikube\minikube.exe" -UseBasicParsing
<br><br>

**Establecer en PATH**

setx PATH "$($env:PATH);D:\programas\minikube"
<br><br>

**Validar minikube, reiniciando PowerShell**

minikube version
<br><br>


# Kubectl

Invoke-WebRequest -Uri "https://dl.k8s.io/release/v1.31.0/bin/windows/amd64/kubectl.exe" -OutFile "D:\programas\minikube\kubectl.exe"
setx PATH "$($env:PATH);D:\programas\minikube"
<br><br>

**Validar kubectl version**

kubectl version --client
<br><br>

**Iniciar minikube en modo docker**

minikube start --driver=docker
<br><br>


# Microservicio en Quarkus


-- para ver logs filebeat
kubectl -n logging logs -l k8s-app=filebeat


-- para cargar imagen local al minikube
minikube image load carlos89/quarkus-camel:latest


-- reiniciar logstash
docker-compose restart logstash


-- para construir la imagen del repositorio https://github.com/carloscalla89/quarkus-camel-rest
docker build -f src/main/docker/Dockerfile -t carlos89/quarkus-camel .

-- para ingresar al ELASTIC
http://localhost:5601/app/home#/


-------------------------------------------------------------------------------

# GRAFANA ALLOY
--grafana alloy
# 1) Añade y actualiza el repo de chart de Grafana
helm repo add grafana https://grafana.github.io/helm-charts 
helm repo update :contentReference[oaicite:0]{index=0}

# 2) Crea un namespace para Alloy
kubectl create namespace alloy

helm upgrade alloy grafana/alloy --namespace alloy  -f alloyvalues.yaml


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
Helm repo update

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack   --namespace monitoring   -f grafana.yaml


helm upgrade tempo-distributed grafana/tempo-distributed -n monitoring -f tempo-distributed-values.yaml




helm install kube-state-metrics prometheus-community/kube-state-metrics -n alloy


--------------------------------------------------------------------------------


# OPENTELEMETRY COLLECTOR

-- opentelemetry collector
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
Helm repo update

-- para actualizar la configuracion del otel-collector
helm upgrade --install otel-collector \
  open-telemetry/opentelemetry-collector \
  --namespace otel-collector \
  -f values.yaml


-- reiniciar deployment
kubectl rollout restart deployment/otel-collector-opentelemetry-collector -n otel-collector