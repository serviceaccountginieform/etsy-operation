import type { Listing, ListingImage, Shop } from "@/lib/types/listings";

export interface EtsyListingSnapshot extends Listing {
  images: ListingImage[];
}

export interface EtsyApi {
  getShopById(shopId: number): Promise<Shop>;
  listShopListings(shopId: number): Promise<EtsyListingSnapshot[]>;
}

export class EtsyApiNotConfigured implements EtsyApi {
  async getShopById(): Promise<Shop> {
    throw new Error("Etsy API integration is not implemented in Milestone 1.");
  }

  async listShopListings(): Promise<EtsyListingSnapshot[]> {
    throw new Error("Etsy API integration is not implemented in Milestone 1.");
  }
}
