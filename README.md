# Warranty & Product Ownership Tracker

## 📌 Overview

This smart contract, **WarrantyTracker**, allows users to **register products**, **track ownership**, and **check warranty validity** on the blockchain. It provides transparency, security, and decentralized ownership management.

## 🔥 Features

- ✅ **Register products** with a unique serial number and warranty period.
- 🔄 **Transfer ownership** of registered products.
- ⏳ **Check warranty status** to see if a product is still covered.
- 📜 **Publicly accessible product records** (on-chain verification).

## 📜 Smart Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WarrantyTracker {
    struct Product {
        uint256 id;
        string name;
        string serialNumber;
        uint256 warrantyPeriod;
        uint256 purchaseDate;
        address owner;
        bool isRegistered;
    }

    mapping(uint256 => Product) public products;
    mapping(address => uint256[]) public userProducts;
    uint256 public productCount;

    event ProductRegistered(uint256 productId, string name, address owner);
    event OwnershipTransferred(uint256 productId, address newOwner);

    function registerProduct(string memory _name, string memory _serialNumber, uint256 _warrantyPeriod) public {
        productCount++;
        products[productCount] = Product(productCount, _name, _serialNumber, _warrantyPeriod, block.timestamp, msg.sender, true);
        userProducts[msg.sender].push(productCount);
        emit ProductRegistered(productCount, _name, msg.sender);
    }

    function transferOwnership(uint256 _productId, address _newOwner) public {
        require(products[_productId].owner == msg.sender, "Not the owner");
        products[_productId].owner = _newOwner;
        emit OwnershipTransferred(_productId, _newOwner);
    }

    function checkWarranty(uint256 _productId) public view returns (bool) {
        require(products[_productId].isRegistered, "Product not found");
        uint256 expiryDate = products[_productId].purchaseDate + (products[_productId].warrantyPeriod * 1 days);
        return block.timestamp <= expiryDate;
    }

    function getUserProducts(address _user) public view returns (uint256[] memory) {
        return userProducts[_user];
    }
}
```

## 🚀 Deployment Steps

### **Using Remix (Easiest Method)**

1. Open [Remix Ethereum IDE](https://remix.ethereum.org/).
2. Create a new Solidity file (e.g., `WarrantyTracker.sol`) and paste the contract.
3. Compile the contract (**Solidity 0.8.x**).
4. Deploy using **Injected Web3** (connect MetaMask & select network: Goerli/Sepolia/Mainnet).
5. Confirm transaction in MetaMask.

### **Using Hardhat (Advanced Method)**

1. Install dependencies:
   ```sh
   npm init -y
   npm install --save-dev hardhat ethers dotenv
   ```
2. Create a Hardhat project:
   ```sh
   npx hardhat
   ```
3. Compile the contract:
   ```sh
   npx hardhat compile
   ```
4. Deploy using Hardhat scripts.

## 📡 Verify on Etherscan

1. Get your contract address from Remix/Hardhat.
2. Go to [Etherscan](https://etherscan.io/) (or testnet explorer).
3. Click **Verify and Publish**.
4. Select **Solidity (Single file)** and **enter contract details**.
5. Click **Verify & Publish**.

## 🎯 Interacting with the Contract

You can interact using:

- **Etherscan’s UI** (Read & Write functions)
- **Hardhat scripts** (`ethers.js` integration)
- **Web3.js or Ethers.js frontend** (React/Next.js)

## 📝 License

This project is **MIT licensed**.

---


