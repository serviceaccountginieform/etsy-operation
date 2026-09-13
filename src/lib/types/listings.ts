export type ListingStatus = "active" | "inactive" | "draft" | "sold_out" | "expired";

export interface Shop {
  id: string;
  etsyShopId: number;
  name: string;
  url?: string | null;
  currencyCode?: string | null;
}

export interface Listing {
  id: string;
  shopId: string;
  etsyListingId: number;
  title: string;
  description?: string | null;
  status: ListingStatus;
  priceAmount?: number | null;
  currencyCode?: string | null;
  quantity?: number | null;
  tags: string[];
  materials: string[];
}

export interface ListingImage {
  id: string;
  listingId: string;
  etsyImageId?: number | null;
  url: string;
  altText?: string | null;
  rank: number;
}

export interface ListingAnalysis {
  id: string;
  listingId: string;
  summary?: string | null;
  titleScore?: number | null;
  photoScore?: number | null;
  seoScore?: number | null;
  conversionScore?: number | null;
  issues: string[];
  recommendations: string[];
}

export type OpportunityKind =
  | "coverage_gap"
  | "seo_improvement"
  | "photo_improvement"
  | "pricing"
  | "inventory"
  | "other";

export interface ListingOpportunity {
  id: string;
  listingId: string;
  kind: OpportunityKind;
  title: string;
  description?: string | null;
  priority: number;
  status: "open" | "dismissed" | "completed";
}
