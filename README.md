# Workshop Attendance Registry

A simple dApp to be used for educational purposes alongside an introductory workshop on programming trust.

This dApp has two goals:
- To show a simple full stack Solidity dapp that uses hardhat and is configured to deploy on Passet Hub
- To be used as a way to directly engage with workshop attendees in a more hands-on way either as a main focus of a workshop or alongside a presentation

## How it works

- Register your attendance on-chain for 0.1 PAS
- Your wallet address is permanently recorded as a workshop attendee
- Receive exclusive workshop completion NFT after the session
- Verifiable proof of participation for your portfolio/resume

The workshop facilitator must show the dApp UI on the projector and invite students to register before they begin their workshop.

Note: there is an intentional flaw in the contract code which at the end of the workshop the facilitator must point out.

### Workshop flow

- Deploy contract to testnet with 0.1 PAS fee and host front-end somewhere
- Students register → see their address in `attendeeList[]` via block explorer
- Contract balance grows from deposits → visible and verifiable
- At reveal: Call `distributeNFT()` or `batchDistributeNFTs()`
- All funds transfer to contract owners' address in one transaction
- Show the code and explain the exploit