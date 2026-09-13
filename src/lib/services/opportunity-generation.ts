import type {
  Listing,
  ListingAnalysis,
  ListingOpportunity,
} from "@/lib/types/listings";
import type { CoverageAnalysisResult } from "@/lib/services/coverage-analysis";

export interface OpportunityGenerationInput {
  listings: Listing[];
  analyses: ListingAnalysis[];
  coverage: CoverageAnalysisResult;
}

export interface OpportunityGenerationService {
  generateOpportunities(
    input: OpportunityGenerationInput,
  ): Promise<ListingOpportunity[]>;
}

export class OpportunityGenerationNotImplemented
  implements OpportunityGenerationService
{
  async generateOpportunities(): Promise<ListingOpportunity[]> {
    throw new Error("Opportunity generation is not implemented in Milestone 1.");
  }
}
