# 🔐 Configuração de Roles no Keycloak

## 📋 Roles Necessárias

O sistema usa as seguintes roles para controlar acesso aos endpoints:

1. **ADMIN** - Acesso total ao sistema
2. **MEDICO** - Pode atender consultas e ver informações clínicas
3. **RECEPCIONISTA** - Pode criar agendamentos e gerenciar consultas
4. **LABORATORIO** - Pode gerenciar procedimentos laboratoriais
5. **PACIENTE** - Pode ver suas próprias informações

## 🚀 Como Configurar no Keycloak

### Passo 1: Criar as Roles

1. Acesse o Keycloak Admin Console: http://localhost:8085/admin
2. Faça login: `admin` / `admin`
3. Selecione o realm **"hospital"**
4. No menu lateral, vá em **Realm roles**
5. Clique em **"Create role"** e crie cada uma das roles:
   - `ADMIN`
   - `MEDICO`
   - `RECEPCIONISTA`
   - `LABORATORIO`
   - `PACIENTE`

### Passo 2: Atribuir Roles aos Usuários

1. No menu lateral, vá em **Users**
2. Selecione um usuário ou crie um novo
3. Vá na aba **Role mapping**
4. Clique em **"Assign role"**
5. Selecione as roles que deseja atribuir ao usuário
6. Clique em **"Assign"**

### Passo 3: Configurar o Client para Incluir Roles no Token

1. No menu lateral, vá em **Clients**
2. Selecione o client **"api-gateway"** (ou crie se não existir)
3. Vá na aba **Mappers**
4. Clique em **"Create mapper"** ou **"Add mapper"**
5. Selecione **"By configuration"**
6. Configure o mapper:

**Configuração:**
- **Name:** `realm-roles`
- **Mapper Type:** `User Realm Role`
- **Token Claim Name:** `realm_access.roles`
- **Add to access token:** `ON` ✅
- **Add to ID token:** `ON` ✅ (opcional)
- **Multivalued:** `ON` ✅
- **Add to userinfo:** `ON` ✅ (opcional)

7. Clique em **"Save"**

### Passo 4: Verificar se as Roles Estão no Token

Para testar se as roles estão sendo incluídas no token:

1. Vá em **Clients** → **api-gateway** → **Settings**
2. Configure:
   - **Access Token Lifespan:** (pode deixar padrão)
   - **Client authentication:** `ON`
3. Salve
4. Use a aba **Credentials** para obter o Client Secret
5. Teste o token usando curl ou Postman:

```bash
# Obter token
curl -X POST 'http://localhost:8085/realms/hospital/protocol/openid-connect/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'username=SEU_USUARIO' \
  -d 'password=SUA_SENHA' \
  -d 'grant_type=password' \
  -d 'client_id=api-gateway' \
  -d 'client_secret=SEU_CLIENT_SECRET'

# Decodificar o JWT (pode usar jwt.io ou jq)
# Você deve ver no payload do token o campo:
# "realm_access": {
#   "roles": ["ADMIN", "MEDICO", ...]
# }
```

## 📊 Mapeamento de Endpoints por Role

### 🔴 ADMIN
Acesso total - pode acessar todos os endpoints:
- `/api/medicos/**` - Gerenciar médicos
- `/api/exames/**` - Gerenciar exames
- `/api/pacientes/**` - Gerenciar pacientes
- `/api/cadastro/**` - Cadastros administrativos
- Todos os outros endpoints

### 🟢 MEDICO
- `/clinica/atenderConsulta` - Atender consultas
- `/clinica/consultas/**` - Ver consultas
- `/clinica/consultas/cpf/**` - Ver consultas por CPF

### 🟡 RECEPCIONISTA
- `/api/consultas/**` - Gerenciar consultas
- `/api/marcarHorario/**` - Agendar horários
- `/clinica/consultas/cpf/**` - Ver consultas por CPF

### 🔵 LABORATORIO
- `/api/procedimento/**` - Gerenciar procedimentos laboratoriais
- `/api/marcarHorario/**` - Agendar horários de exames

### 🟣 PACIENTE
- `/clinica/consultas/cpf/{cpf}` - Ver suas próprias consultas

## 🧪 Testando as Roles

### Exemplo: Testar acesso como MÉDICO

```bash
# 1. Obter token com usuário que tem role MEDICO
TOKEN=$(curl -s -X POST 'http://localhost:8085/realms/hospital/protocol/openid-connect/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'username=medico@hospital.com' \
  -d 'password=senha123' \
  -d 'grant_type=password' \
  -d 'client_id=api-gateway' \
  -d 'client_secret=seu-secret' | jq -r '.access_token')

# 2. Testar acesso a endpoint de médico (deve funcionar)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/clinica/consultas/agendadas

# 3. Testar acesso a endpoint de admin (deve retornar 403 Forbidden)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/medicos
```

## ⚠️ Importante

1. **Sempre use letras maiúsculas** nas roles no Keycloak (ADMIN, MEDICO, etc.)
2. O código adiciona automaticamente o prefixo `ROLE_` e converte para maiúsculas
3. Um usuário pode ter múltiplas roles
4. Se um usuário não tiver a role necessária, receberá **403 Forbidden**
5. Se não tiver token válido, receberá **401 Unauthorized**

## 🔄 Atualizar Roles em Usuários Existentes

1. **Users** → Selecione o usuário → **Role mapping**
2. Para adicionar: Clique em **"Assign role"** → Selecione → **"Assign"**
3. Para remover: Clique na role → **"Unassign"**

## 💡 Dica: Criar Usuários de Teste

Crie usuários de teste para cada role:

1. **admin-test** → Role: ADMIN
2. **medico-test** → Role: MEDICO
3. **recepcionista-test** → Role: RECEPCIONISTA
4. **laboratorio-test** → Role: LABORATORIO
5. **paciente-test** → Role: PACIENTE

Isso facilita os testes durante o desenvolvimento!



