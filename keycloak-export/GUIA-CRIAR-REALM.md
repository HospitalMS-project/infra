# 📋 Guia Completo: Criar e Exportar Realm no Keycloak

## 🚀 Passo 1: Iniciar o Keycloak

Primeiro, certifique-se de que o Keycloak está rodando:

```bash
cd infra
docker-compose up -d keycloak postgres-keycloak
```

Aguarde alguns segundos até o Keycloak iniciar completamente (pode levar 30-60 segundos).

## 🔐 Passo 2: Acessar o Keycloak

1. Abra seu navegador e acesse: **http://localhost:8085**
2. Você verá a página inicial do Keycloak

## 👤 Passo 3: Fazer Login como Admin

1. Clique em **"Administration Console"** ou acesse diretamente: http://localhost:8085/admin
2. **Username:** `admin`
3. **Password:** `admin`
4. Clique em **"Sign In"**

## 🏗️ Passo 4: Criar o Realm "hospital"

### 4.1 Criar o Realm

1. No menu superior à esquerda, passe o mouse sobre **"Master"** (o realm padrão)
2. Clique no ícone **"+"** ou no dropdown
3. Selecione **"Create Realm"** ou **"Add realm"**
4. Na tela que abrir:
   - **Realm name:** `hospital`
   - Deixe **"Enabled"** marcado (já vem marcado por padrão)
5. Clique em **"Create"**

### 4.2 Configurar o Realm (Recomendado)

Agora você está no realm `hospital`. Vamos fazer algumas configurações básicas:

#### Configurar Login (Opcional)

1. No menu lateral esquerdo, vá em **Realm Settings** (Configurações do Realm)
2. Vá na aba **Login**
3. Ative **"User registration"** se quiser permitir registro de usuários
4. Clique em **"Save"**

#### Criar um Client para o API Gateway

1. No menu lateral esquerdo, vá em **Clients**
2. Clique em **"Create client"**
3. Preencha:
   - **Client type:** `OpenID Connect`
   - **Client ID:** `api-gateway`
   - Clique em **"Next"**
4. Em **Capability config:**
   - Marque **"Client authentication"** (para client credentials flow)
   - Marque **"Authorization"** (opcional, se for usar)
   - Clique em **"Next"**
5. Em **Login settings:**
   - **Valid redirect URIs:** `*` (ou URLs específicas do seu frontend)
   - **Web origins:** `*` (ou origens específicas)
   - Clique em **"Save"**
6. Na aba **Credentials** (Credenciais):
   - Copie o **"Client secret"** - você vai precisar dele depois
   - Ou clique em **"Regenerate"** se preferir

#### Criar Usuários de Teste (Opcional)

1. No menu lateral, vá em **Users**
2. Clique em **"Create new user"**
3. Preencha:
   - **Username:** (ex: `usuario-teste`)
   - **Email:** (opcional)
   - Ative **"Email verified"** se forneceu email
   - Ative **"Enabled"** para ativar o usuário
4. Clique em **"Create"**
5. Na aba **Credentials** (Credenciais):
   - Defina uma senha temporária
   - Desative **"Temporary"** se não quiser que o usuário tenha que trocar a senha no primeiro login
   - Clique em **"Set password"**

## 📦 Passo 5: Exportar o Realm

Agora vamos exportar tudo que configuramos. Você tem 3 opções:

### Opção 1: Usando o Script PowerShell (Mais Fácil) ⭐

```powershell
cd infra/keycloak-export
.\export-realm.ps1
```

O script vai:
- ✅ Verificar se o Keycloak está rodando
- ✅ Obter token de autenticação
- ✅ Exportar o realm `hospital`
- ✅ Salvar em `hospital-realm.json`

### Opção 2: Via Interface Web (Admin Console)

1. No Keycloak Admin Console, vá em **Realm Settings**
2. Clique na aba **Export**
3. Escolha o formato:
   - **Export:** Exporta tudo (recomendado)
   - **Export for import:** Formato otimizado para importação
4. Clique em **"Export"**
5. O arquivo JSON será baixado
6. Renomeie para `hospital-realm.json` e coloque na pasta `infra/keycloak-export/`

### Opção 3: Via API REST (Linha de comando)

```powershell
# Obter token
$tokenResponse = Invoke-RestMethod -Uri "http://localhost:8085/realms/master/protocol/openid-connect/token" `
    -Method Post `
    -ContentType "application/x-www-form-urlencoded" `
    -Body @{
        username = "admin"
        password = "admin"
        grant_type = "password"
        client_id = "admin-cli"
    }

$token = $tokenResponse.access_token

# Exportar realm
Invoke-RestMethod -Uri "http://localhost:8085/admin/realms/hospital" `
    -Method Get `
    -Headers @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" } `
    | ConvertTo-Json -Depth 100 | Out-File -FilePath "infra/keycloak-export/hospital-realm.json" -Encoding UTF8
```

## ✅ Passo 6: Verificar o Arquivo Exportado

Verifique se o arquivo foi criado:

```powershell
ls infra/keycloak-export/hospital-realm.json
```

O arquivo deve existir e ter um tamanho razoável (alguns KB).

## 🔄 Passo 7: Configurar Importação Automática (Opcional)

Se você quiser que o realm seja importado automaticamente na próxima vez que subir o Keycloak:

1. Abra `infra/docker-compose.yml`
2. No serviço `keycloak`, encontre a linha comentada:
   ```yaml
   # KC_IMPORT: /opt/keycloak/data/import/hospital-realm.json
   ```
3. Descomente para:
   ```yaml
   KC_IMPORT: /opt/keycloak/data/import/hospital-realm.json
   ```
4. Descomente também a linha do volume:
   ```yaml
   volumes:
     - ./keycloak-export/hospital-realm.json:/opt/keycloak/data/import/hospital-realm.json:ro
     - keycloak-data:/opt/keycloak/data
   ```

**⚠️ ATENÇÃO:** A importação automática só funciona na primeira inicialização. Se o realm já existir, a importação será ignorada.

## 🎯 Resumo dos Passos

1. ✅ Iniciar Keycloak: `docker-compose up -d keycloak`
2. ✅ Acessar: http://localhost:8085/admin
3. ✅ Login: `admin` / `admin`
4. ✅ Criar realm: `hospital`
5. ✅ Configurar client: `api-gateway`
6. ✅ Exportar: `.\export-realm.ps1`
7. ✅ Arquivo salvo: `infra/keycloak-export/hospital-realm.json`

## 🔍 Verificar se Está Tudo Certo

Para testar se a configuração está funcionando:

```powershell
# Ver conteúdo do arquivo exportado
Get-Content infra/keycloak-export/hospital-realm.json | Select-Object -First 20
```

Você deve ver um JSON com as informações do realm, incluindo `"realm": "hospital"`.

## 💡 Dicas

- **Backup:** Sempre faça backup do arquivo `hospital-realm.json`
- **Versionamento:** Adicione o arquivo ao `.gitignore` se contiver informações sensíveis
- **Senhas:** O export não inclui senhas de usuários, apenas configurações
- **Client Secrets:** O export inclui client secrets, então trate o arquivo com segurança



