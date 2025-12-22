# 🔧 Configurar Client no Keycloak - Correção Rápida

## ❌ Erro: "Invalid client" ou "Invalid client credentials"

Este erro acontece quando o client `api-gateway` não está configurado corretamente no Keycloak.

## ✅ Solução: Configurar o Client Corretamente

### Opção 1: Configurar como Public Client (RECOMENDADO - Mais Simples)

1. **Acesse o Keycloak Admin Console:**
   - URL: http://localhost:8085/admin
   - Login: `admin` / `admin`
   - Selecione o realm **"hospital"**

2. **Vá em Clients:**
   - Menu lateral → **Clients**
   - Procure pelo client **"api-gateway"** (ou crie um novo)

3. **Se o client NÃO existe, crie:**
   - Clique em **"Create client"**
   - **Client type:** `OpenID Connect`
   - **Client ID:** `api-gateway`
   - Clique em **"Next"**

4. **Configure as opções:**
   - ⚠️ **NÃO marque** "Client authentication" (deixe desmarcado)
   - Clique em **"Next"**

5. **Em Login settings:**
   - **Valid redirect URIs:** `*` (ou URLs específicas)
   - **Web origins:** `*` (ou origens específicas)
   - Clique em **"Save"**

6. **Na aba Settings (que abrirá automaticamente), verifique:**
   - ✅ **Access Type:** deve estar como **"public"** (não "confidential")
   - ✅ **Direct access grants:** deve estar **ON** ✅
   - ✅ **Standard flow:** pode estar ON ou OFF (não importa para password grant)
   - ✅ **Enabled:** deve estar **ON** ✅

7. **Salve as alterações**

### Opção 2: Usar admin-cli (ALTERNATIVA - Já vem configurado)

Se você não quiser configurar o client `api-gateway`, pode usar o client `admin-cli` que já vem configurado:

- **Client ID:** `admin-cli`
- **Não precisa de client_secret**

## 🧪 Testar se Funcionou

### Teste com api-gateway (Public Client):

```powershell
$response = Invoke-RestMethod -Uri "http://localhost:8085/realms/hospital/protocol/openid-connect/token" `
    -Method Post `
    -ContentType "application/x-www-form-urlencoded" `
    -Body @{
        username = "admin"
        password = "admin"
        grant_type = "password"
        client_id = "api-gateway"
    }

Write-Host "Token obtido: $($response.access_token.Substring(0, 20))..."
```

### Teste com admin-cli (Alternativa):

```powershell
$response = Invoke-RestMethod -Uri "http://localhost:8085/realms/hospital/protocol/openid-connect/token" `
    -Method Post `
    -ContentType "application/x-www-form-urlencoded" `
    -Body @{
        username = "admin"
        password = "admin"
        grant_type = "password"
        client_id = "admin-cli"
    }

Write-Host "Token obtido: $($response.access_token.Substring(0, 20))..."
```

## 🔍 Verificar Configuração Atual

Para verificar como o client está configurado:

1. **Keycloak Admin Console** → **Clients** → **api-gateway** → **Settings**
2. Verifique:
   - **Access Type:** deve ser **"public"**
   - **Direct access grants:** deve estar **ON** ✅
   - **Enabled:** deve estar **ON** ✅

## ⚠️ Se o Client for "Confidential"

Se você configurou o client como "confidential" (com Client authentication ON):

1. Você **precisa** enviar o `client_secret`
2. Pegue o secret em: **Clients** → **api-gateway** → **Credentials** → **Client Secret**
3. Use na requisição:
   ```powershell
   -Body @{
       username = "admin"
       password = "admin"
       grant_type = "password"
       client_id = "api-gateway"
       client_secret = "SEU_CLIENT_SECRET_AQUI"
   }
   ```

## 📝 Resumo das Configurações Necessárias

### Public Client (Recomendado):
- ✅ Access Type: **public**
- ✅ Direct access grants: **ON**
- ✅ Client authentication: **OFF**
- ❌ **NÃO precisa** de client_secret

### Confidential Client:
- ✅ Access Type: **confidential**
- ✅ Direct access grants: **ON**
- ✅ Client authentication: **ON**
- ✅ **PRECISA** de client_secret

## 🚀 Após Configurar

Após configurar corretamente, a collection do Postman deve funcionar normalmente!


