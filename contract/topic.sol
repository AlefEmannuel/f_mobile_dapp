// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Topic{

    struct Comments{
        uint id;
        address creator;
        uint createdAt;
        string content;
    }

    struct TopicStruct{
        uint id;
        address creator;
        uint createdAt;
        string content;
        uint upvotes;
        uint downvotes;
    }

    mapping(uint => Comments[]) commments;


    uint topicCost = 10**16;
    uint commentCost = 10**15;
    TopicStruct[] forumTopics;

    function createTopic(string memory content) public payable{
        require(msg.value == topicCost);
        address creator = msg.sender;
        uint createdAt = block.timestamp;
        uint id = uint(keccak256(abi.encodePacked(createdAt, creator, forumTopics.length)));
        forumTopics.push(TopicStruct(id, creator, createdAt, content, 0, 0));
        address payable ownerPayableAddress = payable(owner);
        ownerPayableAddress.transfer(topicCost);
    }

    function getAllTopics() public view returns (TopicStruct[] memory){
        return forumTopics;
    }

    function getAllComments(uint topicId) public view returns (Comments[] memory){
        return commments[topicId];
    }

    function donate(address add) public payable{
        require(msg.value > 10**13);
        address payable reciever = payable(add);      
        reciever.transfer(msg.value);  
    }
    

    function commentTopic(uint topicId, string memory content) public payable {
        require(msg.value == commentCost);
        address payable topicCreatorAddress;

        for (uint i = 0; i < forumTopics.length; i++){
            if(topicId == forumTopics[i].id){
                uint createdAt = block.timestamp;
                address creator = msg.sender;
                //topicCreatorAddress = forumTopics[i].creator;
                uint id = uint(keccak256(abi.encodePacked(createdAt, creator, commments[topicId].length, topicId)));
                commments[topicId].push(Comments(id, creator, createdAt, content));
            }
        }
        address payable ownerPayableAddress = payable(owner);
        topicCreatorAddress.transfer(commentCost*1/3);
        ownerPayableAddress.transfer(commentCost*2/3);
    }


    address owner;
    
    modifier onlyOwner(){
        require(msg.sender == owner);
         _;
    }

    constructor() {
        owner = msg.sender;
    }


}