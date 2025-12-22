# 🔧 Configurar Mapper - Alternativa Simples

## 🎯 Duas Formas de Fazer Isso

### Forma 1: No Client "api-gateway" (Direto)

1. **Keycloak Admin Console** → Realm "hospital" → **Clients** → **api-gateway**
2. Você verá várias abas no topo. Procure pela aba **"Mappers"** ou **"Mapeadores"**
3. Se não vir a aba "Mappers", pode estar em **"Client scopes"** → **"Default client scopes"**

### Forma 2: Via Client Scopes (MAIS FÁCIL - Recomendado) ⭐

O Keycloak já vem com um scope chamado "roles" que já tem o mapper configurado! Você só precisa garantir que o client está usando esse scope.

#### Passo a Passo:

1. **Keycloak Admin Console** → Realm "hospital"
2. Menu lateral → **Client scopes**
3. Procure pelo scope chamado **"roles"** na lista
4. Clique nele
5. Vá na aba **"Mappers"**
6. Você deve ver um mapper chamado **"realm roles"**
7. Clique nele para ver as configurações
8. Verifique se está assim:
   - **Token Claim Name:** `realm_access.roles`
   - **Add to access token:** `ON` ✅

9. **Agora, garantir que o client usa esse scope:**
   - Volte para **Clients** → **api-gateway**
   - Vá na aba **"Client scopes"**
   - Na seção **"Default client scopes"**, verifique se **"roles"** está listado
   - Se não estiver, clique em **"Add client scope"**
   - Selecione **"roles"** e marque como **"Default"**
   - Clique em **"Add"**

## ✅ Verificar se Está Funcionando

1. Obtenha um novo token
2. Cole em https://jwt.io
3. Procure por `realm_access.roles` no payload

## 🔍 Se Ainda Não Encontrar

Me diga:
1. Quais abas você vê quando clica no client "api-gateway"?
2. Você consegue ver a aba "Mappers" ou "Client scopes"?

Assim posso te ajudar de forma mais específica!

