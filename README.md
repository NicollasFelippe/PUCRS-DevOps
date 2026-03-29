# DevOps na Prática — Nicollas Santos

Projeto desenvolvido para a disciplina **DevOps na Prática** da PUCRS. O objetivo é demonstrar práticas reais de DevOps por meio de um site exemplo de currículo pessoal com pipeline de CI/CD completo, containerização com Docker e infraestrutura provisionada na AWS via CloudFormation.

---

## O que o projeto faz

Publica automaticamente um site estático, que é um exemplo de currículo pessoal em uma instância EC2 na AWS, disparado por um push na branch `Fase-2-DevOps`. Todo o processo com validação de código, build da imagem Docker, push para o registry e provisionamento da infraestrutura é executado sem intervenção manual.

---

## Estrutura do projeto

```
.
├── .github/
│   └── workflows/
│       └── main.yaml       # Pipeline CI/CD (GitHub Actions)
├── src/
│   ├── index.html          # Página do currículo
│   ├── styles.css          # Estilo visual do site
│   └── images/             # Foto de perfil usada no currículo
├── Dockerfile              # Define a imagem Docker com Nginx
├── template.yaml           # Infraestrutura AWS via CloudFormation
└── .gitignore
```

---

## Arquivos principais

### `Dockerfile`
Cria uma imagem Docker leve usando **Nginx Alpine**. Copia os arquivos da pasta `src/` para o diretório padrão do Nginx e expõe a porta 80 para tráfego HTTP.

### `template.yaml` — CloudFormation (IaC)
Define toda a infraestrutura na AWS:
- **Security Group:** libera a porta 80 para acesso público.
- **EC2 (t2.micro):** sobe uma instância com Amazon Linux 2023, instala o Docker automaticamente via *user data* e executa o container com o site na porta 80.
- **Output:** retorna o DNS público da instância para acesso direto ao site.

### `.github/workflows/main.yaml` — Pipeline CI/CD
Disparado em push para a branch `Fase-2-DevOps`. Os jobs executam em sequência, funcionando como **quality gates**:

| Job | O que faz |
|---|---|
| **Build** | Checkout do código e validação inicial |
| **Validating-HTML** | Valida o HTML com HTMLHint |
| **Validating-Prettier** | Verifica formatação do HTML e CSS com Prettier |
| **Validating-Links** | Checa links quebrados com Lychee |
| **Deploy** | Faz login no Docker Hub, builda e publica a imagem, depois executa o deploy via CloudFormation na AWS |

O job de deploy só executa se **todos** os jobs de validação passarem.

### `src/index.html`
Página HTML5 com a simulação de um currículo com resumo profissional, experiências, formação acadêmica, habilidades técnicas com barras de progresso e informações de contato.

### `src/styles.css`
Estilização completa do site: layout em grid responsivo, paleta em gradiente roxo/azul, animações de hover nos ícones de contato e adaptação para dispositivos móveis (breakpoint em 768px).

---

## Tecnologias utilizadas

| Categoria | Tecnologia |
|---|---|
| Frontend | HTML5, CSS3 |
| Containerização | Docker, Nginx Alpine |
| CI/CD | GitHub Actions |
| Registry | Docker Hub |
| Infraestrutura | AWS EC2, AWS CloudFormation |
| Qualidade de código | HTMLHint, Prettier, Lychee |

---

## Como funciona o fluxo completo

```
Push na branch Fase-2-DevOps
        │
        ▼
   [Build] Checkout do código
        │
        ├──▶ [Validating-HTML]     Verifica erros no HTML
        ├──▶ [Validating-Prettier] Verifica formatação
        └──▶ [Validating-Links]    Verifica links
                    │
                    ▼ (todos passaram)
              [Deploy]
                ├── Build e push da imagem → Docker Hub
                └── Deploy CloudFormation → AWS EC2 rodando o container
```

---

## Secrets necessários

As credenciais são armazenadas como **GitHub Secrets** e nunca ficam expostas no código:

| Secret | Uso |
|---|---|
| `AWS_ACCESS_KEY_ID` | Autenticação na AWS |
| `AWS_SECRET_ACCESS_KEY` | Autenticação na AWS |
| `AWS_SESSION_TOKEN` | Token de sessão AWS Academy |
| `DOCKERHUB_USERNAME` | Login no Docker Hub |
| `DOCKERHUB_TOKEN` | Token de acesso ao Docker Hub |

---

## Imagem Docker

A imagem publicada está disponível no Docker Hub:

```
nicollasfsrs/devops-pucrs-nicollas:latest
```

Para rodar localmente:

```bash
docker run -p 8080:80 nicollasfsrs/devops-pucrs-nicollas:latest
```

Acesse em: `http://localhost:8080`
