import { ethers } from 'hardhat'
import fs from 'fs'
import path from 'path'

async function main() {
  console.log('Starting deployment...')
  
  // Get the contract factory
  const MessageBoard = await ethers.getContractFactory('MessageBoard')
  
  // Deploy the contract
  console.log('Deploying MessageBoard contract...')
  const messageBoard = await MessageBoard.deploy()
  
  // Wait for deployment to complete
  await messageBoard.waitForDeployment()
  
  // Get the contract address
  const contractAddress = await messageBoard.getAddress()
  
  console.log(`MessageBoard deployed to: ${contractAddress}`)
  
  // Save the contract address to a file
  const deploymentInfo = {
    contractAddress,
    network: 'passetHub',
    timestamp: new Date().toISOString(),
  }
  
  fs.writeFileSync(
    path.join(__dirname, '../deployment-info.json'),
    JSON.stringify(deploymentInfo, null, 2)
  )
  
  console.log('Deployment info saved to deployment-info.json')
  console.log('Deployment completed successfully!')
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
