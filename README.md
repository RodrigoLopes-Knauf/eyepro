# DataGate Remote Live - Guia de Separação (VPS vs Computador Corporativo)

A arquitetura do projeto foi dividida de forma 100% independente e modular:

```
remote_control_prototype/
│
├── server_node/               ➔ 🚀 ENVIAR PARA A SUA VPS (Nuvem / Cloudflare)
│   ├── docker-compose.yml     # Orquestração Docker
│   ├── Dockerfile             # Imagem Node.js 20 Alpine
│   ├── .env.example           # Variáveis da VPS (PORT, WORKER_SECRET)
│   ├── server.js              # Servidor WebSocket Relay & Auth
│   ├── package.json           # Dependências
│   └── public/                # Aplicação Web (Smart TV / Touch / Canvas)
│
└── worker_python/             ➔ 💻 FICA NO COMPUTADOR CORPORATIVO (Windows)
    ├── worker.py              # Captura de tela contínua + mouse/teclado Win32
    ├── requirements.txt       # Dependências Python
    ├── run_worker.bat         # Iniciador com 2 cliques
    └── .env.example           # Configurações do Worker (RELAY_URL, WORKER_SECRET)
```

---

## 🚀 1. Na VPS (Cloudflare + Docker Compose)

Envie **apenas** a pasta `server_node` para a sua VPS:

```bash
# Exemplo via SCP (ou copie via Git/SFTP):
scp -r server_node usuario@sua-vps:/opt/server_node
```

Na sua VPS:
```bash
cd /opt/server_node

# 1. Crie o arquivo .env
cp .env.example .env

# 2. Configure sua chave privada
nano .env
```

Exemplo do `.env` na VPS:
```env
# Porta onde o Node escutará para o Cloudflare
PORT=8080

# Chave Privada dos Workers (Mantenha em segredo!)
WORKER_SECRET=kna_sec_CHAVE_SUPER_SECRETA_AQUI_123456789
```

Suba o contêiner com Docker Compose:
```bash
docker compose up -d --build
```

> **Configuração no Cloudflare**:
> No painel da Cloudflare, aponte seu subdomínio (ex: `remote.seu-dominio.com`) para o IP da sua VPS com Proxy Ativado (nuvem laranja). Como a Cloudflare já cuida de SSL, WAF e DDoS, ela repassará o tráfego WebSocket e HTTP para a porta `8080` da sua VPS de forma segura.

---

## 💻 2. No Computador Corporativo (Worker Python)

Esta pasta fica na máquina que terá a tela transmitida e controlada:

1. No diretório `worker_python`, crie ou edite o arquivo `.env`:
   ```bash
   copy .env.example .env
   ```
2. Defina os parâmetros:
   ```env
   # Apontando para o seu domínio na Cloudflare (usando wss://)
   RELAY_URL=wss://remote.seu-dominio.com

   # Identificador e nome amigável desta máquina
   WORKER_ID=worker-eletrica-01
   WORKER_NAME=Estação de Trabalho - Elétrica

   # Chave Privada (DEVE SER IDÊNTICA à configurada na VPS)
   WORKER_SECRET=kna_sec_CHAVE_SUPER_SECRETA_AQUI_123456789
   ```

3. Dê dois cliques em **`run_worker.bat`**.

O worker conectará na VPS com a chave `x-worker-secret`.

---

## 📺 3. Na Smart TV (Visualização & Controle)

1. Abra o navegador da Smart TV e acesse:
   👉 **`https://remote.seu-dominio.com`**
2. Faça a autenticação corporativa (notificação push do Karl).
3. No modal central, selecione a estação corporativa conectada.
4. Clique em **`⛶ 100% Tela Cheia`**:
   - A barra superior e todos os menus somem.
   - A tela fica **100% imersiva sem nenhuma distração**.
   - Para sair ou abrir o teclado TV: **arraste o dedo de baixo para cima (*swipe up*)** a partir do rodapé da tela para exibir a barra flutuante de saída.
