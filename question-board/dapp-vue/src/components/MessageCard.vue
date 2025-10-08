<script setup lang="ts">
import { useAccount, useReadContract, useWriteContract, useWaitForTransactionReceipt } from '@wagmi/vue'
import { computed, watch } from 'vue'
import { blo } from 'blo'
import { formatTime, shortenAddress } from '../utils/formatters'
import { MESSAGE_BOARD_ADDRESS, MessageBoardABI, CONTRACT_FUNCTIONS } from '../config/contracts'

// Props
const props = defineProps<{
  message: {
    id: number
    author: string
    content: string
    timestamp: Date
    upvotes: number
  }
}>()

const { address, isConnected } = useAccount()
const { writeContract, data: writeData, isPending: isUpvoting, error: upvoteError } = useWriteContract()

// Check if user has already upvoted this message
const { data: hasUpvotedData } = useReadContract({
  abi: MessageBoardABI,
  address: computed(() => MESSAGE_BOARD_ADDRESS as `0x${string}`),
  functionName: CONTRACT_FUNCTIONS.HAS_USER_UPVOTED,
  args: computed(() => [BigInt(props.message.id), address.value]),
  enabled: computed(() => !!address.value && isConnected.value),
})

// Wait for transaction confirmation
const { isLoading: isConfirming, isSuccess: isUpvoteConfirmed } = useWaitForTransactionReceipt({
  hash: writeData,
})

const isUpvoteInProgress = computed(() => isUpvoting.value || isConfirming.value)

const handleUpvote = async () => {
  if (!isConnected.value || hasUpvotedData.value) return

  try {
    writeContract({
      abi: MessageBoardABI,
      address: MESSAGE_BOARD_ADDRESS as `0x${string}`,
      functionName: CONTRACT_FUNCTIONS.UPVOTE_MESSAGE,
      args: [BigInt(props.message.id)],
    })
  } catch (error) {
    console.error('Error upvoting message:', error)
  }
}

// Watch for successful upvote and emit event to parent
const emit = defineEmits<{
  upvoted: [messageId: number]
}>()

watch(isUpvoteConfirmed, (confirmed) => {
  if (confirmed) {
    emit('upvoted', props.message.id)
  }
})
</script>

<template>
  <div class="card bg-white shadow-md hover:shadow-lg hover:-translate-y-0.5 transition-all duration-200 ease-in-out border border-gray-200 h-full flex flex-col">
    <div class="card-body flex flex-col h-full">
      <!-- Message Header -->
      <div class="flex items-start space-x-3 mb-4">
        <!-- Avatar -->
        <div class="avatar">
          <div class="w-9 rounded">
            <img :src="blo(message.author as `0x${string}`)">
          </div>
        </div>

        <!-- User Info -->
        <div class="flex-1 min-w-0">
          <div class="font-mono text-sm font-medium text-black truncate">
            {{ shortenAddress(message.author) }}
          </div>
          <div class="text-xs text-gray-500">
            {{ formatTime(message.timestamp) }}
          </div>
        </div>
      </div>

      <!-- Message Content -->
      <div class="flex-grow mb-4">
        <p class="text-gray-800 leading-relaxed">
          {{ message.content }}
        </p>
      </div>

      <!-- Upvote Button -->
      <div class="flex justify-end">
        <button
          class="btn btn-sm hover:-translate-y-px transition-transform"
          :class="{
            'btn-outline': !hasUpvotedData,
            'btn-success': hasUpvotedData,
            'btn-disabled': !isConnected || isUpvoteInProgress
          }"
          :disabled="!isConnected || hasUpvotedData || isUpvoteInProgress"
          @click="handleUpvote"
        >
          <span
            v-if="isUpvoteInProgress"
            class="icon-[mdi--loading] animate-spin w-4 h-4"
          />
          <span
            v-else-if="hasUpvotedData"
            class="icon-[mdi--check] w-4 h-4"
          />
          <span
            v-else
            class="icon-[mdi--arrow-up] w-4 h-4"
          />
          <span class="ml-1">{{ message.upvotes }}</span>
        </button>
      </div>

      <!-- Upvote Error -->
      <div v-if="upvoteError" class="mt-2">
        <div class="alert alert-error alert-sm">
          <span class="icon-[mdi--alert-circle] w-4 h-4" />
          <span class="text-xs">{{ upvoteError.message }}</span>
        </div>
      </div>
    </div>
  </div>
</template>
