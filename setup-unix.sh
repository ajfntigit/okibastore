#!/bin/bash
# Script de setup do projeto OKIBA para Linux/Mac
# Executa todos os passos necessários para preparar o projeto

echo "========================================"
echo "  OKIBA Project - Setup Automático"
echo "========================================"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Verificar se PHP está instalado
echo -e "${CYAN}[1/5] Verificando PHP...${NC}"
if ! command -v php &> /dev/null; then
    echo -e "${RED}✗ PHP não encontrado!${NC}"
    echo -e "${YELLOW}Por favor, instale PHP 8.2 ou superior${NC}"
    exit 1
fi
PHP_VERSION=$(php -v | head -n 1)
echo -e "${GREEN}✓ PHP encontrado: $PHP_VERSION${NC}"

# Verificar se Composer está instalado
echo -e "${CYAN}[2/5] Verificando Composer...${NC}"
if ! command -v composer &> /dev/null; then
    echo -e "${RED}✗ Composer não encontrado!${NC}"
    echo -e "${YELLOW}Por favor, instale Composer em https://getcomposer.org${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Composer encontrado${NC}"

# Instalar dependências
echo -e "${CYAN}[3/5] Instalando dependências do projeto...${NC}"
composer install --no-interaction --prefer-dist
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Erro ao instalar dependências${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Dependências instaladas${NC}"

# Preparar arquivo de ambiente
echo -e "${CYAN}[4/5] Configurando arquivo de ambiente...${NC}"
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${GREEN}✓ Arquivo .env criado${NC}"
else
    echo -e "${GREEN}✓ Arquivo .env já existe${NC}"
fi

# Gerar chave de aplicação
echo -e "${CYAN}[5/5] Gerando chave de aplicação...${NC}"
php artisan key:generate --force --ansi
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Erro ao gerar chave${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Chave gerada${NC}"

# Criar banco de dados e rodar migrations
echo ""
echo -e "${CYAN}Criando banco de dados e tabelas...${NC}"
php artisan migrate --force --ansi
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Erro ao executar migrations${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Banco de dados preparado${NC}"

# Sucesso
echo ""
echo "========================================"
echo -e "${GREEN}✓ Setup concluído com sucesso!${NC}"
echo "========================================"
echo ""
echo -e "${YELLOW}Próximos passos:${NC}"
echo "1. Execute: php artisan serve"
echo "2. Abra: http://127.0.0.1:8000"
echo "3. Acesse o painel em: /admin/dashboard"
echo ""
