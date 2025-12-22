# 📚 Documentação da API - Swagger/OpenAPI

## 🚀 Acesso ao Swagger UI

Após iniciar os serviços, você pode acessar a documentação interativa do Swagger em:

### Serviços Individuais (Local)

1. **Agendamento Service**
   - URL: http://localhost:8082/swagger-ui.html
   - API Docs JSON: http://localhost:8082/api-docs

2. **Clínica Service**
   - URL: http://localhost:8083/swagger-ui.html
   - API Docs JSON: http://localhost:8083/api-docs

3. **Laboratório Service**
   - URL: http://localhost:8084/swagger-ui.html
   - API Docs JSON: http://localhost:8084/api-docs

### Via API Gateway

Quando acessar via API Gateway, as rotas são:

1. **Agendamento Service**
   - URL: http://localhost:8080/swagger-ui.html (não funciona - precisa acessar direto)

⚠️ **Nota:** O API Gateway (Spring Cloud Gateway) não suporta Swagger diretamente. Acesse os serviços individualmente.

## 📋 Funcionalidades do Swagger

### ✅ O que você pode fazer:

1. **Ver todos os endpoints** de cada serviço
2. **Testar as APIs diretamente** pela interface web
3. **Ver exemplos de requisições e respostas**
4. **Entender os parâmetros** necessários para cada endpoint
5. **Ver códigos de resposta** (200, 404, 400, etc.)
6. **Testar autenticação** (quando configurada)

### 🔐 Autenticação no Swagger

Atualmente, os serviços **não têm autenticação configurada no Swagger**. 

Para testar endpoints protegidos:
1. Obtenha o token JWT do Keycloak
2. Use o botão **"Authorize"** no Swagger UI
3. Cole o token no formato: `Bearer <seu-token>`

Ou teste diretamente via curl/Postman com o header:
```
Authorization: Bearer <seu-token>
```

## 📖 Estrutura da Documentação

Cada serviço tem sua própria documentação organizada por tags:

### Agendamento Service
- **Consultas** - Gerenciamento de consultas
- **Pacientes** - CRUD de pacientes
- **Exames** - CRUD de exames (cadastro)

### Clínica Service
- **Clínica** - Atendimentos e consultas clínicas
- **Médicos** - CRUD de médicos

### Laboratório Service
- **Laboratório** - Procedimentos e exames laboratoriais

## 🛠️ Como Testar no Swagger

1. **Acesse a URL do Swagger UI** (ex: http://localhost:8082/swagger-ui.html)

2. **Explore os endpoints:**
   - Clique em uma tag para expandir
   - Clique em um endpoint para ver detalhes
   - Clique em **"Try it out"** para testar

3. **Preencha os parâmetros:**
   - Path parameters (ex: `{id}`)
   - Query parameters (ex: `?cpf=12345678900`)
   - Body (JSON para POST/PUT)

4. **Execute a requisição:**
   - Clique em **"Execute"**
   - Veja a resposta abaixo

## 📝 Exemplo de Uso

### Exemplo 1: Criar uma Consulta

1. Acesse: http://localhost:8082/swagger-ui.html
2. Expanda a tag **"Consultas"**
3. Clique em **POST /api/cadastro/consulta**
4. Clique em **"Try it out"**
5. Preencha o body:
```json
{
  "pacienteId": 1,
  "horario": "2024-12-25T10:00:00",
  "especialidadeMedico": "Cardiologia",
  "observacoes": "Consulta de rotina"
}
```
6. Clique em **"Execute"**
7. Veja a resposta com o ID da consulta criada

### Exemplo 2: Atender uma Consulta

1. Acesse: http://localhost:8083/swagger-ui.html
2. Expanda a tag **"Clínica"**
3. Clique em **POST /clinica/atenderConsulta**
4. Clique em **"Try it out"**
5. Preencha o body:
```json
{
  "consultaId": 1,
  "sintomas": ["dor de cabeça", "febre"],
  "observacoes": "Paciente relatou sintomas há 2 dias",
  "tipoExameSolicitado": "Hemograma completo",
  "prioridadeExame": "ALTA"
}
```
6. Clique em **"Execute"**
7. Veja a resposta com o atendimento criado

## 🔄 Fluxo Completo no Swagger

1. **Agendamento Service:**
   - Criar paciente → POST /api/cadastro/pacientes
   - Criar consulta → POST /api/cadastro/consulta

2. **Clínica Service:**
   - Listar consultas agendadas → GET /clinica/consultas/agendadas
   - Atender consulta → POST /clinica/atenderConsulta

3. **Laboratório Service:**
   - Ver solicitações → GET /api/procedimento?cpf=12345678900
   - Agendar horário → POST /api/marcarHorario/{id}

## 💡 Dicas

- Use o Swagger para **explorar** a API antes de integrar
- **Copie** exemplos de requisições para usar no Postman/curl
- Veja os **schemas** dos DTOs clicando nos modelos
- Teste **validações** (deixe campos vazios para ver erros)

## 🐛 Troubleshooting

### Swagger não abre?
- Verifique se o serviço está rodando
- Verifique a porta correta
- Verifique os logs para erros

### Erro 404 no Swagger?
- Confirme que o caminho está correto: `/swagger-ui.html`
- Verifique se a dependência foi adicionada no pom.xml

### Endpoints não aparecem?
- Verifique se os controllers têm anotações `@RestController`
- Verifique se os métodos têm anotações `@GetMapping`, `@PostMapping`, etc.

## 📚 Mais Informações

- [SpringDoc OpenAPI](https://springdoc.org/)
- [OpenAPI Specification](https://swagger.io/specification/)



