// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IERC165 {
        /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract GammifyAuction is Ownable {

    event NewAuctionCreated(
        address seller,
        address tokenContract,
        uint startPrice,
        uint tokenId,
        uint buyItNow
    );

    event CancelledAuction(
        address seller,
        address tokenContract,
        uint tokenId
    );

    event AuctionSuccess(
        address token,
        address seller,
        address winner,
        uint id,
        uint price
    );

    event newBid(
        address token,
        address bidder,
        uint tokenId,
        uint amountEther,
        uint timetoExpiry
    );

    /********************Data**********************/

    struct Auction {
        address _seller;
        address _tokenContract;
        address _highestBidder;
        uint _tokenId;
        uint _startPrice;
        uint _highestBid;
        uint _buyitNow;
        bool _open; //prevent malicious auction resets
        uint auctionId;
    }

    struct ActiveAuctions {
        address token;
        uint id;
    }

    ActiveAuctions[] public activeAuctions;
    mapping (address => ActiveAuctions[]) public userAuctions;
    uint internal closedAuctions;

    mapping (address => mapping (uint256 => Auction)) public auctions;
    mapping (address => mapping (uint256 => uint256)) internal bidCreation;
    mapping (address => mapping (uint256 => uint256)) public timetoBidExpiry;
    mapping (address => uint) public withdrawls;

    uint internal counter = 0;

    modifier onlySeller(address token, uint id) {
        require(
            auctions[token][id]._seller == msg.sender
        );
        _;
    }

    modifier onlyBidder(address token, uint id) {
        require(
            auctions[token][id]._highestBidder == msg.sender
        );
        _;
    }


    function createAuction(address token, uint id, uint startPrice, uint buyNow) 
        public {

        address seller = msg.sender;
        require(_owns(token, id, seller), "Non-valid Owner");
        require(!auctions[token][id]._open, "Auction already opened");
        require(buyNow >= 0, "buynow must not be negative");

        Auction memory newAuction = Auction(
            seller,
            token,
            seller, //set seller to highest bidder
            id,
            startPrice,
            uint(0),
            buyNow,
            true,
            counter
        );
        
        if (buyNow > 0) {
            _escrow(seller, token, id);
        }

        ActiveAuctions memory newActiveAuction = ActiveAuctions(
            token,
            id
        );

        activeAuctions.push(newActiveAuction);
        userAuctions[msg.sender].push(newActiveAuction);
        _createAuction(newAuction, token, id);
        emit NewAuctionCreated(msg.sender, token, startPrice, id, buyNow);
        counter += 1;
    }


    function bid(address token, uint id, uint expiry) 
        public payable {
            
        require(msg.value > 0, "Cannot bid 0 ether");
        require(msg.value > auctions[token][id]._startPrice, "Below Start Price");

        _bid(
            msg.value, 
            msg.sender, 
            token, 
            id, 
            expiry //seconds
        );

        emit newBid(
            token,
            msg.sender,
            id,
            msg.value,
            expiry
        );

    }

    function getAuctions() public 
        view
        returns (ActiveAuctions[] memory) {

            uint res;

            ActiveAuctions[] memory aucs = new ActiveAuctions[](activeAuctions.length - closedAuctions);

            for (uint i = 0; i < activeAuctions.length; i++) {
                if (activeAuctions[i].token != address(0)) {
                    aucs[res] = activeAuctions[i];
                    res += 1;
                }
            }

            return aucs;
    }

    function getUserAuctions(address user) public 
        view 
        returns (ActiveAuctions[] memory) {

            ActiveAuctions[] memory aucs = new ActiveAuctions[](userAuctions[user].length);

            for (uint i = 0; i < userAuctions[user].length; i++) {
               aucs[i] = userAuctions[user][i];
            }

        return aucs;

    }


    function cancelAuction(address token, uint id) public onlySeller(token, id) {
        _cancelAuction(token, id);
        emit CancelledAuction(msg.sender, token, id);
    }


    function acceptBid(address token, uint id) public onlySeller(token, id) {

        if (auctions[token][id]._buyitNow == 0) {
            _escrow(msg.sender, token, id);
        }
        _closeAuction(token, id);
        
    }

    function withdrawl() public returns (bool) {

        uint preventRe;
        preventRe = withdrawls[msg.sender];
        withdrawls[msg.sender] = 0;

        payable(msg.sender).transfer(preventRe);
        return true;

    }

    function closeBidandWithdrawl(address token, uint id) 
        public
        onlyBidder(token, id) {

            _expired(token, id);
            withdrawl();

    }

    //extend bid



    /************INTERNAL*****************/
    
    function _escrow(address from, address token, uint id) internal returns (bool) {
        IERC721 nft = IERC721(token);
        nft.safeTransferFrom(from, address(this), id);
        return true;
    }


    function _transfer(address token, address to, uint id) internal {
        IERC721 nft = IERC721(token);
        nft.safeTransferFrom(address(this), to, id);
    }


    function _bid(uint value, address bidder, address token, uint id, uint expiry) internal {

        if (value <= auctions[token][id]._highestBid) {
                revert("Underbid");
        }

        bidCreation[token][id] = block.timestamp;
        timetoBidExpiry[token][id] = expiry;

        withdrawls[auctions[token][id]._highestBidder] += auctions[token][id]._highestBid;
        auctions[token][id]._highestBidder = bidder;
        auctions[token][id]._highestBid = value;

        if (auctions[token][id]._buyitNow > 0) {
            if (value >= auctions[token][id]._buyitNow) {
               _closeAuction(token, id);
            }
        }
    }

    
    function _createAuction(Auction memory auction, address token, uint id) internal {
        auctions[token][id] = auction;
    }


    function _cancelAuction(address token, uint id) internal {
        withdrawls[auctions[token][id]._highestBidder] += auctions[token][id]._highestBid;

        if (auctions[token][id]._buyitNow > 0) {
            _transfer(token, auctions[token][id]._seller, id);
        }

        closedAuctions += 1;
        delete activeAuctions[auctions[token][id].auctionId];
        delete auctions[token][id];
    }


    function _closeAuction(address token, uint id) internal {

        if (_expired(token, id)) {
            revert("Bid Expired!");
        }

        address bidder = auctions[token][id]._highestBidder;

        _transfer(token, bidder, id);
        // setup treasury fees
        withdrawls[auctions[token][id]._seller] += auctions[token][id]._highestBid;

        emit AuctionSuccess(
            token,
            msg.sender,
            auctions[token][id]._highestBidder,
            id,
            auctions[token][id]._highestBid
        );

        closedAuctions += 1;
        delete activeAuctions[auctions[token][id].auctionId];
        delete auctions[token][id];

    }


    function _owns(address token, uint id, address who) internal view returns (bool) {
        IERC721 nft = IERC721(token);
        return (nft.ownerOf(id) == who);
    }

    function _expired(address token, uint id) 
        internal
        returns (bool) {

            uint bidAmount;
            address bidder;

            if (block.timestamp - bidCreation[token][id] >= timetoBidExpiry[token][id]) {
                bidAmount = auctions[token][id]._highestBid;
                bidder = auctions[token][id]._highestBidder;

                auctions[token][id]._highestBidder = auctions[token][id]._seller;
                auctions[token][id]._highestBid = 0;

                withdrawls[bidder] += bidAmount;
                return true;
            } else {
                return false;
            }

    }


    function onERC721Received(address, address, uint256, bytes memory) public pure returns (bytes4) {
        return this.onERC721Received.selector;
    }

}
