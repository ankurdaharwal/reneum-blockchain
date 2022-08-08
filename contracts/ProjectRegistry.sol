/*
    Author:         Ankur Daharwal (@ankurdaharwal)
    File:           ProjectRegistry.sol
    Description:    Project Registry to allocate certified
                    $RENW to projects and allow purchases to buyers
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IProjectRegistry.sol";

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/finance/PaymentSplitterUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @custom:security-contact tech@reneum.com
contract ProjectRegistry is
    IProjectRegistry,
    Initializable,
    PausableUpgradeable,
    AccessControlUpgradeable,
    PaymentSplitterUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    mapping(uint256 => uint256) public _inventory;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}

    /**
     * @dev Mints $RENW for Reneum certified MWH.
     */
    function mintRENW(uint256 projectId, uint256 mintAmountInKWH)
        public
        override
        returns (bool mintSuccess)
    {
        require(mintAmountInKWH > 0, "amountInKWH must be a positive number");
        _inventory[projectId] = mintAmountInKWH;
        emit MintRENW(msg.sender, projectId, mintAmountInKWH);
        mintSuccess = true;
    }

    /**
     * @dev Burns owned $RENW from their wallet balance.
     */
    function burnRENW(uint256 projectId, uint256 burnAmountInKWH)
        public
        override
        returns (bool burnSuccess)
    {
        require(burnAmountInKWH > 0, "amountInKWH must be a positive number");
        require(
            burnAmountInKWH <= _inventory[projectId],
            "burnAmountInKWH must not exceed available _inventory"
        );
        _inventory[projectId] -= burnAmountInKWH;
        emit BurnRENW(msg.sender, projectId, burnAmountInKWH);
        burnSuccess = true;
    }

    /**
     * @dev Purchase certified $RENW by a `buyer`.
     */
    function purchaseRENW(uint256 projectId)
        public
        payable
        override
        nonReentrant
        returns (bool purchaseSuccess)
    {
        require(msg.value > 0, "Payment must be a positive number");
        require(projectId > 0, "Project ID is required");
        purchaseSuccess = true;
    }
}
