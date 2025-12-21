# Script PowerShell para exportar o realm 'hospital' do Keycloak

$REALM_NAME = "hospital"
$CONTAINER_NAME = "keycloak"
# Diretório atual do script
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$OUTPUT_DIR = $SCRIPT_DIR
$OUTPUT_FILE = Join-Path $OUTPUT_DIR "${REALM_NAME}-realm.json"

Write-Host "🔐 Exportando realm '$REALM_NAME' do Keycloak..." -ForegroundColor Cyan

# Verificar se o container está rodando
$containerRunning = docker ps --filter "name=$CONTAINER_NAME" --format "{{.Names}}"
if (-not $containerRunning -or $containerRunning -ne $CONTAINER_NAME) {
    Write-Host "❌ Erro: Container '$CONTAINER_NAME' não está rodando!" -ForegroundColor Red
    Write-Host "   Execute: docker-compose up -d keycloak" -ForegroundColor Yellow
    exit 1
}

# Criar diretório se não existir
if (-not (Test-Path $OUTPUT_DIR)) {
    New-Item -ItemType Directory -Path $OUTPUT_DIR | Out-Null
}

# Obter token de acesso
Write-Host "📝 Obtendo token de acesso..." -ForegroundColor Cyan
$tokenResponse = Invoke-RestMethod -Uri "http://localhost:8085/realms/master/protocol/openid-connect/token" `
    -Method Post `
    -ContentType "application/x-www-form-urlencoded" `
    -Body @{
        username = "admin"
        password = "admin"
        grant_type = "password"
        client_id = "admin-cli"
    }

if (-not $tokenResponse.access_token) {
    Write-Host "❌ Erro: Falha ao obter token de acesso" -ForegroundColor Red
    Write-Host "   Verifique se as credenciais estão corretas (admin/admin)" -ForegroundColor Yellow
    exit 1
}

$TOKEN = $tokenResponse.access_token

# Exportar realm
Write-Host "📦 Exportando realm..." -ForegroundColor Cyan
try {
    $headers = @{
        "Authorization" = "Bearer $TOKEN"
        "Content-Type" = "application/json"
    }
    
    $realmData = Invoke-RestMethod -Uri "http://localhost:8085/admin/realms/$REALM_NAME" `
        -Method Get `
        -Headers $headers
    
    # Salvar como JSON formatado
    $realmData | ConvertTo-Json -Depth 100 | Out-File -FilePath $OUTPUT_FILE -Encoding UTF8
    
    Write-Host "✅ Realm exportado com sucesso!" -ForegroundColor Green
    Write-Host "   Arquivo: $OUTPUT_FILE" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 Dica: Para importar automaticamente na próxima inicialização," -ForegroundColor Yellow
    Write-Host "   descomente a linha KC_IMPORT no docker-compose.yml" -ForegroundColor Yellow
}
catch {
    Write-Host "❌ Erro: Falha ao exportar realm" -ForegroundColor Red
    Write-Host "   Verifique se o realm '$REALM_NAME' existe no Keycloak" -ForegroundColor Yellow
    Write-Host "   Erro: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

