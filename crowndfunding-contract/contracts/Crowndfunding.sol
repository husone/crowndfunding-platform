// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crownfunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 raised;
        string image;
        address[] contributors;
        mapping(address => uint256) contributions;  
    } 

    mapping(uint256 => Campaign) public campaigns;
    uint256 public campaignCount = 0;
    function createCampaign(string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Campaign storage campaign = campaigns[campaignCount];
        require(_deadline > block.timestamp, "Deadline must be in the future");
        campaign.owner = msg.sender;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.image = _image;
        campaign.raised = 0;
        return campaignCount++;
    }

    function contribute(uint256 _campaignId) public payable {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp < campaign.deadline, "Campaign is closed");
        campaign.contributions[msg.sender] += msg.value;
        campaign.raised += msg.value;
        campaign.contributors.push(msg.sender);
    }

}