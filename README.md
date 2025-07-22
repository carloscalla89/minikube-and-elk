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