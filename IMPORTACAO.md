# Guia de Importação de Cartas

Este documento explica como importar cartas das APIs públicas e como o admin pode gerenciar os dados.

## Importação Automática via API

### 1. Pokémon TCG

Importar cartas Pokémon da API oficial:

```bash
php artisan import:pokemon --limit=100
```

**Opções:**
- `--limit=50` (padrão: 50 cartas)

**Exemplo:**
```bash
php artisan import:pokemon --limit=200
```

---

### 2. Yu-Gi-Oh

Importar cartas Yu-Gi-Oh da API YGOProDeck:

```bash
php artisan import:yugioh --limit=100
```

**Opções:**
- `--limit=50` (padrão: 50 cartas)

**Exemplo:**
```bash
php artisan import:yugioh --limit=150
```

---

### 3. Magic: The Gathering

Importar cartas Magic da API Scryfall:

```bash
php artisan import:magic --limit=100
```

---

### 4. Disney Lorcana

Importar cartas da Lorcana API:

```bash
php artisan import:lorcana --limit=100
```

---

### 5. Legends of Runeterra

Importar cartas dos data bundles oficiais (Data Dragon):

```bash
php artisan import:runeterra --limit=100
```

---

### 6. Riftbound (League of Legends)

O Riftbound ainda não possui API pública estável, então o comando cadastra um
conjunto curado de cartas de exemplo (o verso oficial é usado como imagem):

```bash
php artisan import:riftbound --limit=20
```

---

### 7. Flesh and Blood

Sem API pública estável; o comando cadastra um conjunto curado de cartas de
exemplo (o verso oficial é usado como imagem):

```bash
php artisan import:flashandblood --limit=20
```

---

### Importar todos os TCGs de uma vez

```bash
php artisan import:all --limit=100
```

Esse comando executa, em sequência, os importadores de todos os TCGs
registrados em `config/tcgs.php`.

**Opções (todos os comandos):**
- `--limit=50` (padrão: 50 cartas)

---

## Importação Manual no Painel Admin

### Adicionar uma Carta Manualmente

1. Acesse o painel admin: `http://127.0.0.1:8000/admin/dashboard`
2. Clique em **"Gerenciar Cartas"** ou acesse `/admin/cards`
3. Clique no botão **"Criar Carta"**
4. Preencha os dados:
   - **Nome**: Nome da carta
   - **Set Code**: Código único da coleção
   - **Set Name**: Nome da coleção
   - **TCG**: Selecione (Pokémon, Yu-Gi-Oh, Magic, Lorcana, Riftbound, Flesh and Blood)
   - **Raridade**: common, uncommon, rare, super_rare, ultra_rare, secret_rare
   - **Condição**: mint, near_mint, excellent, good, played, poor
   - **Idioma**: pt (Português), en (Inglês), jp (Japonês), es (Espanhol)
   - **Preço**: Preço em reais
   - **Estoque**: Quantidade disponível
5. Clique em **"Salvar"**

---

## Editar Cartas Importadas

### Modificar uma Carta Existente

1. Acesse `/admin/cards`
2. Localize a carta desejada (use a busca se necessário)
3. Clique no botão **"Editar"**
4. Modifique os dados conforme desejado
5. Clique em **"Salvar"**

**Dados que podem ser editados:**
- Nome
- Set Code
- Set Name
- TCG
- Raridade
- Condição
- Idioma
- Preço
- Estoque
- URL da Imagem (opcional)
- Holográfica (checkbox)
- Primeira Edição (checkbox)

---

## Deletar Cartas

### Remover uma Carta

1. Acesse `/admin/cards`
2. Clique em **"Visualizar"** ou **"Editar"** da carta
3. Clique em **"Deletar"** (botão vermelho)
4. Confirme a exclusão

---

## Buscar Cartas

### Filtrar Cartas no Admin

Na página `/admin/cards`, use a barra de busca para procurar por nome. A busca é feita em tempo real.

**Exemplo:**
- Buscar "Charizard"
- Buscar "Pikachu"
- Buscar "Blue Eyes"

---

## Via API REST

### Buscar Cartas (GET)

```bash
# Todas as cartas
curl http://127.0.0.1:8000/api/v1/cards

# Filtrar por TCG
curl http://127.0.0.1:8000/api/v1/cards?tcg=pokemon

# Filtrar por nome
curl http://127.0.0.1:8000/api/v1/cards?search=Charizard

# Combinar filtros
curl http://127.0.0.1:8000/api/v1/cards?tcg=yugioh&rarity=ultra_rare
```

---

### Criar Carta via API (POST)

```bash
curl -X POST http://127.0.0.1:8000/api/v1/cards \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Blue Eyes White Dragon",
    "set_code": "yu-gi-oh-001",
    "set_name": "Legend Collection",
    "tcg": "yugioh",
    "rarity": "ultra_rare",
    "condition": "mint",
    "language": "en",
    "price": 2000.00,
    "stock": 1
  }'
```

---

## Fluxo Recomendado

1. **Primeiro Acesso (todos os TCGs):**
   ```bash
   php artisan migrate
   php artisan import:all --limit=100
   ```

2. **Gerenciamento:**
   - Acesse o painel admin em `/admin/cards`
   - Edite preços, condições e estoque conforme necessário
   - Cadastre/edite manualmente qualquer carta pelo formulário do admin

3. **Manutenção:**
   - Atualize estoque regularmente
   - Ajuste preços de mercado
   - Remova cartas que não estão mais disponíveis

---

## Campos de Cada Carta

| Campo | Tipo | Descrição |
|-------|------|-----------|
| name | String | Nome da carta |
| set_code | String | Código único da carta |
| set_name | String | Nome da coleção |
| tcg | Enum | Tipo de TCG |
| rarity | Enum | Raridade |
| condition | Enum | Condição física |
| language | Enum | Idioma |
| price | Decimal | Preço em reais |
| stock | Integer | Quantidade em estoque |
| image_url | String | URL da imagem (opcional) |
| is_holo | Boolean | É holográfica? |
| is_first_edition | Boolean | É primeira edição? |

---

## Troubleshooting

### "Command not found"
Se o comando `import:pokemon` não funcionar, execute:
```bash
php artisan list
```

Se não aparecer, limpe o cache:
```bash
php artisan cache:clear
php artisan config:clear
```

### "API Connection Error"
- Verifique sua conexão com a internet
- Verifique se a API está online
- Tente novamente em alguns minutos

### Cartas Duplicadas
Os scripts verificam cartas duplicadas antes de importar, então não há risco.

---

**Última atualização:** 13 de junho de 2026
