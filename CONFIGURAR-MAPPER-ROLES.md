# 📋 Como Configurar Mapper de Roles no Client - Passo a Passo

## 🎯 Objetivo

Configurar o client `api-gateway` para incluir as roles do usuário no token JWT.

## 📝 Passo a Passo Detalhado

### Passo 1: Acessar o Client

1. Abra o Keycloak Admin Console: http://localhost:8085/admin
2. Faça login: `admin` / `admin`
3. **Certifique-se de estar no realm "hospital"** (verifique no dropdown no canto superior esquerdo)
4. No menu lateral esquerdo, clique em **"Clients"**
5. Na lista de clients, encontre e **clique em "api-gateway"**

### Passo 2: Encontrar a Aba Mappers

Após clicar no client "api-gateway", você verá várias abas na parte superior:
- **Settings** (Configurações)
- **Credentials** (Credenciais)
- **Roles** (Roles)
- **Mappers** ← **ESTA É A ABA QUE VOCÊ PRECISA!**
- **Advanced** (Avançado)

**Clique na aba "Mappers"**

### Passo 3: Criar o Mapper

Na aba "Mappers":

1. Você verá uma tabela com os mappers existentes (pode estar vazia ou ter alguns já configurados)
2. **Clique no botão "Create mapper"** ou **"Add mapper"** (geralmente no canto superior direito ou acima da tabela)

### Passo 4: Escolher o Tipo de Mapper

Você verá duas opções:
- **By configuration** ← **ESCOLHA ESTA!**
- **From predefined mappers**

**Clique em "By configuration"**

### Passo 5: Preencher os Campos

Agora você verá um formulário. Preencha assim:

#### Campos Principais:

1. **Name** (Nome):
   - Digite: `realm-roles`
   - Este é apenas um nome descritivo

2. **Mapper Type** (Tipo de Mapper):
   - Clique no dropdown
   - Procure e selecione: **"User Realm Role"**
   - (Pode aparecer como "User realm role" ou similar)

#### Campos de Configuração (abaixo):

3. **Token Claim Name** (Nome do Claim no Token):
   - Digite exatamente: `realm_access.roles`
   - Este é o caminho onde as roles aparecerão no token

4. **Add to access token**:
   - **Marque/Ative esta opção** (toggle ou checkbox)
   - Isso faz as roles aparecerem no access token

5. **Add to ID token**:
   - Pode deixar desmarcado (não é necessário para nosso caso)

6. **Multivalued**:
   - **Marque/Ative esta opção**
   - Isso permite que múltiplas roles sejam incluídas

7. **Add to userinfo**:
   - Pode deixar desmarcado

### Passo 6: Salvar

1. Role até o final do formulário
2. Clique no botão **"Save"** (Salvar)

## ✅ Verificar se Funcionou

Após salvar, você deve ver o mapper `realm-roles` na lista de mappers da aba "Mappers".

## 🧪 Testar

1. **Obtenha um novo token** no Postman
2. Cole o token em https://jwt.io
3. No payload, procure por:
   ```json
   "realm_access": {
     "roles": ["ADMIN"]
   }
   ```

Se você ver isso, está funcionando! 🎉

## 🔍 Se Não Estiver Funcionando

### Verifique:

1. ✅ Você está no realm correto? (deve ser "hospital", não "master")
2. ✅ O client "api-gateway" existe?
3. ✅ O mapper foi salvo e aparece na lista?
4. ✅ Você obteve um **novo token** após configurar o mapper?
5. ✅ O usuário tem a role ADMIN atribuída?

### Alternativa: Usar Predefined Mappers

Se não conseguir criar "By configuration", tente:

1. Na aba "Mappers", clique em **"Add mapper"**
2. Escolha **"From predefined mappers"**
3. Procure por: **"realm roles"** ou **"User Realm Role"**
4. Se encontrar, selecione e configure

---

## 📸 Resumo Visual (Passos)

```
Keycloak Admin Console
  └─ Realm: "hospital" ✅
      └─ Clients
          └─ api-gateway (clique aqui)
              └─ Aba "Mappers" (clique aqui)
                  └─ Botão "Create mapper" ou "Add mapper"
                      └─ Escolher "By configuration"
                          └─ Preencher formulário:
                              - Name: realm-roles
                              - Mapper Type: User Realm Role
                              - Token Claim Name: realm_access.roles
                              - Add to access token: ON ✅
                              - Multivalued: ON ✅
                          └─ Salvar
```

---

**Se ainda tiver dúvidas, me diga em qual passo você está travando!**

