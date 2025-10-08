<script setup lang="ts">
import { useAccount, useReadContract, useWaitForTransactionReceipt, useWriteContract } from '@wagmi/vue'
import { computed, ref, watch } from 'vue'
import { MESSAGE_BOARD_ADDRESS, MessageBoardABI, CONTRACT_FUNCTIONS } from '../config/contracts'
import { shortenAddress } from '../utils/formatters'
import MessageCard from './MessageCard.vue'

// Account and contract hooks
const { address, isConnected } = useAccount()
const { writeContract, data: writeData, isPending: isWritePending, error: writeError } = useWriteContract()

// Common contract config
const contractConfig = {
  abi: MessageBoardABI,
  address: MESSAGE_BOARD_ADDRESS as `0x${string}`,
}

// Contract read operations
const { data: allMessagesData, isLoading: isLoadingMessages, refetch: refetchMessages } = useReadContract({
  ...contractConfig,
  functionName: CONTRACT_FUNCTIONS.GET_ALL_MESSAGES,
})

// Get top upvoted messages for the sidebar
const { data: topUpvotedData, isLoading: isLoadingTopUpvoted, refetch: refetchTopUpvoted } = useReadContract({
  ...contractConfig,
  functionName: CONTRACT_FUNCTIONS.GET_TOP_UPVOTED_MESSAGES,
  args: [BigInt(5)], // Get top 5 upvoted messages
})

// Wait for transaction confirmation
const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
  hash: writeData,
})

// Transform contract data to UI format
const messages = computed(() => {
  if (!allMessagesData.value || !Array.isArray(allMessagesData.value))
    return []

  return (allMessagesData.value as any[]).map((msg: any, index: number) => ({
    id: index, // Use actual array index for contract calls
    author: msg.sender,
    content: msg.content,
    timestamp: new Date(Number(msg.timestamp) * 1000), // Convert from Unix timestamp
    upvotes: Number(msg.upvotes || 0),
  }))
})

// Transform top upvoted messages data
const topUpvotedMessages = computed(() => {
  if (!topUpvotedData.value || !Array.isArray(topUpvotedData.value))
    return []

  return (topUpvotedData.value as any[]).map((msg: any, index: number) => ({
    id: index, // Use actual array index for contract calls
    author: msg.sender,
    content: msg.content,
    timestamp: new Date(Number(msg.timestamp) * 1000),
    upvotes: Number(msg.upvotes || 0),
  }))
})

const newMessage = ref('')
const toastMessage = ref('')
const showToast = ref(false)

// Posting state - combines write pending and confirmation
const isPosting = computed(() => isWritePending.value || isConfirming.value)

// Sort messages by timestamp (newest first)
const sortedMessages = computed(() =>
  [...messages.value].sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime()),
)

// Toast notification utility
function showToastNotification(message: string) {
  toastMessage.value = message
  showToast.value = true
  setTimeout(() => {
    showToast.value = false
  }, 3000)
}

// Handle posting new message
async function handlePostMessage() {
  if (!newMessage.value.trim() || !isConnected.value)
    return

  try {
    writeContract({
      ...contractConfig,
      functionName: CONTRACT_FUNCTIONS.POST_MESSAGE,
      args: [newMessage.value.trim()],
    })
  }
  catch (error) {
    console.error('Error posting message:', error)
  }
}

// Handle upvote event from MessageCard
function handleMessageUpvoted(messageId: number) {
  // Refresh both all messages and top upvoted messages
  refetchMessages()
  refetchTopUpvoted()
  showToastNotification('Upvote recorded!')
}

// Watch for successful transaction and refresh data
watch(isConfirmed, (confirmed) => {
  if (confirmed) {
    newMessage.value = ''
    refetchMessages()
    refetchTopUpvoted()
    showToastNotification('Message posted successfully!')
  }
})
</script>

<template>
  <div class="bg-gray-50">
    <div class="container mx-auto px-4 py-8">
      <!-- Header Section -->
      <div class="text-center mb-8">
        <h1 class="text-4xl font-mono font-bold text-black mb-2 tracking-wide">
          QUESTION WALL OF FAME
        </h1>
        <p class="text-xl text-gray-600 font-mono flex items-center justify-center gap-2">
          <span>Ask questions and upvote posts</span>
        </p>
      </div>

      <!-- Post New Message Section -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <!-- Create Message Form -->
        <div class="card bg-white shadow-lg border border-gray-200 h-fit">
          <div class="card-body">
            <h2 class="card-title text-black mb-4 flex items-center">
              <span class="icon-[mdi--message-plus] w-5 h-5 mr-2" />
              Submit Your Question
            </h2>

            <!-- Connection Warning (when not connected) -->
            <div v-if="!isConnected" class="flex flex-col items-center justify-center py-8">
              <div class="alert alert-warning">
                <span class="icon-[mdi--wallet-outline] w-6 h-6" />
                <div class="text-center">
                  <div class="font-semibold">
                    Wallet Not Connected
                  </div>
                  <div class="text-sm mt-1">
                    Please connect your wallet to post messages
                  </div>
                </div>
              </div>
              <a
                href="https://faucet.polkadot.io/?parachain=1111"
                target="_blank"
                class="text-sm text-blue-600 hover:text-blue-800 flex items-center space-x-1 mt-4"
              >
                <span class="icon-[mdi--water] w-4 h-4" />
                <span>Get Testnet PAS from Faucet</span>
              </a>
            </div>

            <!-- Message Form (when connected) -->
            <div v-else class="flex flex-col">
              <div class="form-control">
                <textarea
                  v-model="newMessage"
                  class="textarea textarea-bordered w-full min-h-[120px] resize-none focus:border-primary scrollbar-thin scrollbar-track-slate-100 scrollbar-thumb-slate-300 hover:scrollbar-thumb-slate-400"
                  placeholder="Post a question or topic you'd like to discuss. Or suggest an improvement to this dApp..."
                  :disabled="isPosting"
                />
              </div>

              <div class="flex justify-between items-center mt-4">
                <div class="flex items-center gap-4">
                  <div class="text-sm text-gray-500">
                    {{ newMessage.length }}/280
                  </div>
                  <a
                    href="https://faucet.polkadot.io/?parachain=1111"
                    target="_blank"
                    class="text-xs text-blue-600 hover:text-blue-800 flex items-center space-x-1"
                  >
                    <span class="icon-[mdi--water] w-3 h-3" />
                    <span>Get Testnet PAS</span>
                  </a>
                </div>
                <button
                  class="btn btn-primary px-6 uppercase tracking-wider hover:-translate-y-px transition-transform"
                  :disabled="!newMessage.trim() || isPosting || newMessage.length > 280"
                  @click="handlePostMessage"
                >
                  <span v-if="isPosting" class="icon-[mdi--loading] animate-spin w-4 h-4 mr-2" />
                  <span v-else class="icon-[mdi--send] w-4 h-4 mr-2" />
                  {{ isPosting ? (isConfirming ? 'Confirming...' : 'Posting...') : 'Post' }}
                </button>
              </div>

              <!-- Error Display -->
              <div v-if="writeError" class="alert alert-error mt-4">
                <span class="icon-[mdi--alert-circle] w-4 h-4" />
                <span>{{ writeError.message }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Upvoted Posts Card -->
        <div class="card bg-white shadow-lg border border-gray-200 h-fit">
          <div class="card-body">
            <h2 class="card-title text-black mb-4 flex items-center">
              <span class="icon-[mdi--thumb-up] w-5 h-5 mr-2" />
              Top Upvoted Posts
            </h2>

            <!-- Loading State -->
            <div v-if="isLoadingTopUpvoted" class="flex justify-center items-center py-8">
              <span class="icon-[mdi--loading] animate-spin w-6 h-6 text-primary" />
            </div>

            <!-- Empty State -->
            <div v-else-if="topUpvotedMessages.length === 0" class="flex flex-col items-center justify-center py-12">
              <div class="icon-[mdi--thumb-up-outline] w-16 h-16 text-gray-300 mb-4" />
              <h3 class="text-lg font-semibold text-gray-600 mb-2">
                No upvoted posts yet
              </h3>
              <p class="text-sm text-gray-500 text-center">
                Questions will appear here once they receive upvotes from the community
              </p>
            </div>

            <!-- Top Upvoted Messages List -->
            <div v-else class="space-y-3">
              <div
                v-for="message in topUpvotedMessages"
                :key="message.id"
                class="p-3 bg-gray-50 rounded border border-gray-200 hover:bg-gray-100 transition-colors"
              >
                <div class="flex items-start justify-between mb-2">
                  <div class="flex items-center gap-2">
                    <div class="w-6 h-6 rounded-full bg-gray-300 flex items-center justify-center">
                      <span class="text-xs font-mono">{{ shortenAddress(message.author).slice(0, 2) }}</span>
                    </div>
                    <span class="text-xs text-gray-600 font-mono">{{ shortenAddress(message.author) }}</span>
                  </div>
                  <div class="flex items-center gap-1 text-xs text-gray-500">
                    <span class="icon-[mdi--thumb-up] w-3 h-3" />
                    <span>{{ message.upvotes }}</span>
                  </div>
                </div>
                <p class="text-sm text-gray-800 line-clamp-2">{{ message.content }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Messages Feed -->
      <div class="space-y-6">
        <!-- Stats Header -->
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-2xl font-bold text-black flex items-center">
            <span class="icon-[mdi--message-text] w-6 h-6 mr-2" />
            Latest Posts
          </h2>
        </div>

        <!-- Loading State -->
        <div v-if="isLoadingMessages" class="flex justify-center items-center py-16">
          <div class="flex flex-col items-center space-y-4">
            <span class="icon-[mdi--loading] animate-spin w-8 h-8 text-primary" />
            <span class="text-gray-500">Loading messages...</span>
          </div>
        </div>

        <!-- Message Cards Grid -->
        <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 items-start">
          <MessageCard
            v-for="message in sortedMessages"
            :key="message.id"
            :message="message"
            @upvoted="handleMessageUpvoted"
          />
        </div>
      </div>

      <!-- Empty State (when no messages) -->
      <div v-if="messages.length === 0" class="text-center py-16">
        <div class="icon-[mdi--message-text-outline] w-24 h-24 mx-auto text-gray-300 mb-4" />
        <h3 class="text-xl font-semibold text-gray-600 mb-2">
          No messages yet
        </h3>
        <p class="text-gray-500">
          Be the first to share your thoughts with the community!
        </p>
      </div>
    </div>

    <!-- Toast Notification -->
    <div v-if="showToast" class="toast toast-top toast-end">
      <div class="alert alert-success">
        <span class="icon-[mdi--check-circle] w-4 h-4" />
        <span>{{ toastMessage }}</span>
      </div>
    </div>
  </div>
</template>
