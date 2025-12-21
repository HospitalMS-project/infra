# Exportação e Importação de Realm do Keycloak

## Como exportar o realm após configurá-lo

Após configurar o realm `hospital` no Keycloak, você pode exportá-lo para manter a configuração persistente.

### Método 1: Via Admin Console (Recomendado)

1. Acesse o Keycloak: http://localhost:8085
2. Faça login com: `admin` / `admin`
3. Vá em **Realm Settings** do realm `hospital`
4. Clique na aba **Export**
5. Selecione **Export** para baixar o arquivo JSON

### Método 2: Via linha de comando (Docker)

```bash
# Entrar no container do Keycloak
docker exec -it keycloak /bin/bash

# Exportar o realm hospital
/opt/keycloak/bin/kc.sh export --dir /opt/keycloak/data/export --realm hospital

# Copiar o arquivo para fora do container
docker cp keycloak:/opt/keycloak/data/export/hospital-realm.json ./keycloak-export/hospital-realm.json
```

### Método 3: Via API do Keycloak

```bash
# Obter token de acesso
TOKEN=$(curl -X POST 'http://localhost:8085/realms/master/protocol/openid-connect/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'username=admin' \
  -d 'password=admin' \
  -d 'grant_type=password' \
  -d 'client_id=admin-cli' | jq -r '.access_token')

# Exportar realm
curl -X GET "http://localhost:8085/admin/realms/hospital" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  > hospital-realm.json
```

## Importar realm automaticamente

Para importar o realm automaticamente na inicialização, descomente a linha no docker-compose.yml:

```yaml
KC_IMPORT: /opt/keycloak/data/import/hospital-realm.json
```

E monte o arquivo no volume:

```yaml
volumes:
  - ./keycloak-export/hospital-realm.json:/opt/keycloak/data/import/hospital-realm.json:ro
```

**Nota:** O Keycloak importa o realm apenas na primeira inicialização. Se o realm já existir, a importação será ignorada.

## Importar via linha de comando

```bash
# Copiar arquivo para o container
docker cp ./keycloak-export/hospital-realm.json keycloak:/tmp/hospital-realm.json

# Importar
docker exec -it keycloak /opt/keycloak/bin/kc.sh import --file /tmp/hospital-realm.json
```



