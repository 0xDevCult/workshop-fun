<script setup lang="ts">
import type { Chain } from '@wagmi/vue/chains'
import { useAccount, useChainId, useChains } from '@wagmi/vue'
import { computed } from 'vue'
import { shortenAddress } from '../utils/formatters'
import Balance from './Balance.vue'
import Connect from './Connect.vue'

const { address, isConnected } = useAccount()
const chainId = useChainId()
const chains = useChains()

const connectedChain = computed(() => {
  return chains.value.find((chain: Chain) => chain.id === chainId.value) || chains.value[0]
})

const displayAddress = computed(() =>
  address.value ? shortenAddress(address.value) : 'Not connected',
)

function copyAddress() {
  if (address.value) {
    navigator.clipboard.writeText(address.value)
  }
}
</script>

<template>
  <div class="navbar bg-base-100 border-b border-gray-200">
    <div class="container mx-auto flex items-center justify-between">
      <div class="navbar-start">
        <a href="https://devcult.io/" target="_blank" class="flex items-center">
          <!-- DevCult Logo -->
          <div class="flex items-center">
            <!-- DevCult Symbol -->
            <div class="relative w-8 h-8 mr-3">
              <svg viewBox="0 0 32 32" class="w-full h-full">
                <!-- Upward triangle -->
                <path d="M16 4 L28 24 L4 24 Z" fill="none" stroke="black" stroke-width="2" stroke-linejoin="round"/>
                <!-- Outer crescent -->
                <path d="M8 20 Q16 12 24 20" fill="none" stroke="black" stroke-width="2.5"/>
                <!-- Inner crescent -->
                <path d="M10 20 Q16 14 22 20" fill="none" stroke="black" stroke-width="1.5"/>
              </svg>
            </div>
            <!-- DevCult text -->
            <span class="text-xl font-serif font-bold text-black tracking-wide">
              <span class="uppercase">D</span>ev<span class="uppercase">C</span>ult
            </span>
          </div>
        </a>
      </div>
      <div class="navbar-end gap-3">
        <!-- Account Info (only shown when connected) -->
        <div v-if="isConnected" class="hidden lg:flex items-center gap-3 text-sm">
          <!-- Network -->
          <div class="flex items-center gap-2 px-4 py-2 bg-gray-50 rounded border border-gray-200 min-w-[200px]">
            <div class="flex items-center gap-2">
              <span class="relative flex h-2 w-2">
                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75" />
                <span class="relative inline-flex rounded-full h-2 w-2 bg-green-500" />
              </span>
              <span class="icon-[mdi--network] w-4 h-4 text-gray-600" />
            </div>
            <span class="font-medium text-gray-700 truncate">{{ connectedChain.name }}</span>
          </div>

          <!-- Balance -->
          <div class="flex items-center gap-2 px-4 py-2 bg-gray-50 rounded border border-gray-200 min-w-[140px]">
            <span class="icon-[mdi--wallet] w-4 h-4 text-gray-600" />
            <Balance v-if="address" :address="address" />
          </div>

          <!-- Address with Copy -->
          <div class="flex items-center gap-2 px-4 py-2 bg-gray-50 rounded border border-gray-200 min-w-[160px]">
            <span class="icon-[mdi--account] w-4 h-4 text-gray-600 flex-shrink-0" />
            <span class="font-mono text-gray-700 truncate">{{ displayAddress }}</span>
            <button
              class="btn btn-ghost btn-xs hover:-translate-y-px transition-transform flex-shrink-0"
              @click="copyAddress"
            >
              <span class="icon-[mdi--content-copy] w-3 h-3" />
            </button>
          </div>
        </div>

        <!-- Connect Button -->
        <Connect />
      </div>
    </div>
  </div>
</template>
