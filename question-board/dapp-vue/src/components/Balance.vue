<script setup lang="ts">
import { useBalance } from '@wagmi/vue'
import { computed } from 'vue'

const props = defineProps<{
  address: `0x${string}`
}>()

const balance = useBalance({
  address: props.address,
})

const formattedBalance = computed(() => {
  const formatted = balance.data.value?.formatted || '0'
  const [whole, decimal] = formatted.split('.')
  
  if (!decimal || decimal.length <= 2) {
    return formatted
  }
  
  return `${whole}.${decimal.substring(0, 2)}..`
})
</script>

<template>
  <span v-if="balance.isLoading.value" class="font-mono font-semibold whitespace-nowrap">...</span>
  <span v-else-if="balance.error.value" class="font-mono font-semibold text-red-500 whitespace-nowrap">Error</span>
  <span v-else class="font-mono font-semibold whitespace-nowrap">{{ formattedBalance }} PAS</span>
</template>
