/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { map } from 'common/collections';

import { ChatState } from './types';

// TODO: can we typecheck the store somehow?
export const selectChat = (state) => (state.chat as ChatState);

// TODO: can we typecheck the store somehow?
export const selectChatPages = (state) => {
  let chat = selectChat(state);
  return map(chat.pages, (id: string) => chat.pageById[id]);
};

// TODO: can we typecheck the store somehow?
export const selectCurrentChatPage = (state) => {
  let chat = selectChat(state);
  return chat.pageById[chat.currentPageId];
};

// TODO: can we typecheck the store somehow?
export const selectChatPageById = (id) => (state) => {
  let chat = selectChat(state);
  return chat.pageById[id];
};
