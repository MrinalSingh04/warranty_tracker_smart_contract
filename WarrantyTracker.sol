// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title WarrantyTracker
 * @dev A smart contract to register and track product ownership and warranty on the blockchain.
 */
contract WarrantyTracker {
    // Structure to store product details
    struct Product {
        uint256 id; // Unique product ID
        string name; // Product name
        string serialNumber; // Unique serial number of the product
        uint256 warrantyPeriod; // Warranty period in days
        uint256 purchaseDate; // Timestamp of product registration
        address owner; // Current owner of the product
        bool isRegistered; // Status to check if the product is registered
    }

    // Mapping to store product details using product ID
    mapping(uint256 => Product) public products;

    // Counter for product IDs
    uint256 public productCount;

    // Mapping to track products owned by a specific user
    mapping(address => uint256[]) public userProducts;

    // Events to notify front-end and listeners about important actions
    event ProductRegistered(uint256 productId, string name, address owner);
    event OwnershipTransferred(uint256 productId, address newOwner);

    /**
     * @dev Registers a new product on the blockchain.
     * @param _name The name of the product.
     * @param _serialNumber The unique serial number of the product.
     * @param _warrantyPeriod The warranty period in days.
     */
    function registerProduct(
        string memory _name,
        string memory _serialNumber,
        uint256 _warrantyPeriod
    ) public {
        productCount++; // Increment product count to assign a new ID

        // Store the product details in the mapping
        products[productCount] = Product(
            productCount,
            _name,
            _serialNumber,
            _warrantyPeriod,
            block.timestamp,
            msg.sender, // Assign the caller as the owner
            true // Mark as registered
        );

        // Add product ID to the user's list
        userProducts[msg.sender].push(productCount);

        // Emit event for front-end tracking
        emit ProductRegistered(productCount, _name, msg.sender);
    }

    /**
     * @dev Transfers ownership of a product to a new owner.
     * @param _productId The ID of the product.
     * @param _newOwner The address of the new owner.
     */
    function transferOwnership(uint256 _productId, address _newOwner) public {
        // Ensure that the caller is the current owner
        require(products[_productId].owner == msg.sender, "Not the owner");

        // Update the owner of the product
        products[_productId].owner = _newOwner;

        // Emit event for ownership transfer
        emit OwnershipTransferred(_productId, _newOwner);
    }

    /**
     * @dev Checks if a product's warranty is still valid.
     * @param _productId The ID of the product.
     * @return Returns true if the warranty is valid, otherwise false.
     */
    function checkWarranty(uint256 _productId) public view returns (bool) {
        require(products[_productId].isRegistered, "Product not found");

        uint256 expiryDate = products[_productId].purchaseDate +
            (products[_productId].warrantyPeriod * 1 days);

        return block.timestamp <= expiryDate; // Returns true if warranty is still valid
    }

    /**
     * @dev Retrieves all product IDs owned by a specific user.
     * @param _user The address of the user.
     * @return Returns an array of product IDs.
     */
    function getUserProducts(
        address _user
    ) public view returns (uint256[] memory) {
        return userProducts[_user];
    }
}
