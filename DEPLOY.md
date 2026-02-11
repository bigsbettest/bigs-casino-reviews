# bigs-casino.reviews — Деплой на Cloudflare Pages

## Параметры

- **Домен:** https://bigs-casino.reviews
- **GitHub репо:** bigsbettest/bigs-casino-reviews
- **Cloudflare Account ID:** 311ad24e30a4dd6f3d13ab5f6c48e0d4

## Требования

1. **GitHub CLI** — `brew install gh` (Mac)
2. **Wrangler** — `npm i -g wrangler`
3. **Cloudflare API Token** — [dash.cloudflare.com/profile/api-tokens](https://dash.cloudflare.com/profile/api-tokens) с правами `Account.Cloudflare Pages: Edit`

## Запуск деплоя

```bash
cd /Users/vladimirtolmacev/cursor/JTBD/SEO-сетка-сателлитов/bigs-casino.reviews

export CLOUDFLARE_API_TOKEN="ваш_токен"

chmod +x deploy.sh
./deploy.sh
```

Скрипт:
1. Создаёт репозиторий `bigsbettest/bigs-casino-reviews`
2. Пушит все файлы в GitHub
3. Создаёт проект Cloudflare Pages и деплоит
4. Привязывает домен bigs-casino.reviews

## Домен

Перед деплоем убедитесь, что домен **bigs-casino.reviews** добавлен в Cloudflare (любая зона). Иначе привязка в Pages может не сработать.

## Ручной деплой

### 1. GitHub

```bash
cd bigs-casino.reviews
git init && git add . && git commit -m "Initial" && git branch -M main
gh repo create bigsbettest/bigs-casino-reviews --public --source=. --push
```

### 2. Cloudflare Pages

1. [Cloudflare Dashboard](https://dash.cloudflare.com) → Pages → Create project
2. **Connect to Git** → выберите `bigsbettest/bigs-casino-reviews`
3. Build settings:
   - Framework preset: None
   - Build command: (пусто)
   - Build output directory: `/`
4. Deploy
5. Settings → Custom domains → Add → `bigs-casino.reviews`
