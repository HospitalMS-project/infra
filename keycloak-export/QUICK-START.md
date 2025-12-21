# ⚡ Quick Start: Criar e Exportar Realm

## 🚀 Comandos Rápidos

### 1. Iniciar Keycloak
```powershell
cd infra
docker-compose up -d keycloak postgres-keycloak
```

Aguarde ~30 segundos e acesse: **http://localhost:8085/admin**

### 2. Login
- **Username:** `admin`
- **Password:** `admin`

### 3. Criar Realm
1. Clique no dropdown do realm "Master" (canto superior esquerdo)
2. Selecione **"Create Realm"** ou **"Add realm"**
3. Nome: `hospital`
4. Clique em **"Create"**

### 4. Criar Client (Opcional mas Recomendado)
1. Menu lateral → **Clients** → **Create client**
2. **Client ID:** `api-gateway`
3. **Client type:** `OpenID Connect`
4. **Next** → Marque **"Client authentication"** → **Next** → **Save**
5. Na aba **Credentials**, copie o **Client Secret** (vai precisar depois)

### 5. Exportar
```powershell
cd infra/keycloak-export
.\export-realm.ps1
```

✅ Pronto! O arquivo `hospital-realm.json` foi salvo!

---

📖 Para instruções detalhadas, veja: **GUIA-CRIAR-REALM.md**



