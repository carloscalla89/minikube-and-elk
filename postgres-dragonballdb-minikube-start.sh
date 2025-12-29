#!/bin/bash

# ==========================================
# CONFIGURACIÓN DE LA BASE DE DATOS
# ==========================================
# Puedes cambiar estos valores aquí directamente o pasarlos como argumentos al ejecutar el script.
# Argumento 1: Nombre de la BD
# Argumento 2: Usuario
# Argumento 3: Contraseña

DB_NAME=${1:-"dragonballdb"}       # Valor por defecto: dragonballdb
DB_USER=${2:-"user_db"}            # Valor por defecto: user_db
DB_PASS=${3:-"password_secure"}    # Valor por defecto: password_secure

YAML_TEMPLATE="postgres-template-minikube.yaml"

# Colores para output visual
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. Validación
if [ ! -f "$YAML_TEMPLATE" ]; then
    echo -e "${RED}Error: No se encuentra el archivo plantilla $YAML_TEMPLATE${NC}"
    echo "Asegúrate de estar en la misma carpeta donde guardaste el archivo YAML."
    exit 1
fi

echo -e "${BLUE}>>> Iniciando despliegue de PostgreSQL en Minikube...${NC}"
echo -e "    📂 Base de Datos:  ${GREEN}$DB_NAME${NC}"
echo -e "    👤 Usuario:        ${GREEN}$DB_USER${NC}"
echo -e "    🔑 Contraseña:     ${GREEN}******${NC}"

# 2. Procesamiento y Despliegue
# Usamos sed para reemplazar las variables del template y lo enviamos directo a kubectl
# NOTA: Usamos el delimitador pipe (|) para evitar conflictos con caracteres especiales

cat $YAML_TEMPLATE | \
sed "s|\${DATABASE}|$DB_NAME|g" | \
sed "s|\${DATABASE_USER}|$DB_USER|g" | \
sed "s|\${DATABASE_PASS}|$DB_PASS|g" | \
kubectl apply -f -

# 3. Verificación
if [ $? -eq 0 ]; then
    echo -e "${GREEN}>>> ¡Despliegue exitoso!${NC}"
    echo "Verificando recursos en el namespace 'database'..."
    kubectl get all -n database
else
    echo -e "${RED}>>> Hubo un error al aplicar los manifiestos.${NC}"
fi