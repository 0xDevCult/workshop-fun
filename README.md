# Question Board dApp

A decentralized question board built on Polkadot, where users can post questions and upvote posts from the community.

## 🌐 Live Demo

**🔗 [Launch the dApp](https://0xdevcult.github.io/workshop-fun/)**

## 🚀 Features

- **Post Questions**: Submit questions to the community
- **Upvote System**: Vote on questions you find helpful
- **Top Questions**: See the most upvoted questions
- **Polkadot Integration**: Built on Polkadot Asset Hub Testnet
- **Modern UI**: Beautiful interface with Tailwind CSS + DaisyUI

## 🛠️ Tech Stack

- **Frontend**: Vue 3 + TypeScript + Vite
- **Blockchain**: Polkadot Asset Hub Testnet
- **Smart Contract**: Solidity with Hardhat
- **Styling**: Tailwind CSS + DaisyUI
- **Web3**: Wagmi + Viem

## 📱 Screenshots

The dApp features a clean, modern interface with:
- DevCult branding and navigation
- Question posting form
- Real-time upvote functionality
- Top upvoted questions sidebar
- Wallet integration for Polkadot

## 🏗️ Smart Contract

**Contract Address**: `0x0c626FC4A447b01554518550e30600136864640B`  
**Network**: Polkadot Asset Hub Testnet

### Functions
- `postMessage(string content)` - Post a new question
- `upvoteMessage(uint256 messageIndex)` - Upvote a question
- `getAllMessages()` - Get all questions
- `getTopUpvotedMessages(uint256 count)` - Get top upvoted questions
- `hasUserUpvoted(uint256 messageIndex, address user)` - Check if user upvoted

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- npm or yarn
- MetaMask or Polkadot wallet

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/0xDevCult/workshop-attendance-dapp.git
   cd workshop-attendance-dapp/question-board
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start development server**
   ```bash
   npm run dev -w dapp-vue
   ```

4. **Deploy smart contract** (optional)
   ```bash
   npm run deploy -w hardhat
   ```

### Using the dApp

1. **Connect Wallet**: Click "Connect Wallet" and connect your Polkadot wallet
2. **Get Test Tokens**: Use the Polkadot Asset Hub faucet to get test PAS tokens
3. **Post Questions**: Write your question and click "Post Question"
4. **Upvote**: Click the upvote button on questions you like
5. **View Top Questions**: Check the "Top Upvoted Posts" sidebar

## 📚 Resources

- [Polkadot Documentation](https://docs.polkadot.com/develop/)
- [Vue.js Guide](https://vuejs.org/guide/)
- [Wagmi Documentation](https://wagmi.sh/)
- [Hardhat Documentation](https://hardhat.org/docs)

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built by [DevCult](https://devcult.io/)
- Powered by [Polkadot](https://polkadot.network/)
- Created with [create-dot-app](https://github.com/preschian/create-dot-app)

---

**🔗 [Launch the dApp](https://0xdevcult.github.io/workshop-fun/)**