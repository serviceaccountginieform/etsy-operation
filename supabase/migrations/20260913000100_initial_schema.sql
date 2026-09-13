create extension if not exists pgcrypto;

create table public.shops (
  id uuid primary key default gen_random_uuid(),
  etsy_shop_id bigint not null unique,
  name text not null,
  url text,
  currency_code text,
  synced_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create type public.listing_status as enum (
  'active',
  'inactive',
  'draft',
  'sold_out',
  'expired'
);

create table public.listings (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  etsy_listing_id bigint not null unique,
  title text not null,
  description text,
  status public.listing_status not null default 'inactive',
  price_amount numeric(12, 2),
  currency_code text,
  quantity integer,
  tags text[] not null default '{}',
  materials text[] not null default '{}',
  raw_payload jsonb not null default '{}'::jsonb,
  last_synced_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (shop_id, etsy_listing_id)
);

create table public.listing_images (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.listings(id) on delete cascade,
  etsy_image_id bigint,
  url text not null,
  alt_text text,
  rank integer not null default 0,
  width integer,
  height integer,
  raw_payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (listing_id, etsy_image_id),
  unique (listing_id, rank)
);

create table public.listing_analysis (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.listings(id) on delete cascade,
  summary text,
  title_score integer check (title_score between 0 and 100),
  photo_score integer check (photo_score between 0 and 100),
  seo_score integer check (seo_score between 0 and 100),
  conversion_score integer check (conversion_score between 0 and 100),
  issues jsonb not null default '[]'::jsonb,
  recommendations jsonb not null default '[]'::jsonb,
  model text,
  raw_output jsonb not null default '{}'::jsonb,
  analyzed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create type public.opportunity_kind as enum (
  'coverage_gap',
  'seo_improvement',
  'photo_improvement',
  'pricing',
  'inventory',
  'other'
);

create type public.opportunity_status as enum (
  'open',
  'dismissed',
  'completed'
);

create table public.listing_opportunities (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.listings(id) on delete cascade,
  analysis_id uuid references public.listing_analysis(id) on delete set null,
  kind public.opportunity_kind not null,
  title text not null,
  description text,
  priority integer not null default 3 check (priority between 1 and 5),
  status public.opportunity_status not null default 'open',
  evidence jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create type public.sync_run_status as enum (
  'queued',
  'running',
  'succeeded',
  'failed'
);

create table public.sync_runs (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid references public.shops(id) on delete set null,
  status public.sync_run_status not null default 'queued',
  started_at timestamptz,
  finished_at timestamptz,
  listings_seen integer not null default 0,
  listings_created integer not null default 0,
  listings_updated integer not null default 0,
  error_message text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index shops_etsy_shop_id_idx on public.shops (etsy_shop_id);
create index listings_shop_id_idx on public.listings (shop_id);
create index listings_status_idx on public.listings (status);
create index listing_images_listing_id_idx on public.listing_images (listing_id);
create index listing_analysis_listing_id_idx on public.listing_analysis (listing_id);
create index listing_opportunities_listing_id_idx on public.listing_opportunities (listing_id);
create index listing_opportunities_status_idx on public.listing_opportunities (status);
create index sync_runs_shop_id_idx on public.sync_runs (shop_id);
create index sync_runs_status_idx on public.sync_runs (status);

alter table public.shops enable row level security;
alter table public.listings enable row level security;
alter table public.listing_images enable row level security;
alter table public.listing_analysis enable row level security;
alter table public.listing_opportunities enable row level security;
alter table public.sync_runs enable row level security;

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger shops_set_updated_at
before update on public.shops
for each row execute function public.set_updated_at();

create trigger listings_set_updated_at
before update on public.listings
for each row execute function public.set_updated_at();

create trigger listing_images_set_updated_at
before update on public.listing_images
for each row execute function public.set_updated_at();

create trigger listing_analysis_set_updated_at
before update on public.listing_analysis
for each row execute function public.set_updated_at();

create trigger listing_opportunities_set_updated_at
before update on public.listing_opportunities
for each row execute function public.set_updated_at();

create trigger sync_runs_set_updated_at
before update on public.sync_runs
for each row execute function public.set_updated_at();
