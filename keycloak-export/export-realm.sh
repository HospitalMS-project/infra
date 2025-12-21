#!/bin/bash

# Script para exportar o realm 'hospital' do Keycloak

REALM_NAME="hospital"
CONTAINER_NAME="keycloak"
OUTPUT_DIR="./keycloak-export"
OUTPUT_FILE="${OUTPUT_DIR}/${REALM_NAME}-realm.json"

echo "🔐 Exportando realm '${REALM_NAME}' do Keycloak..."

# Verificar se o container está rodando
if ! docker ps | grep -q "${CONTAINER_NAME}"; then
    echo "❌ Erro: Container '${CONTAINER_NAME}' não está rodando!"
    echo "   Execute: docker-compose up -d keycloak"
    exit 1
fi

# Criar diretório se não existir
mkdir -p "${OUTPUT_DIR}"

# Obter token de acesso
echo "📝 Obtendo token de acesso..."
TOKEN=$(curl -s -X POST 'http://localhost:8085/realms/master/protocol/openid-connect/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'username=admin' \
  -d 'password=admin' \
  -d 'grant_type=password' \
  -d 'client_id=admin-cli' | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "❌ Erro: Falha ao obter token de acesso"
    echo "   Verifique se as credenciais estão corretas (admin/admin)"
    exit 1
fi

# Exportar realm
echo "📦 Exportando realm..."
curl -s -X GET "http://localhost:8085/admin/realms/${REALM_NAME}" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  > "${OUTPUT_FILE}"

# Verificar se o arquivo foi criado e não está vazio
if [ -f "${OUTPUT_FILE}" ] && [ -s "${OUTPUT_FILE}" ]; then
    echo "✅ Realm exportado com sucesso!"
    echo "   Arquivo: ${OUTPUT_FILE}"
    echo ""
    echo "💡 Dica: Para importar automaticamente na próxima inicialização,"
    echo "   descomente a linha KC_IMPORT no docker-compose.yml"
else
    echo "❌ Erro: Falha ao exportar realm"
    echo "   Verifique se o realm '${REALM_NAME}' existe no Keycloak"
    exit 1
fi



