<script setup lang="ts">
import { ref } from 'vue'

interface Step {
  title: string
  command: string
  description: string
}

const setupSteps: Step[] = [
  {
    title: 'Clone the Repository',
    command: 'git clone https://github.com/0xDevCult/workshop-fun.git\ncd workshop-fun/question-board',
    description: 'Get the complete workshop project from GitHub',
  },
  {
    title: 'Install Dependencies',
    command: 'npm install',
    description: 'Install all required packages for both frontend and smart contracts',
  },
]

const deploymentSteps: Step[] = [
  {
    title: 'Deploy Smart Contract',
    command: 'npm run deploy -w hardhat',
    description: 'Deploy the MessageBoard contract to Polkadot Asset Hub Testnet',
  },
  {
    title: 'Update Contract Address',
    command: '# Update src/config/contracts.ts with your deployed address',
    description: 'Configure the frontend to connect to your deployed contract',
  },
  {
    title: 'Start Development Server',
    command: 'npm run dev -w dapp-vue',
    description: 'Launch the dApp locally and start building!',
  },
]

const techStack = [
  { category: 'Smart Contracts', tech: ['Hardhat', 'Solidity', 'Polkadot'] },
  { category: 'Frontend', tech: ['Vue 3', 'TypeScript', 'Wagmi', 'Viem'] },
  { category: 'Styling', tech: ['Tailwind CSS', 'DaisyUI'] },
]

const copiedSteps = ref<Set<string>>(new Set())

function copyCommand(command: string, stepTitle: string) {
  navigator.clipboard.writeText(command)
  copiedSteps.value.add(stepTitle)
  setTimeout(() => {
    copiedSteps.value.delete(stepTitle)
  }, 2000)
}
</script>

<template>
  <div class="bg-gray-50">
    <div class="container mx-auto px-4 py-8">
      <div class="card bg-white shadow-lg border border-gray-200">
        <div class="card-body">
          <!-- Header Section -->
          <div class="text-center mb-8">
            <h2 class="text-3xl font-mono font-bold text-black mb-3 tracking-wide flex items-center justify-center gap-3">
              <span class="icon-[mdi--hammer-wrench] w-8 h-8" />
              Build this dapp yourself
            </h2>
            <p class="text-lg text-gray-600 max-w-3xl mx-auto">
              This dApp was scaffolded using
              <a
                href="https://github.com/preschian/create-dot-app"
                target="_blank"
                class="text-blue-600 hover:text-blue-800 font-semibold underline"
              >
                create-dot-app
              </a>
              — a CLI tool that makes it easy to get started with full-stack dApp development on Polkadot.
            </p>
          </div>

          <!-- Tech Stack Section -->
          <div class="mb-10">
            <h3 class="text-xl font-bold text-black mb-4 flex items-center">
              <span class="icon-[mdi--stack-overflow] w-5 h-5 mr-2" />
              Tech Stack
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div
                v-for="stack in techStack"
                :key="stack.category"
                class="bg-gray-50 p-4 rounded border border-gray-200"
              >
                <h4 class="font-semibold text-black mb-2">
                  {{ stack.category }}
                </h4>
                <div class="flex flex-wrap gap-2">
                  <span
                    v-for="item in stack.tech"
                    :key="item"
                    class="badge badge-outline text-xs"
                  >
                    {{ item }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Setup Steps -->
          <div class="mb-10">
            <h3 class="text-xl font-bold text-black mb-4 flex items-center">
              <span class="icon-[mdi--download] w-5 h-5 mr-2" />
              Getting Started
            </h3>
            <div class="space-y-4">
              <div
                v-for="(step, index) in setupSteps"
                :key="step.title"
                class="bg-gray-50 p-4 rounded border border-gray-200"
              >
                <div class="flex items-start justify-between mb-2">
                  <div class="flex items-center gap-3">
                    <div class="badge badge-primary badge-lg font-bold">
                      {{ index + 1 }}
                    </div>
                    <h4 class="font-semibold text-black">
                      {{ step.title }}
                    </h4>
                  </div>
                  <button
                    class="btn btn-ghost btn-sm hover:-translate-y-px transition-transform"
                    @click="copyCommand(step.command, step.title)"
                  >
                    <span
                      v-if="copiedSteps.has(step.title)"
                      class="icon-[mdi--check] w-4 h-4 text-success"
                    />
                    <span
                      v-else
                      class="icon-[mdi--content-copy] w-4 h-4"
                    />
                  </button>
                </div>
                <p class="text-sm text-gray-600 mb-2 ml-12">
                  {{ step.description }}
                </p>
                <div class="ml-12">
                  <pre class="bg-gray-900 text-green-400 p-3 rounded text-sm overflow-x-auto font-mono"><code>{{ step.command }}</code></pre>
                </div>
              </div>
            </div>
          </div>

          <!-- Deployment Steps -->
          <div>
            <h3 class="text-xl font-bold text-black mb-4 flex items-center">
              <span class="icon-[mdi--rocket-launch] w-5 h-5 mr-2" />
              Deploy & Run Locally
            </h3>
            <div class="space-y-4">
              <div
                v-for="(step, index) in deploymentSteps"
                :key="step.title"
                class="bg-gray-50 p-4 rounded border border-gray-200"
              >
                <div class="flex items-start justify-between mb-2">
                  <div class="flex items-center gap-3">
                    <div class="badge badge-primary badge-lg font-bold">
                      {{ setupSteps.length + index + 1 }}
                    </div>
                    <h4 class="font-semibold text-black">
                      {{ step.title }}
                    </h4>
                  </div>
                  <button
                    class="btn btn-ghost btn-sm hover:-translate-y-px transition-transform"
                    @click="copyCommand(step.command, step.title)"
                  >
                    <span
                      v-if="copiedSteps.has(step.title)"
                      class="icon-[mdi--check] w-4 h-4 text-success"
                    />
                    <span
                      v-else
                      class="icon-[mdi--content-copy] w-4 h-4"
                    />
                  </button>
                </div>
                <p class="text-sm text-gray-600 mb-2 ml-12">
                  {{ step.description }}
                </p>
                <div class="ml-12">
                  <pre class="bg-gray-900 text-green-400 p-3 rounded text-sm overflow-x-auto font-mono"><code>{{ step.command }}</code></pre>
                </div>
              </div>
            </div>
          </div>

          <!-- Additional Resources -->
          <div class="mt-10 p-6 bg-blue-50 rounded-lg border border-blue-200">
            <div class="flex items-start gap-4">
              <span class="icon-[mdi--information] w-6 h-6 text-blue-600 flex-shrink-0 mt-1" />
              <div>
                <h4 class="font-semibold text-black mb-2">
                  Need Help?
                </h4>
                <p class="text-sm text-gray-700 mb-3">
                  Check out  some of the resources below more details on hacking on Polkadot.
                </p>
                <div class="flex flex-wrap gap-3">
                  <a
                    href="https://github.com/preschian/create-dot-app"
                    target="_blank"
                    class="btn btn-sm btn-outline hover:-translate-y-px transition-transform"
                  >
                    <span class="icon-[mdi--tools] w-4 h-4 mr-1" />
                    Learn About create-dot-app
                  </a>
                  <a
                    href="https://docs.polkadot.com/develop/"
                    target="_blank"
                    class="btn btn-sm btn-outline hover:-translate-y-px transition-transform"
                  >
                    <span class="icon-[mdi--book-open-page-variant] w-4 h-4 mr-1" />
                    Polkadot Docs
                  </a>
                  <a
                    href="https://github.com/polkadot-developers/hackathon-guide/"
                    target="_blank"
                    class="btn btn-sm btn-outline hover:-translate-y-px transition-transform"
                  >
                    <span class="icon-[mdi--trophy] w-4 h-4 mr-1" />
                    Hackathon Guide
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
