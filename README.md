# Streaming Catalog

Bem-vindo ao repositório do projeto **Streaming Catalog**!

Este é um monorepo que contém múltiplos microserviços e aplicações cliente desenvolvidos para construir uma plataforma abrangente de catálogo de streaming de vídeo. A arquitetura de microserviços permite escalabilidade, modularidade.

## 🚀 Visão Geral do Projeto

O objetivo do **Streaming Catalog** é fornecer uma solução completa para organizar, buscar e gerenciar conteúdo de streaming. O projeto é dividido em diferentes serviços, cada um responsável por uma parte específica da funcionalidade.

## 📦 Estrutura do Monorepo

Este repositório está organizado da seguinte forma:
```shell
.
├── backend/                  # Serviço de API principal (Rails)
├── docs/                     # Documentação geral do projeto
├── .dockerignore
├── .gitignore
├── docker-compose.yml        # Configuração do Docker Compose para todos os serviços
├── Makefile                  # Comandos helper para gerenciamento do monorepo
└── README.md                 # Este arquivo
```


## 💻 Serviços Incluídos

Atualmente, este monorepo contém os seguintes serviços:

* **`backend`**:
    * Um serviço de **API RESTful** construído com **Ruby on Rails 7**.
    * Responsável pela gestão de usuários, autenticação e dados do catálogo.
    * Detalhes de configuração e uso podem ser encontrados no [README do Backend](./backend/README.md).

## 🛠️ Configuração e Execução

Para iniciar e gerenciar todos os serviços do monorepo, utilize os comandos helper do `Makefile` na raiz deste repositório.

### Pré-requisitos

Certifique-se de ter o [Docker](https://docs.docker.com/get-docker/) e o [Docker Compose](https://docs.docker.com/compose/install/) instalados em seu sistema.

### Comandos Essenciais

* **`make build`**: Constrói ou reconstrói as imagens Docker para todos os serviços.
* **`make up-d`**: Inicia todos os serviços em modo `detached` (segundo plano).
* **`make down`**: Para e remove todos os containers dos serviços.
* **`make setup`**: Executa a configuração inicial de todos os serviços (instala dependências, prepara bancos de dados, etc.).

Para comandos específicos de cada serviço, consulte o `README.md` individual de cada pasta (ex: `./backend/README.md`).

## 📜 Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.