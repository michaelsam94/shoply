# Shoply

Flutter storefront using **Shopify Storefront API** and **Supabase** (auth + Postgres).

## Project layout

- **`shopify_supabase_store/`** — Flutter app (source, scripts, migrations)

Setup, architecture, and build commands are documented in [`shopify_supabase_store/README.md`](shopify_supabase_store/README.md).

## Secrets

Do **not** commit API keys or tokens. Copy `shopify_supabase_store/.env.example` to `shopify_supabase_store/.env` locally and fill in values from Shopify and Supabase dashboards.
