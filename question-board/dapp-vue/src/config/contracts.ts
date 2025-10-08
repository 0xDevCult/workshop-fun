// Contract address for Passet Hub Testnet (updated with upvote functionality)
export const MESSAGE_BOARD_ADDRESS = '0x0c626FC4A447b01554518550e30600136864640B'

// Export ABI
export { abi as MessageBoardABI } from '../../abi/MessageBoard.json'

// Contract function names for type safety
export const CONTRACT_FUNCTIONS = {
  POST_MESSAGE: 'postMessage',
  GET_ALL_MESSAGES: 'getAllMessages',
  GET_MESSAGE: 'getMessage',
  GET_TOTAL_MESSAGES: 'getTotalMessages',
  GET_MESSAGES_BY_SENDER: 'getMessagesBySender',
  GET_LATEST_MESSAGES: 'getLatestMessages',
  UPVOTE_MESSAGE: 'upvoteMessage',
  HAS_USER_UPVOTED: 'hasUserUpvoted',
  GET_TOP_UPVOTED_MESSAGES: 'getTopUpvotedMessages',
} as const
