#!/usr/bin/env bash

# bigs-casino.reviews — деплой в GitHub + Cloudflare Pages
# Использование: CLOUDFLARE_API_TOKEN="xxx" ./deploy.sh

ROOT_DOMAIN="bigs-casino.reviews"
GITHUB_USERNAME="bigsbettest"
REPO_NAME="bigs-casino-reviews"
PROJECT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CF_ACCOUNT_ID="311ad24e30a4dd6f3d13ab5f6c48e0d4"
CF_API_TOKEN="${CLOUDFLARE_API_TOKEN}"
export CLOUDFLARE_ACCOUNT_ID="${CF_ACCOUNT_ID}"
export CLOUDFLARE_API_TOKEN="${CF_API_TOKEN}"

# Проверки
command -v gh >/dev/null 2>&1 || { echo "ОШИБКА: Установите GitHub CLI (gh)"; exit 1; }
command -v wrangler >/dev/null 2>&1 || { echo "ОШИБКА: Установите Wrangler (npm i -g wrangler)"; exit 1; }
if [ -z "${CF_API_TOKEN}" ]; then
  echo "ОШИБКА: Установите CLOUDFLARE_API_TOKEN"
  echo "  export CLOUDFLARE_API_TOKEN=\"ваш_токен\""
  exit 1
fi

echo "=== bigs-casino.reviews — Деплой ==="
echo "Домен: https://${ROOT_DOMAIN}"
echo "Путь: ${PROJECT_PATH}"
echo ""

echo "=== ЭТАП 1: GITHUB (создание репо и push) ==="
gh repo create "${GITHUB_USERNAME}/${REPO_NAME}" --public --description "BigsBet casino reviews" 2>/dev/null || echo "Репо уже существует"
cd "${PROJECT_PATH}"
rm -rf .git 2>/dev/null
git init
git add .
git commit -m "Initial deploy" 2>/dev/null || git commit --allow-empty -m "Initial deploy"
git branch -M main
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
git push -u origin main --force || { echo "ОШИБКА: Push"; exit 1; }
echo "  ✓ GitHub: ${REPO_NAME}"
echo ""

echo "=== ЭТАП 2: CLOUDFLARE PAGES ==="
wrangler pages project create "${REPO_NAME}" --production-branch main 2>/dev/null || echo "Проект уже существует"
sleep 3
wrangler pages deploy "${PROJECT_PATH}" --project-name="${REPO_NAME}" || { echo "ОШИБКА: Deploy"; exit 1; }
echo ""
echo "Привязка домена ${ROOT_DOMAIN}..."
RES=$(curl -s -X POST "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/pages/projects/${REPO_NAME}/domains" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"${ROOT_DOMAIN}\"}")
echo "$RES" | grep -q '"success":true' && echo "  ✓ Домен привязан" || echo "  (домен мог быть уже привязан)"
echo ""

echo "=== ГОТОВО ==="
echo ""
echo "Сайт: https://${ROOT_DOMAIN}"
echo "Pages: https://${REPO_NAME}.${CF_ACCOUNT_ID}.pages.dev"
echo ""
echo "Автодеплой: Cloudflare Pages → Settings → Builds & deployments → Connect to Git"
