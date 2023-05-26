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
    }
    mapping(address => mapping(uint256 => uint256)) public contributions;
    mapping(uint256 => Campaign) public campaigns;
    uint256 public campaignCount = 0;

    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
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
        (bool sent, ) = payable(campaign.owner).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
        contributions[msg.sender][_campaignId] += msg.value;
        campaign.raised += msg.value;
        require(
            campaign.raised <= campaign.target,
            "Campaign is reached the target"
        );
        require(campaign.raised <= campaign.target, "Campaign is closed");
        for(uint i = 0; i< campaign.contributors.length; i++) {
            if(campaign.contributors[i] == msg.sender) {
                return;
            }
        }
        campaign.contributors.push(msg.sender);
    }

    function getCampaignContributors(
        uint256 _campaignId
    ) public view returns (address[] memory, uint256[] memory) {
        Campaign storage campaign = campaigns[_campaignId];
        uint256[] memory contributionsList = new uint256[](
            campaign.contributors.length
        );
        for (uint256 i = 0; i < campaign.contributors.length; i++) {
            contributionsList[i] = contributions[campaign.contributors[i]][_campaignId];
        }
        return (campaign.contributors, contributionsList);
    }

    function getCampaignContribution(
        uint256 _campaignId
    , address caller) public view returns (uint256) {
        Campaign storage campaign = campaigns[_campaignId];
        return contributions[caller][_campaignId];
    }

    function getCampaign(
        uint256 _campaignId
    )
        public
        view
        returns (
            address,
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            string memory
        )
    {
        Campaign storage campaign = campaigns[_campaignId];
        return (
            campaign.owner,
            campaign.title,
            campaign.description,
            campaign.target,
            campaign.deadline,
            campaign.raised,
            campaign.image
        );
    }

    function getCampaignCount() public view returns (uint256) {
        return campaignCount;
    }

    function getAllCampaigns() public view returns (Campaign[] memory){
        Campaign[] memory _campaigns = new Campaign[](campaignCount);
        for (uint i = 0; i < campaignCount; i++) {
            Campaign storage campaign = campaigns[i];
            _campaigns[i] = campaign;
        }
        return _campaigns;
    }
}
