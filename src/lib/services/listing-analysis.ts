import type { Listing, ListingAnalysis, ListingImage } from "@/lib/types/listings";

export interface ListingAnalysisInput {
  listing: Listing;
  images: ListingImage[];
}

export interface ListingAnalysisService {
  analyzeListing(input: ListingAnalysisInput): Promise<ListingAnalysis>;
}

export class ListingAnalysisNotImplemented implements ListingAnalysisService {
  async analyzeListing(): Promise<ListingAnalysis> {
    throw new Error("Listing analysis is not implemented in Milestone 1.");
  }
}
