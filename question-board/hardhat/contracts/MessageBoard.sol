// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract MessageBoard {
    struct Message {
        address sender;
        string content;
        uint256 timestamp;
        uint256 upvotes;
    }

    Message[] private messages;
    
    // Track which users have upvoted which messages to prevent double upvoting
    mapping(uint256 => mapping(address => bool)) private hasUpvoted;

    event MessagePosted(
        address indexed sender,
        string content,
        uint256 timestamp,
        uint256 messageIndex
    );
    
    event MessageUpvoted(
        address indexed upvoter,
        uint256 indexed messageIndex,
        uint256 newUpvoteCount
    );

    function postMessage(string memory _content) public {
        require(bytes(_content).length > 0, "Message cannot be empty");
        require(bytes(_content).length <= 280, "Message too long (max 280 characters)");

        messages.push(Message({
            sender: msg.sender,
            content: _content,
            timestamp: block.timestamp,
            upvotes: 0
        }));

        emit MessagePosted(msg.sender, _content, block.timestamp, messages.length - 1);
    }

    function getAllMessages() public view returns (Message[] memory) {
        return messages;
    }

    function getMessage(uint256 _index) public view returns (Message memory) {
        require(_index < messages.length, "Message does not exist");
        return messages[_index];
    }

    function getTotalMessages() public view returns (uint256) {
        return messages.length;
    }

    function getMessagesBySender(address _sender) public view returns (Message[] memory) {
        uint256 count = 0;
        
        for (uint256 i = 0; i < messages.length; i++) {
            if (messages[i].sender == _sender) {
                count++;
            }
        }

        Message[] memory result = new Message[](count);
        uint256 resultIndex = 0;
        
        for (uint256 i = 0; i < messages.length; i++) {
            if (messages[i].sender == _sender) {
                result[resultIndex] = messages[i];
                resultIndex++;
            }
        }
        
        return result;
    }

    function getLatestMessages(uint256 _count) public view returns (Message[] memory) {
        require(_count > 0, "Count must be greater than 0");
        
        uint256 totalMessages = messages.length;
        uint256 returnCount = _count > totalMessages ? totalMessages : _count;
        
        Message[] memory result = new Message[](returnCount);
        
        for (uint256 i = 0; i < returnCount; i++) {
            result[i] = messages[totalMessages - 1 - i];
        }
        
        return result;
    }
    
    function upvoteMessage(uint256 _messageIndex) public {
        require(_messageIndex < messages.length, "Message does not exist");
        require(!hasUpvoted[_messageIndex][msg.sender], "Already upvoted this message");
        
        messages[_messageIndex].upvotes++;
        hasUpvoted[_messageIndex][msg.sender] = true;
        
        emit MessageUpvoted(msg.sender, _messageIndex, messages[_messageIndex].upvotes);
    }
    
    function hasUserUpvoted(uint256 _messageIndex, address _user) public view returns (bool) {
        require(_messageIndex < messages.length, "Message does not exist");
        return hasUpvoted[_messageIndex][_user];
    }
    
    function getTopUpvotedMessages(uint256 _count) public view returns (Message[] memory) {
        require(_count > 0, "Count must be greater than 0");
        
        uint256 totalMessages = messages.length;
        if (totalMessages == 0) {
            return new Message[](0);
        }
        
        uint256 returnCount = _count > totalMessages ? totalMessages : _count;
        Message[] memory result = new Message[](returnCount);
        
        // Create a copy of messages with indices for sorting
        Message[] memory messagesCopy = new Message[](totalMessages);
        uint256[] memory indices = new uint256[](totalMessages);
        
        for (uint256 i = 0; i < totalMessages; i++) {
            messagesCopy[i] = messages[i];
            indices[i] = i;
        }
        
        // Simple bubble sort by upvotes (descending)
        for (uint256 i = 0; i < totalMessages - 1; i++) {
            for (uint256 j = 0; j < totalMessages - i - 1; j++) {
                if (messagesCopy[j].upvotes < messagesCopy[j + 1].upvotes) {
                    Message memory tempMessage = messagesCopy[j];
                    uint256 tempIndex = indices[j];
                    
                    messagesCopy[j] = messagesCopy[j + 1];
                    indices[j] = indices[j + 1];
                    
                    messagesCopy[j + 1] = tempMessage;
                    indices[j + 1] = tempIndex;
                }
            }
        }
        
        // Fill result array
        for (uint256 i = 0; i < returnCount; i++) {
            result[i] = messagesCopy[i];
        }
        
        return result;
    }
}
