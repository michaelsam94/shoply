# shopify_supabase_store

Production-ready Flutter MVP eCommerce app for mobile and web using Shopify Storefront API (GraphQL) and Supabase (PostgreSQL + Auth).

## 1. Project overview

This app provides:
- Supabase authentication (email/password, password reset)
- Shopify product catalog browsing and search
- Product details with variants and quantity selection
- Cart creation and management with Shopify cart APIs
- Checkout in WebView using Shopify checkout URL
- Wishlist and profile data backed by Supabase tables
- Responsive UI for Android, iOS, and Web

## 2. Architecture diagram (ASCII)

```text
                      +------------------------------+
                      |         Presentation         |
                      |  Screens + Riverpod Notifier |
                      +---------------+--------------+
                                      |
                                      v
                      +------------------------------+
                      |            Domain            |
                      | Entities + Repos + Usecases  |
                      +---------------+--------------+
                                      |
                                      v
                      +------------------------------+
                      |             Data             |
                      | Datasources + Repo Impl      |
                      +-------+--------------+--------+
                              |              |
                              v              v
                 +-------------------+   +-------------------+
                 | Shopify Storefront|   |     Supabase      |
                 |    GraphQL API    |   | Auth + Postgres   |
                 +-------------------+   +-------------------+
```

## 3. Prerequisites

- Flutter 3.22+
- Shopify store with Storefront API enabled
- Supabase project
- Access to Supabase SQL editor

## 4. Setup steps

1. Clone repo
   - `git clone <your-repo-url>`
   - `cd shopify_supabase_store`
2. Copy environment template and fill values
   - `cp .env.example .env`
3. Run Supabase SQL migration from `supabase/migrations/001_initial_schema.sql` in Supabase SQL editor
4. Enable Shopify Storefront API and generate Storefront token
5. Install dependencies
   - `flutter pub get`
6. Generate Riverpod/Hive code when needed
   - `flutter pub run build_runner build --delete-conflicting-outputs`
7. Run development app
   - `bash scripts/run_dev.sh`

## 5. How to get Shopify Storefront API token

1. Open Shopify Admin.
2. Go to **Settings** -> **Apps and sales channels**.
3. Open **Develop apps** (enable custom app development if prompted).
4. Create/select your custom app.
5. Under API access scopes, enable Storefront API scopes needed for products and cart.
6. Install/reinstall the app.
7. Copy the **Storefront access token**.
8. Set it in `.env` as `SHOPIFY_STOREFRONT_TOKEN`.

## 6. Folder structure explanation

- `lib/core`: app-wide infrastructure (env, router, theme, networking, errors, DI, utilities)
- `lib/features`: feature-first modules (`auth`, `home`, `product`, `cart`, `checkout`, `wishlist`, `profile`)
- `lib/shared/widgets`: reusable widgets like `ProductCard`, `PrimaryButton`, `TabPageScaffold`
- `supabase/migrations`: SQL migrations
- `scripts`: run/build helper scripts
- `.github/workflows`: CI pipeline

## 7. Build for release

- Web:
  - `bash scripts/build_web.sh`
- APK:
  - `bash scripts/build_apk.sh`

Both scripts read values from your shell environment and pass them with `--dart-define`.

## 8. Known limitations and next steps

- Add stronger runtime telemetry and crash reporting.
- Add deeper integration tests for auth/cart/checkout flows.
- Improve offline-first strategy for catalog and wishlist.
- Add admin-managed CMS blocks for home banners and merchandising.
- Add order sync worker from Shopify webhooks into Supabase `orders`.
