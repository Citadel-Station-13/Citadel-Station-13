export type ChatState = {
  version: number;
  currentPageId: ChatPageId;
  scrollTracking: boolean;
  pages: ChatPageId[];
  pageById: Record<ChatPageId, ChatPage>;
}

export type ChatPageId = string;

export type ChatPage = {
  isMain: boolean;
  id: ChatPageId;
  name: string;
  acceptedTypes: Record<string, boolean>;
  unreadCount: number;
  hideUnreadCount: boolean;
  createdAt: number;
};
