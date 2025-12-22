# 📬 Guia de Uso - Postman Collection

Esta coleção do Postman contém todos os testes para o Sistema Hospitalar.

## 📋 Pré-requisitos

1. **Postman instalado** (versão 9 ou superior)
2. **Todos os serviços rodando** via `docker-compose up --build` na pasta `infra/`
3. **Keycloak configurado** com o realm `hospital` e usuário `admin` criado

## 🚀 Como Importar

### Passo 1: Importar a Collection

1. Abra o Postman
2. Clique em **Import** (canto superior esquerdo)
3. Selecione o arquivo `Hospital-Sistema-API.postman_collection.json`
4. Clique em **Import**

### Passo 2: Importar o Environment

1. No Postman, clique em **Import** novamente
2. Selecione o arquivo `Hospital-Sistema-API.postman_environment.json`
3. Clique em **Import**
4. No canto superior direito, selecione o environment **"Sistema Hospitalar - Local"**

## 🔐 Autenticação

### Primeiro: Obter Token

1. Na pasta **"1. Autenticação"**, execute a requisição **"Obter Token Keycloak"**
2. O token será **automaticamente salvo** na variável `access_token`
3. Todas as outras requisições usarão esse token automaticamente

**Credenciais padrão:**
- Username: `admin`
- Password: `admin`
- Client ID: `api-gateway`

### Se o token expirar

Basta executar novamente a requisição **"Obter Token Keycloak"** que o token será atualizado automaticamente.

## 📁 Estrutura da Collection

### 1. Autenticação
- **Obter Token Keycloak**: Obtém e salva automaticamente o token de acesso

### 2. Agendamento - Pacientes
- Criar, listar, buscar, atualizar e deletar pacientes
- **Require role**: ADMIN

### 3. Agendamento - Consultas
- Criar consultas (envia evento via Kafka para Clínica Service)
- Listar e buscar consultas
- **Require role**: ADMIN (criar), RECEPCIONISTA ou ADMIN (listar/buscar)

### 4. Agendamento - Exames Simples
- CRUD completo de exames simples (raio-X, ultrassom, etc.)
- **Require role**: ADMIN

### 5. Clínica - Médicos
- CRUD completo de médicos
- **Require role**: ADMIN

### 6. Clínica - Consultas
- Listar consultas agendadas (com ou sem filtro por especialidade)
- Buscar consultas por ID ou CPF
- **Require role**: MEDICO ou ADMIN

### 7. Clínica - Atender Consulta
- ⭐ **ENDPOINT PRINCIPAL DO FLUXO** ⭐
- Atender consulta sem exame complexo
- Atender consulta com exame complexo (prioridade ALTA ou EMERGENCIAL)
- Quando há exame complexo, envia evento via Kafka para Laboratório Service
- **Require role**: MEDICO ou ADMIN

### 8. Laboratório - Solicitações
- Criar solicitações de procedimento manualmente
- Listar por CPF ou buscar por ID
- **Require role**: LABORATORIO ou ADMIN

### 9. Laboratório - Agendar Horário
- Agendar horário para procedimento
- Agendar horário EMERGENCIAL (testa regra de cancelamento automático)
- Alterar horário de procedimento agendado
- **Require role**: RECEPCIONISTA ou ADMIN

### 10. Health Checks
- Verificar saúde de todos os serviços
- **Público** (não requer autenticação)

### 11. Fluxo Completo - Teste End-to-End
- Sequência completa de testes para validar todo o sistema
- Inclui: Criar paciente → Criar consulta → Verificar Kafka → Atender consulta → Verificar Kafka → Agendar exame

## 🎯 Como Testar o Fluxo Completo

1. **Execute primeiro**: "1. Autenticação" → "Obter Token Keycloak"
2. **Execute na ordem** as requisições da pasta "11. Fluxo Completo - Teste End-to-End"
3. **Aguarde alguns segundos** entre os passos 2-3 e 4-5 para que os eventos do Kafka sejam processados

## 📝 Valores Válidos

### Sexo (Paciente)
- `M` - Masculino
- `F` - Feminino

### Prioridade (Exames/Procedimentos)
- `BAIXA`
- `PADRAO`
- `ALTA`
- `EMERGENCIAL`

### Tipo (Solicitação Laboratório)
- `EXAME`
- `PROCEDIMENTO`

## ⚠️ Importante

### IDs nos Exemplos

Os IDs usados nos exemplos (ex: `/pacientes/1`, `/consultas/1`) são apenas exemplos. Você deve:

1. **Criar primeiro** os recursos (paciente, consulta, etc.)
2. **Copiar o ID retornado** na resposta
3. **Usar esse ID** nas requisições subsequentes

### Regra EMERGENCIAL no Laboratório

Quando você agenda um procedimento com prioridade **EMERGENCIAL** em um horário que já tem outro procedimento:

1. O procedimento anterior é **CANCELADO**
2. O procedimento anterior é **REAGENDADO automaticamente** para +30 minutos
3. O procedimento EMERGENCIAL é **MARCADO** no horário desejado

## 🔧 Variáveis de Ambiente

A collection já vem com as variáveis configuradas:

- `api_gateway_url`: `http://localhost:8080`
- `keycloak_url`: `http://localhost:8085`
- `agendamento_service_url`: `http://localhost:8082`
- `clinica_service_url`: `http://localhost:8083`
- `laboratorio_service_url`: `http://localhost:8084`
- `access_token`: (preenchido automaticamente ao obter token)

Se você estiver usando portas diferentes, edite o Environment no Postman.

## 🐛 Troubleshooting

### Erro 401 Unauthorized
- Execute novamente "Obter Token Keycloak"
- Verifique se o token não expirou (tokens expiram em 5 minutos por padrão)

### Erro 403 Forbidden
- Verifique se o usuário tem a role necessária no Keycloak
- As roles válidas são: `ADMIN`, `MEDICO`, `RECEPCIONISTA`, `LABORATORIO`, `PACIENTE`

### Erro de conexão
- Verifique se todos os containers estão rodando: `docker ps`
- Verifique se as portas estão corretas nas variáveis de ambiente

### Kafka não está funcionando
- Verifique os logs do Kafka: `docker logs kafka`
- Aguarde alguns segundos após criar consultas/atender consultas para os eventos serem processados

## 📚 Documentação Adicional

- Veja `TESTES-COMPLETOS.md` para mais exemplos e explicações detalhadas
- Veja `README.md` para informações gerais sobre o projeto

---

**Bons testes! 🚀**


