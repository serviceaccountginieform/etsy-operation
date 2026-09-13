import type { Listing, ListingAnalysis } from "@/lib/types/listings";

export interface CoverageGap {
  topic: string;
  description: string;
  affectedListingIds: string[];
}

export interface CoverageAnalysisInput {
  listings: Listing[];
  analyses: ListingAnalysis[];
}

export interface CoverageAnalysisResult {
  gaps: CoverageGap[];
}

export interface CoverageAnalysisService {
  analyzeCoverage(input: CoverageAnalysisInput): Promise<CoverageAnalysisResult>;
}

export class CoverageAnalysisNotImplemented implements CoverageAnalysisService {
  async analyzeCoverage(): Promise<CoverageAnalysisResult> {
    throw new Error("Coverage analysis is not implemented in Milestone 1.");
  }
}
