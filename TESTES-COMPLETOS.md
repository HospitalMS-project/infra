# 🧪 Testes Completos - Sistema Hospitalar

Este arquivo contém todas as requisições HTTP prontas para testar o sistema completo.

## 📋 Índice de Testes

1. [Autenticação](#1-autenticação)
2. [Pacientes](#2-pacientes)
3. [Consultas](#3-consultas)
4. [Exames Simples](#4-exames-simples)
5. [Médicos](#5-médicos)
6. [Atender Consulta](#6-atender-consulta)
7. [Laboratório](#7-laboratório)
8. [Fluxo Completo](#8-fluxo-completo)

---

## 1. Autenticação

### Obter Token do Keycloak

```bash
curl -X POST 'http://localhost:8085/realms/hospital/protocol/openid-connect/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'username=admin' \
  -d 'password=admin' \
  -d 'grant_type=password' \
  -d 'client_id=api-gateway' \
  -d 'client_secret=seu-client-secret'
```

**Resposta:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIi...",
  "expires_in": 300,
  "refresh_expires_in": 1800,
  "token_type": "Bearer"
}
```

**Copie o `access_token` e use nas requisições abaixo como:**
```bash
Authorization: Bearer <seu-token>
```

---

## 2. Pacientes

### Criar Paciente

```bash
curl -X POST 'http://localhost:8080/api/cadastro/pacientes' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "nome": "João Silva",
    "cpf": "12345678900",
    "idade": 35,
    "sexo": "MASCULINO",
    "telefone": "(11) 98765-4321",
    "endereco": "Rua das Flores, 123"
  }'
```

### Listar Todos os Pacientes

```bash
curl -X GET 'http://localhost:8080/api/pacientes' \
  -H 'Authorization: Bearer <token>'
```

### Buscar Paciente por ID

```bash
curl -X GET 'http://localhost:8080/api/pacientes/1' \
  -H 'Authorization: Bearer <token>'
```

### Atualizar Paciente

```bash
curl -X PUT 'http://localhost:8080/api/pacientes/1' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "nome": "João Silva Santos",
    "cpf": "12345678900",
    "idade": 36,
    "sexo": "MASCULINO",
    "telefone": "(11) 98765-4321",
    "endereco": "Rua das Flores, 456"
  }'
```

---

## 3. Consultas

### Criar Consulta

```bash
curl -X POST 'http://localhost:8080/api/cadastro/consulta' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "pacienteId": 1,
    "horario": "2024-12-25T10:00:00",
    "especialidadeMedico": "Cardiologia",
    "observacoes": "Consulta de rotina - check-up anual"
  }'
```

**Importante:** Esta consulta será automaticamente enviada para o Clínica Service via Kafka!

### Listar Todas as Consultas

```bash
curl -X GET 'http://localhost:8080/api/consultas' \
  -H 'Authorization: Bearer <token>'
```

### Buscar Consulta por ID

```bash
curl -X GET 'http://localhost:8080/api/consultas/1' \
  -H 'Authorization: Bearer <token>'
```

### Listar Consultas por Paciente

```bash
curl -X GET 'http://localhost:8080/api/consultas/paciente/1' \
  -H 'Authorization: Bearer <token>'
```

---

## 4. Exames Simples

### Criar Exame Simples

```bash
curl -X POST 'http://localhost:8080/api/cadastro/exames' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "pacienteId": 1,
    "horario": "2024-12-26T14:00:00",
    "tipoExame": "Raio-X de tórax",
    "observacoes": "Exame de rotina"
  }'
```

### Listar Todos os Exames

```bash
curl -X GET 'http://localhost:8080/api/exames' \
  -H 'Authorization: Bearer <token>'
```

---

## 5. Médicos

### Criar Médico

```bash
curl -X POST 'http://localhost:8080/api/medicos' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "nome": "Dr. Carlos Mendes",
    "cpf": "98765432100",
    "especialidade": "Cardiologia",
    "crm": "CRM12345",
    "telefone": "(11) 91234-5678"
  }'
```

### Listar Todos os Médicos

```bash
curl -X GET 'http://localhost:8080/api/medicos' \
  -H 'Authorization: Bearer <token>'
```

---

## 6. Atender Consulta

### ⭐ ENDPOINT PRINCIPAL DO FLUXO ⭐

### Atender Consulta SEM Exame Complexo

```bash
curl -X POST 'http://localhost:8080/clinica/atenderConsulta' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "consultaId": 1,
    "sintomas": ["dor de cabeça", "febre leve"],
    "observacoes": "Paciente relatou sintomas há 2 dias. Estado geral bom.",
    "tipoExameSolicitado": null,
    "prioridadeExame": null
  }'
```

### Atender Consulta COM Exame Complexo (Prioridade ALTA)

```bash
curl -X POST 'http://localhost:8080/clinica/atenderConsulta' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "consultaId": 1,
    "sintomas": ["dor no peito", "falta de ar", "tontura"],
    "observacoes": "Paciente com sintomas cardíacos. Necessário exame urgente.",
    "tipoExameSolicitado": "Hemograma completo",
    "prioridadeExame": "ALTA"
  }'
```

**Importante:** Este exame será automaticamente enviado para o Laboratório Service via Kafka!

### Atender Consulta COM Exame Complexo EMERGENCIAL

```bash
curl -X POST 'http://localhost:8080/clinica/atenderConsulta' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "consultaId": 1,
    "sintomas": ["dor intensa no peito", "suor frio", "náusea"],
    "observacoes": "Sintomas de possível infarto. EXAME EMERGENCIAL NECESSÁRIO!",
    "tipoExameSolicitado": "Eletrocardiograma + Enzimas cardíacas",
    "prioridadeExame": "EMERGENCIAL"
  }'
```

### Ver Consultas Agendadas

```bash
curl -X GET 'http://localhost:8080/clinica/consultas/agendadas?especialidade=Cardiologia' \
  -H 'Authorization: Bearer <token>'
```

---

## 7. Laboratório

### Criar Solicitação Manualmente

```bash
curl -X POST 'http://localhost:8080/api/procedimento/marcar' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "cpf": "12345678900",
    "procedimento": "Hemograma completo",
    "tipo": "EXAME",
    "prioridade": "PADRAO"
  }'
```

### Listar Solicitações por CPF

```bash
curl -X GET 'http://localhost:8080/api/procedimento?cpf=12345678900' \
  -H 'Authorization: Bearer <token>'
```

### Agendar Horário (Prioridade Normal)

```bash
curl -X POST 'http://localhost:8080/api/marcarHorario/1' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "horario": "2024-12-26T09:00:00"
  }'
```

### ⚠️ Agendar Horário EMERGENCIAL (Testa Regra de Cancelamento)

```bash
curl -X POST 'http://localhost:8080/api/marcarHorario/2' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "horario": "2024-12-26T09:00:00"
  }'
```

**O que acontece:**
- Se já existe um exame neste horário, ele é **cancelado**
- O exame cancelado é **reagendado automaticamente** para +30 minutos
- O exame emergencial é **marcado no horário desejado**

### Alterar Horário

```bash
curl -X PUT 'http://localhost:8080/api/marcarHorario/1/alterar' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "horario": "2024-12-26T10:30:00"
  }'
```

---

## 8. Fluxo Completo de Teste

Execute na ordem para testar todo o sistema:

### Passo 1: Criar Paciente

```bash
curl -X POST 'http://localhost:8080/api/cadastro/pacientes' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "nome": "Maria Santos",
    "cpf": "11122233344",
    "idade": 45,
    "sexo": "FEMININO",
    "telefone": "(11) 99999-8888",
    "endereco": "Av. Principal, 789"
  }'
```

**Anote o `id` retornado (ex: `id: 2`)**

### Passo 2: Criar Consulta

```bash
curl -X POST 'http://localhost:8080/api/cadastro/consulta' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "pacienteId": 2,
    "horario": "2024-12-27T14:00:00",
    "especialidadeMedico": "Cardiologia",
    "observacoes": "Primeira consulta"
  }'
```

**Anote o `id` retornado (ex: `id: 2`)**

### Passo 3: Verificar Consulta no Clínica Service (via Kafka)

Aguarde alguns segundos e verifique:

```bash
curl -X GET 'http://localhost:8080/clinica/consultas/agendadas?especialidade=Cardiologia' \
  -H 'Authorization: Bearer <token>'
```

A consulta deve aparecer aqui automaticamente via Kafka!

### Passo 4: Atender Consulta (com exame complexo)

```bash
curl -X POST 'http://localhost:8080/clinica/atenderConsulta' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "consultaId": 2,
    "sintomas": ["dor no peito", "palpitação"],
    "observacoes": "Paciente com sintomas cardíacos",
    "tipoExameSolicitado": "Eletrocardiograma",
    "prioridadeExame": "EMERGENCIAL"
  }'
```

### Passo 5: Verificar Solicitação no Laboratório (via Kafka)

Aguarde alguns segundos e verifique:

```bash
curl -X GET 'http://localhost:8080/api/procedimento?cpf=11122233344' \
  -H 'Authorization: Bearer <token>'
```

A solicitação deve aparecer aqui automaticamente via Kafka!

**Anote o `id` da solicitação (ex: `id: 3`)**

### Passo 6: Agendar Horário do Exame

```bash
curl -X POST 'http://localhost:8080/api/marcarHorario/3' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "horario": "2024-12-27T15:00:00"
  }'
```

### Passo 7: Testar Regra EMERGENCIAL

Crie outro exame no mesmo horário:

```bash
curl -X POST 'http://localhost:8080/api/procedimento/marcar' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "cpf": "11122233344",
    "procedimento": "Exame de sangue",
    "tipo": "EXAME",
    "prioridade": "PADRAO"
  }'
```

Agende este exame:

```bash
curl -X POST 'http://localhost:8080/api/marcarHorario/4' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "horario": "2024-12-27T15:00:00"
  }'
```

Agora agende o exame EMERGENCIAL no mesmo horário:

```bash
curl -X POST 'http://localhost:8080/api/marcarHorario/3' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <token>' \
  -d '{
    "horario": "2024-12-27T15:00:00"
  }'
```

**Resultado esperado:**
- Exame ID 4 é **cancelado** e **reagendado** para 15:30
- Exame ID 3 (emergencial) é **marcado** para 15:00

Verifique:

```bash
curl -X GET 'http://localhost:8080/api/procedimento/4' \
  -H 'Authorization: Bearer <token>'
```

O exame deve estar com status `REAGENDADA` e horário `15:30:00`!

---

## 📊 Resumo dos Endpoints

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/cadastro/pacientes` | Criar paciente |
| GET | `/api/pacientes` | Listar pacientes |
| POST | `/api/cadastro/consulta` | Criar consulta |
| GET | `/api/consultas` | Listar consultas |
| POST | `/clinica/atenderConsulta` | Atender consulta |
| GET | `/clinica/consultas/agendadas` | Ver consultas agendadas |
| POST | `/api/procedimento/marcar` | Criar solicitação |
| POST | `/api/marcarHorario/{id}` | Agendar horário |
| GET | `/api/procedimento?cpf=xxx` | Listar por CPF |

---

## ✅ Checklist de Testes

- [ ] Criar paciente
- [ ] Criar consulta
- [ ] Verificar consulta no Clínica Service (Kafka)
- [ ] Atender consulta sem exame
- [ ] Atender consulta com exame complexo
- [ ] Verificar solicitação no Laboratório (Kafka)
- [ ] Agendar horário normal
- [ ] Agendar horário EMERGENCIAL com conflito
- [ ] Verificar cancelamento e reagendamento automático

---

**🎉 Pronto! Agora você pode testar todo o sistema!**



