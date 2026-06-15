# OKIBA Project

Sistema de gerenciamento de cartas e produtos construído com **Laravel 11** e **PHP 8.2**.

## O que é este projeto?

O OKIBA é uma aplicação web que permite:
- Visualizar um painel de administração
- Gerenciar cartas (criar, listar, editar, remover)
- Gerenciar produtos e categorias
- Acessar dados via API REST

## Pré-requisitos

Antes de começar, você precisa ter instalado na sua máquina:

1. **PHP 8.2 ou superior** - [Download](https://windows.php.net/download/)
2. **Composer** - [Download](https://getcomposer.org/download/)
3. **Git** (opcional, mas recomendado)

### Como instalar no Windows

#### PHP 8.2
1. Baixe a versão "Thread Safe" do [site oficial](https://windows.php.net/download/)
2. Extraia em uma pasta (ex: `C:\php`)
3. Adicione o caminho ao PATH do Windows:
   - Abra "Variáveis de Ambiente"
   - Adicione `C:\php` à variável `PATH`
   - Reinicie o terminal ou VS Code

#### Composer
1. Baixe o instalador do [site oficial](https://getcomposer.org/download/)
2. Execute e siga as instruções
3. Composer será instalado globalmente

### Como instalar no Linux/Mac

```bash
# Ubuntu/Debian
sudo apt-get install php8.2 composer

# macOS (usando Homebrew)
brew install php composer
```

## Como rodar o projeto

### Opção 1: Usando o script automático (recomendado)

#### Windows (PowerShell)
```powershell
.\setup-windows.ps1
```

#### Linux/Mac
```bash
bash setup-unix.sh
```

### Opção 2: Passo a passo manual

1. **Instalar dependências:**
   ```bash
   composer install
   ```

2. **Preparar arquivo de configuração:**
   ```bash
   cp .env.example .env
   ```

3. **Gerar chave da aplicação:**
   ```bash
   php artisan key:generate
   ```

4. **Criar as tabelas do banco de dados:**
   ```bash
   php artisan migrate
   ```

5. **Iniciar o servidor:**
   ```bash
   php artisan serve
   ```

6. **Acessar a aplicação:**
   - Abra [http://127.0.0.1:8000](http://127.0.0.1:8000) no navegador
   - Clique no painel administrativo ou acesse `/admin/dashboard`

## Estrutura do projeto

```
.
├── app/                      # Código da aplicação
│   ├── Models/              # Estruturas de dados (User, Card, Product, Category)
│   ├── Http/
│   │   ├── Controllers/     # Controladores (lógica das ações)
│   │   └── Middleware/      # Filtros de requisição
│   └── Providers/           # Configuradores de serviços
├── routes/                  # Caminhos da aplicação (URLs)
├── resources/
│   └── views/              # Páginas HTML
├── database/
│   ├── migrations/         # Scripts que criam as tabelas
│   └── database.sqlite     # Banco de dados local
├── public/                 # Pasta acessível pelo navegador
├── config/                 # Arquivos de configuração
├── vendor/                 # Bibliotecas instaladas (gerado pelo Composer)
└── .env                    # Configurações do sistema
```

## O que faz cada parte?

- **Models** - Representam os dados do sistema (usuário, carta, produto, categoria)
- **Controllers** - Fazem as ações do sistema (listar, criar, editar, remover)
- **Routes** - Definem os caminhos que você pode acessar na web
- **Views** - As páginas HTML que você vê no navegador
- **Migrations** - Scripts que criam e modificam as tabelas do banco

## Rotas principais

| Rota | O que faz |
|------|-----------|
| `/` | Redireciona para o painel |
| `/admin/dashboard` | Painel de administração |
| `/admin/cards` | Gerenciar cartas |
| `/admin/products` | Gerenciar produtos |
| `/api/v1/cards` | API de cartas (dados em JSON) |
| `/api/v1/products` | API de produtos (dados em JSON) |

## APIs de TCG Públicas

O projeto pode importar dados de cartas de várias APIs públicas:

### **Pokémon - Pokémon TCG API**
- URL: `https://api.pokemontcg.io/v2/`
- Documentação: https://docs.pokemontcg.io/
- Sem autenticação: ✅

**Importar cartas:**
```bash
php artisan import:pokemon --limit=100
```

### **Yu-Gi-Oh - YGOProDeck API**
- URL: `https://db.ygoprodeck.com/api/v7/`
- Documentação: https://ygoprodeck.com/api-guide/
- Sem autenticação: ✅

**Importar cartas:**
```bash
php artisan import:yugioh --limit=100
```

### **Magic: The Gathering - Scryfall API**
- URL: `https://api.scryfall.com/`
- Documentação: https://scryfall.com/docs/api
- Sem autenticação: ✅

**Importar cartas:**
```bash
php artisan import:magic --limit=100
```

### **Lorcana, Riftbound, Flesh and Blood**
- Sem APIs públicas disponíveis
- **Importação manual:** Use o painel admin para adicionar cartas manualmente
- **Edição:** O admin pode editar qualquer carta importada

### **Adicionar cartas manualmente**
1. Acesse `/admin/cards`
2. Clique em "Criar Carta"
3. Preencha os dados
4. Selecione o TCG
5. Salve

**Editando cartas importadas:**
1. Acesse `/admin/cards`
2. Clique em "Editar" na carta desejada
3. Modifique os dados conforme necessário
4. Salve

📖 **Veja [IMPORTACAO.md](IMPORTACAO.md) para guia completo de importação e gerenciamento de cartas**

## Produtos selados, acessórios e singles manuais

O sistema já suporta cadastrar diferentes tipos de produtos:

- `single`: Carta avulsa (single)
- `box`: Caixa selada (produto selado)
- `booster`: Booster pack
- `accessory`: Acessório (sleeves, binder, playmats)
- `deck`: Deck montado

Para TCGs que não possuem API pública, como Lorcana, Riftbound e Flesh and Blood, importe ou crie os singles manualmente via admin e use `box` para produtos selados.

No painel admin em `/admin/products`, ao criar ou editar um produto, você pode selecionar o `TCG` e o `Tipo`. A listagem também permite filtrar por tipo e por TCG.

Exemplo de uso:

```bash
# Criar uma caixa selada (manual)
php artisan tinker
>>> \App\Models\Product::create([ 'user_id' => 1, 'title' => 'Lorcana Booster Box', 'type' => 'box', 'tcg' => 'lorcana', 'price' => 299.90, 'stock' => 10 ]);
```


## Como testar

Para rodar os testes e verificar se tudo está funcionando:

```bash
php artisan test --testsuite=Feature
```

## Banco de dados

O projeto usa **SQLite**, que é um banco simples que funciona com um arquivo local. Não precisa de instalação extra!

- Arquivo do banco: `database/database.sqlite`
- Tabelas criadas: `users`, `categories`, `cards`, `products`

## Comandos úteis do Laravel

```bash
# Ver todas as rotas
php artisan route:list

# Criar um novo Model
php artisan make:model NomeDoCodigo

# Criar um novo Controller
php artisan make:controller NomeDoController

# Criar uma nova tabela
php artisan make:migration create_nova_tabela_table

# Rodar migrations
php artisan migrate

# Desfazer última migration
php artisan migrate:rollback

# Limpar cache
php artisan cache:clear
```

## Problemas comuns

### "php command not found"
- Verifique se o PHP está instalado: `php -v`
- Se não aparecer a versão, adicione PHP ao PATH

### "Composer command not found"
- Verifique se o Composer está instalado: `composer -v`
- Se não aparecer, reinstale seguindo as instruções da [página oficial](https://getcomposer.org/)

### Erro ao conectar ao banco
- Certifique-se de que `database/database.sqlite` existe
- Se não existir, rode `php artisan migrate`

### Porta 8000 já está sendo usada
- Use uma porta diferente: `php artisan serve --port=8001`

## Documentação oficial

- [Laravel](https://laravel.com/docs)
- [PHP](https://www.php.net/docs.php)
- [Composer](https://getcomposer.org/doc/)

## Próximos passos

Após o projeto estar rodando, você pode:
1. Adicionar mais recursos (novas páginas, funcionalidades)
2. Conectar a um banco de dados real (MySQL, PostgreSQL)
3. Fazer autenticação de usuários
4. Adicionar validações
5. Melhorar o visual das páginas

---

**Última atualização:** 13 de junho de 2026
