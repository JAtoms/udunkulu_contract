// SPDX-License-Identifier: Unlicensed

pragma solidity >=0.8.2 <0.9.0;

contract Udunkulu {
    address owner;
    Royalties[] public royalties;
    Disputes[] public disputes;

    event LogResponse(string addr);

    constructor() {
        owner = msg.sender;
    }

    struct Disputes {
        address creatorAddress;
        bytes32 disputeID;
        string contentUrl;
        string description;
        string email;
        string phoneNumber;
        string[] evidenceUrls;
        bool isResolved;
    }

    struct RoyaltyData {
        string contentCreator;
        string contentName;
        string contentType;
        string contentSummary;
        string samples;
    }

    struct Royalties {
        address creatorAddress;
        bytes32 royaltyID;
        string coverUrl;
        string publicUrl;
        string sampleUrl;
        string remixUrl;
        RoyaltyData royaltyData;
        uint256 publicationDate;
        string[] coOwners;
        bool isVerified;
    }

    // Create a dispute
    function createDispute(
        string memory contentUrl,
        string memory description,
        string memory email,
        string memory phoneNumber,
        string[] memory evidenceUrls
    ) public {
        disputes.push(
            Disputes(
                msg.sender,
                keccak256(abi.encodePacked(msg.sender, block.number)),
                contentUrl,
                description,
                email,
                phoneNumber,
                evidenceUrls,
                false
            )
        );
        returnDisputes();
    }

    // Return disputes
    function returnDisputes() public view returns (Disputes[] memory) {
        return disputes;
    }

    // Resolve a dispute
    function resolveDispute(bytes32 disputeID) public {
        for (uint256 i = 0; i < disputes.length; i++) {
            if (disputes[i].disputeID == disputeID) {
                disputes[i].isResolved = true;
                emit LogResponse("Dispute with ID is resolved");
                returnDisputes();
            }
        }
    }

    // Add a royalty
    function addRoyalty(
        string memory contentName,
        string memory contentCreator,
        string memory contentType,
        string memory contentSummary,
        string memory coverUrl,
        string memory publicUrl,
        string memory sampleUrl,
        string memory remixUrl,
        string memory samples,
        string[] memory coOwners,
        uint256 publicationDate
    ) public {
        royalties.push(
            Royalties(
                msg.sender,
                keccak256(abi.encodePacked(msg.sender, contentSummary)),
                coverUrl,
                publicUrl,
                sampleUrl,
                remixUrl,
                RoyaltyData(
                    contentCreator,
                    contentName,
                    contentType,
                    contentSummary,
                    samples
                ),
                publicationDate,
                coOwners,
                false
            )
        );
        returnRoyalties();
    }

    // Return royalties
    function returnRoyalties() public view returns (Royalties[] memory) {
        return royalties;
    }

    // Resolve a dispute
    function verifyRoyalty(bytes32 royaltyID) public {
        for (uint256 i = 0; i < royalties.length; i++) {
            if (royalties[i].royaltyID == royaltyID) {
                royalties[i].isVerified = true;
                emit LogResponse("Royalty with ID: is verified");
                returnRoyalties();
            }
        }
    }
}
