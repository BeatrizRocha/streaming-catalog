# Streaming Catalog - Backend API (Rails)

Este diretório contém o serviço de **API RESTful principal** do projeto Streaming Catalog, construído com **Ruby on Rails 7**. Ele é responsável pela gestão de usuários, autenticação e, futuramente, por todos os dados relacionados ao catálogo de streaming.

## 🚀 Visão Geral do Serviço

O backend é a espinha dorsal da aplicação, provendo os endpoints da API que serão consumidos pelas aplicações cliente (web, mobile, etc.). Ele utiliza **PostgreSQL** como banco de dados e é desenvolvido com foco em performance e segurança.

## ⚙️ Tecnologias Principais

* **Ruby on Rails 7 (API Mode)**
* **PostgreSQL**
* **RSpec** para testes
* **Docker** e **Docker Compose** para ambiente de desenvolvimento

## 💻 Configuração e Execução (Deste Serviço)

Para configurar e executar este serviço, você deve usar o `Makefile` principal localizado na **raiz do monorepo**. Os comandos abaixo são aliases ou comandos que você executaria a partir da raiz, mas aqui detalhamos sua função para este serviço.

### Pré-requisitos

Certifique-se de ter o Docker e o Docker Compose instalados.

### Primeiros Passos

1.  **Navegue até a raiz do monorepo:**
    ```bash
    cd ../.. # Ou para o diretório raiz do seu projeto
    ```
2.  **Construa as imagens Docker (se ainda não o fez):**
    ```bash
    make build
    ```
3.  **Inicie e prepare o ambiente (inclui este serviço):**
    ```bash
    make setup
    ```
    *Se houver problemas com o banco de dados durante o `make setup`:*
    ```bash
    make db-reset
    ```

### Executando o Servidor

Após a configuração, você pode iniciar os containers do monorepo, incluindo este serviço de backend. No momento, o comando abaixo inicia todos os serviços definidos no `docker-compose.yml` da raiz do projeto.
```bash
make up-d # Inicia todos os containers do monorepo em modo detached
make logs-web # Vê os logs apenas do serviço 'web'
```
O servidor da API estará disponível em http://localhost:3000.

### 💻 Comandos de Desenvolvimento (Executados da Raiz do Monorepo)

Estes comandos são ativados via Makefile na raiz e interagem especificamente com o container **web**.

* **`make console`**: Abre o console interativo do Rails.
* **`make routes`**: Lista todas as rotas da API.
* **`make rspec`**: Executa todos os testes RSpec para este serviço.
* **`make rspec-file ARGS="spec/requests/sessions_spec.rb"`**: Executa um arquivo RSpec específico.
* **`make rubocop`**: Executa o Rubocop para análise de código.

### 🗄️ Banco de Dados

* **`make db-create`**: Cria o banco de dados.
* **`make db-migrate`**: Executa as migrações.
* **`make db-seed`**: Popula o banco de dados com dados iniciais.
* **`make db-reset`**: Reseta o banco de dados (drop, create, migrate, seed).

### 🌐 Endpoints da API (Exemplos)

Aqui estão alguns dos endpoints atualmente disponíveis ou planejados:

* **POST /login**: Autentica um usuário existente.
    * **Requisição**: `POST /login` com `Content-Type: application/json`
    * **Corpo**: `{ "email": "user@example.com", "password": "password" }`
    * **Resposta de Sucesso (200 OK)**: `{ "user": { "id": 1, "email": "user@example.com", "name": "User Name" } }`
    * **Resposta de Erro (401 Unauthorized)**: `{ "error": "Invalid email or password" }`
* **DELETE /logout**: Desautentica o usuário.
    * **Requisição**: `DELETE /logout`
    * **Resposta de Sucesso (200 OK)**: `{ "message": "Logged out successfully" }`


### 🧪 Testes

Todos os testes para este serviço estão localizados no diretório `spec/`.
Para executar todos os testes, use `make rspec` (na raiz do monorepo).

### 🤝 Contribuição

Para contribuir com este serviço, consulte as diretrizes gerais de contribuição na [raiz do monorepo](../README.md#contribui%C3%A7%C3%A3o) e as diretrizes específicas de desenvolvimento Rails e testes RSpec.

### 📄 Licença

Este serviço é parte do projeto Streaming Catalog, licenciado sob a Licença MIT. Veja o arquivo [LICENSE](../LICENSE) na raiz do monorepo para mais detalhes.