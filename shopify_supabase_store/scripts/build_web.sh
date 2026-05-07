#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -f .env ]]; then
  set -a
  # shellcheck source=/dev/null
  source .env
  set +a
fi

dart_defines=(
  "--dart-define=SHOPIFY_DOMAIN=${SHOPIFY_DOMAIN:-}"
  "--dart-define=SHOPIFY_STOREFRONT_TOKEN=${SHOPIFY_STOREFRONT_TOKEN:-}"
  "--dart-define=SUPABASE_URL=${SUPABASE_URL:-}"
  "--dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-}"
  "--dart-define=SUPABASE_EMAIL_REDIRECT=${SUPABASE_EMAIL_REDIRECT:-}"
)

exec flutter build web "${dart_defines[@]}" --release "$@"
