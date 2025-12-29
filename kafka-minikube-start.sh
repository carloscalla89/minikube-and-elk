#!/bin/bash

# Configuración
YAML_FILE="kafka-minikube.yaml"

# 1. Definimos los valores posibles
VALOR_LOCALHOST="localhost:9092"
VALOR_CLUSTER="kafka-service.kafka.svc.cluster.local:9092"

# 2. Lógica de selección (Default vs Internal)
TARGET_VALUE=$VALOR_CLUSTER
MODE="Modo Cluster Minikube"

# Si pasas el argumento --localhost o -i, cambiamos el valor
if [[ "$1" == "--localhost" || "$1" == "-i" ]]; then
    TARGET_VALUE=$VALOR_LOCALHOST
    MODE="Modo Localhost"
fi

# Colores para output visual
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}>>> Iniciando despliegue de Kafka...${NC}"
echo -e "${YELLOW}>>> Entorno: $MODE${NC}"
echo -e "${YELLOW}>>> Valor inyectado para \${KAFKA_SERVICE}: $TARGET_VALUE${NC}"

# 3. La Magia: Reemplazo y Despliegue
# Usamos sed para reemplazar literalmente "${KAFKA_SERVICE}" por el valor calculado.
# NOTA: Usamos comillas simples en '${KAFKA_SERVICE}' dentro del sed para que bash no intente interpretarlo antes.

cat $YAML_FILE | \
sed "s|\${KAFKA_SERVICE}|$TARGET_VALUE|g" | \
kubectl apply -f -

echo -e "${GREEN}>>> ¡Manifiesto aplicado correctamente!${NC}"
kubectl get pods -n kafka