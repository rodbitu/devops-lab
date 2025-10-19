# 🚀 Projeto Prático DevOps Completo (Free Tier)

**Stack:** Docker · AWS (ECR, Lambda, API Gateway, S3) · Terraform · GitHub Actions (OIDC)

---

## 🧠 Visão Geral

Este projeto é um **lab completo de DevOps** mostrando o ciclo **CI/CD ponta a ponta**.

Você irá:

1. Construir uma **API containerizada em Python (Flask)** com Docker
2. Provisionar a infraestrutura AWS com **Terraform**
3. Configurar um **pipeline CI/CD com GitHub Actions + OIDC** (sem secrets)
4. Servir uma **página estática no S3** que consome a API do Lambda

---

## ⚙️ Arquitetura

```
GitHub → GitHub Actions (OIDC)
       ↓
Terraform → AWS ECR → Lambda (Container)
                       ↓
                   API Gateway
                       ↓
                   S3 Website
```

---

## 📁 Estrutura do Projeto

```
devops-lab/
├─ app/                 # Código da API Flask + Dockerfile
├─ web/                 # Página estática HTML
├─ terraform/           # Infraestrutura como código
└─ .github/workflows/   # Pipelines CI/CD
```

---

## 🐍 API (app.py)

```python
from flask import Flask, jsonify
app = Flask(__name__)

@app.get("/hello")
def hello():
    return jsonify(message="Hello from Lambda container! 🤖")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
```

Build local:

```bash
docker build -t hello-lambda ./app
docker run -p 8080:8080 hello-lambda
```

→ http://localhost:8080/hello

---

## ☁️ Infraestrutura (Terraform)

O Terraform cria:

- **ECR:** Repositório de imagens Docker
- **Lambda:** Executa o container da API
- **API Gateway:** Expõe a rota `/hello`
- **S3 Website:** Página estática que consome a API
- **IAM Role:** Autenticação via OIDC com GitHub Actions

---

## 🔐 Autenticação OIDC (GitHub Actions)

Sem precisar armazenar chaves AWS!  
O Terraform cria o provider e role OIDC.  
Basta adicionar no GitHub Secrets:

| Secret            | Valor                               |
| ----------------- | ----------------------------------- |
| `AWS_GA_ROLE_ARN` | (output `ga_role_arn` do Terraform) |
| `ECR_REPO_URL`    | (output `ecr_repo_url`)             |

---

## 🤖 Pipelines GitHub Actions

### `build-and-push.yml`

- Faz build da imagem Docker
- Envia para o Amazon ECR

### `deploy-infra.yml`

- Aplica o Terraform
- Substitui `%%API_URL%%` no HTML
- Faz upload do `index.html` para o S3

---

## 🧪 Execução

1️⃣ Crie os recursos base:

```bash
cd terraform
terraform init
terraform apply
```

2️⃣ Adicione os _secrets_ no repositório GitHub.

3️⃣ Faça um `git push main`  
→ A imagem é buildada e publicada no ECR  
→ A infra é atualizada e o site é publicado

---

## 🌐 Acesso

- **API:** `https://xxxx.execute-api.us-east-1.amazonaws.com/hello`
- **Site:** `http://<bucket>.s3-website-us-east-1.amazonaws.com`

---

## 🧹 Limpeza (para evitar custos)

```bash
cd terraform
terraform destroy
```
