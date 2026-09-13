# Etsy Operation

Etsy Operation is a Next.js application for importing Etsy shop listings,
analyzing listing quality, identifying catalog coverage gaps, and turning those
findings into prioritized listing opportunities.

This repository currently contains the Milestone 1 foundation only. Etsy OAuth,
live Etsy API calls, LLM calls, and opportunity generation are intentionally not
implemented yet.

## Architecture

The application is structured as a small modular Next.js app:

- `src/app` contains the App Router shell and route entry points.
- `src/lib/config` validates runtime configuration.
- `src/lib/supabase` owns Supabase client construction.
- `src/lib/types` contains shared domain types for shops, listings, images,
  analysis, and opportunities.
- `src/lib/services` defines service interfaces for external integrations and
  domain workflows.
- `supabase/migrations` contains PostgreSQL schema migrations.

The intended data flow is:

1. A shop sync uses an Etsy service implementation to fetch shop listings and
   images.
2. Synced data is persisted to `shops`, `listings`, `listing_images`, and
   `sync_runs`.
3. A listing analysis service evaluates individual listings and stores results
   in `listing_analysis`.
4. A coverage analysis service compares listings and analyses across the shop.
5. An opportunity generation service creates prioritized rows in
   `listing_opportunities`.

Milestone 1 only defines the contracts and persistence layer for that flow.

## Database Design

The initial Supabase schema includes:

- `shops`: one row per connected Etsy shop.
- `listings`: Etsy listing snapshots linked to a shop, with normalized fields
  and `raw_payload` for source data that does not yet have a first-class column.
- `listing_images`: image metadata linked to listings.
- `listing_analysis`: analysis results, scores, issues, recommendations, model
  metadata, and raw model output.
- `listing_opportunities`: actionable opportunities linked to listings and,
  when available, a specific analysis row.
- `sync_runs`: audit records for shop listing sync attempts.

The schema uses UUID primary keys internally, keeps Etsy IDs as unique external
identifiers, cascades listing-owned data when a listing is removed, and tracks
`created_at` / `updated_at` consistently. Row-level security is enabled with no
policies in Milestone 1; Milestone 2 should add ownership-aware policies when
authentication and shop connection flows are introduced.

## Service Interfaces

The initial contracts are:

- `EtsyApi` for shop and listing ingestion.
- `LlmProvider` for future model calls.
- `ListingAnalysisService` for per-listing quality analysis.
- `CoverageAnalysisService` for shop-level coverage gaps.
- `OpportunityGenerationService` for turning analyses into prioritized actions.

Milestone 1 includes placeholder implementations that throw explicit
not-implemented errors.

## Local Setup

Use Node.js `20.19+`, `22.13+`, or `24+`. The current dependency set may warn on
Node versions between those bands.

Install dependencies:

```bash
npm install
```

Create local environment variables:

```bash
cp .env.example .env.local
```

Run the app:

```bash
npm run dev
```

Type-check the project:

```bash
npm run typecheck
```

## Supabase

Apply migrations with the Supabase CLI once a local or hosted Supabase project is
configured:

```bash
supabase db push
```

Required environment variables are documented in `.env.example`.

## Milestone 2

Recommended next work:

- Add Etsy OAuth and token storage strategy.
- Implement the concrete Etsy API client and listing sync workflow.
- Add repository functions for upserting shops, listings, images, and sync runs.
- Add UI routes for connecting a shop and viewing synced listings.
- Add tests around sync mapping and database persistence.
