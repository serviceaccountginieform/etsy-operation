export interface LlmMessage {
  role: "system" | "user" | "assistant";
  content: string;
}

export interface LlmCompletionRequest {
  messages: LlmMessage[];
  responseFormat?: "text" | "json";
}

export interface LlmCompletion {
  content: string;
  model?: string;
  raw?: unknown;
}

export interface LlmProvider {
  complete(request: LlmCompletionRequest): Promise<LlmCompletion>;
}

export class LlmProviderNotConfigured implements LlmProvider {
  async complete(): Promise<LlmCompletion> {
    throw new Error("LLM calls are not implemented in Milestone 1.");
  }
}
