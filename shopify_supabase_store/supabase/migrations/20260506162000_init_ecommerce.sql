create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  created_at timestamptz not null default now()
);

create table if not exists public.wishlist_items (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  product_id text not null,
  created_at timestamptz not null default now(),
  unique (user_id, product_id)
);

create table if not exists public.cart_items (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  product_id text not null,
  quantity int not null default 1 check (quantity > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, product_id)
);

alter table public.profiles enable row level security;
alter table public.wishlist_items enable row level security;
alter table public.cart_items enable row level security;

create policy "users can read own profile" on public.profiles
for select using (auth.uid() = id);

create policy "users can update own profile" on public.profiles
for update using (auth.uid() = id);

create policy "users can insert own profile" on public.profiles
for insert with check (auth.uid() = id);

create policy "users manage own wishlist" on public.wishlist_items
for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "users manage own cart" on public.cart_items
for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
