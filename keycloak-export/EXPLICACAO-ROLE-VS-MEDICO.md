# 🔍 Explicação: Role MEDICO vs Médico do Banco de Dados

## 📚 Conceitos Diferentes

### 1. **Role MEDICO (Keycloak)** 🔐
- **O que é:** Permissão/autorização de **acesso à API**
- **Onde está:** No Keycloak (sistema de autenticação)
- **Função:** Controla **QUEM pode acessar** os endpoints
- **Exemplo:** "Este usuário tem permissão para chamar `/clinica/atenderConsulta`"

### 2. **Médico (Banco de Dados)** 👨‍⚕️
- **O que é:** Entidade de domínio do **negócio**
- **Onde está:** Na tabela `medicos` do banco de dados
- **Função:** Representa **QUEM vai atender** a consulta
- **Exemplo:** "Dr. João Silva (CRM: 12345) atendeu a consulta ID 10"

## 🔄 Situação Atual do Código

Atualmente, **NÃO HÁ RELAÇÃO** entre eles:

1. ✅ Usuário com role `MEDICO` acessa o endpoint
2. ✅ Sistema busca automaticamente um médico aleatório do banco pela especialidade
3. ❌ **Não verifica se o usuário autenticado É o médico do banco**

```java
// Código atual (ClinicaService.java linha 51)
Medico medico = medicoService.buscarMedicoDisponivel(
    consulta.getEspecialidadeMedico()); // Busca ALEATÓRIO
```

## 🤔 Quando Fazer a Ligação?

### **Cenário 1: Sistema Automático (Atual)** 🤖
- Sistema escolhe automaticamente qual médico atende
- Role MEDICO só controla **acesso ao endpoint**
- Útil para: sistemas automatizados, distribuição automática

### **Cenário 2: Médico Específico Atende** 👤
- Usuário autenticado É o médico específico que vai atender
- Precisa ligar: usuário do Keycloak ↔ médico do banco
- Útil para: médico real fazendo login e atendendo

## 🔗 Como Ligar (Se Quiser)

Se você quiser que **o usuário autenticado seja o médico específico**, precisa:

1. **Armazenar identificador do médico no token JWT** (ex: CPF ou CRM)
2. **Buscar médico do banco pelo identificador** (não aleatório)
3. **Validar que o médico existe e tem a especialidade correta**

### Exemplo de Implementação:

```java
// No SecurityConfig ou Service
String cpfUsuario = jwt.getClaimAsString("cpf"); // ou "crm"
Medico medico = medicoRepository.findByCpf(cpfUsuario)
    .orElseThrow(() -> new ResponseStatusException(
        HttpStatus.NOT_FOUND, "Médico não encontrado no sistema"));

// Verificar se tem a especialidade correta
if (!medico.getEspecialidade().equals(consulta.getEspecialidadeMedico())) {
    throw new ResponseStatusException(
        HttpStatus.FORBIDDEN, "Médico não tem a especialidade necessária");
}
```

## ✅ Recomendação

Para seu caso (paciente informa sintomas, sistema escolhe médico):

**MANTER COMO ESTÁ** - Sistema automático é adequado porque:
- ✅ Não precisa médico fazer login
- ✅ Sistema distribui consultas automaticamente
- ✅ Role MEDICO só controla quem pode acessar a API (ex: recepcionista não pode atender)

## 📋 Resumo

| Aspecto | Role MEDICO | Médico BD |
|---------|-------------|-----------|
| **Onde** | Keycloak | Banco MySQL |
| **Função** | Quem pode acessar | Quem vai atender |
| **Exemplo** | "usuário123 tem permissão" | "Dr. João atende consulta 10" |
| **Relacionado?** | ❌ Atualmente NÃO | |

**Conclusão:** São coisas diferentes! Role = permissão de acesso, Médico = entidade de negócio.



