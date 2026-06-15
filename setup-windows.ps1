#!/usr/bin/env powershell
# Script de setup do projeto OKIBA para Windows
# Executa todos os passos necessários para preparar o projeto

Write-Host "========================================" -ForegroundColor Green
Write-Host "  OKIBA Project - Setup Automático" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Verificar se PHP está instalado
Write-Host "[1/5] Verificando PHP..." -ForegroundColor Cyan
try {
    $phpVersion = php -v 2>$null | Select-Object -First 1
    Write-Host "✓ PHP encontrado: $phpVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ PHP não encontrado!" -ForegroundColor Red
    Write-Host "Por favor, instale PHP 8.2 ou superior" -ForegroundColor Yellow
    exit 1
}

# Verificar se Composer está instalado
Write-Host "[2/5] Verificando Composer..." -ForegroundColor Cyan
try {
    $composerVersion = composer -v 2>$null | Select-Object -First 1
    Write-Host "✓ Composer encontrado" -ForegroundColor Green
} catch {
    Write-Host "✗ Composer não encontrado!" -ForegroundColor Red
    Write-Host "Por favor, instale Composer em https://getcomposer.org" -ForegroundColor Yellow
    exit 1
}

# Instalar dependências
Write-Host "[3/5] Instalando dependências do projeto..." -ForegroundColor Cyan
composer install --no-interaction --prefer-dist
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Erro ao instalar dependências" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependências instaladas" -ForegroundColor Green

# Preparar arquivo de ambiente
Write-Host "[4/5] Configurando arquivo de ambiente..." -ForegroundColor Cyan
if (-Not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "✓ Arquivo .env criado" -ForegroundColor Green
} else {
    Write-Host "✓ Arquivo .env já existe" -ForegroundColor Green
}

# Gerar chave de aplicação
Write-Host "[5/5] Gerando chave de aplicação..." -ForegroundColor Cyan
php artisan key:generate --force --ansi
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Erro ao gerar chave" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Chave gerada" -ForegroundColor Green

# Criar banco de dados e rodar migrations
Write-Host "" -ForegroundColor Cyan
Write-Host "Criando banco de dados e tabelas..." -ForegroundColor Cyan
php artisan migrate --force --ansi
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Erro ao executar migrations" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Banco de dados preparado" -ForegroundColor Green

# Sucesso
Write-Host "" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ Setup concluído com sucesso!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Execute: php artisan serve" -ForegroundColor White
Write-Host "2. Abra: http://127.0.0.1:8000" -ForegroundColor White
Write-Host "3. Acesse o painel em: /admin/dashboard" -ForegroundColor White
Write-Host ""
