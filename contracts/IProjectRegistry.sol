/*
    Author:         Ankur Daharwal (@ankurdaharwal)
    File:           IProjectRegistry.sol
    Description:    Project Registry Interface to allocate certified
                    $RENW to projects and allow purchases to buyers
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IProjectRegistry {
    /**
     * @dev Emitted when $RENW is minted
     */
    event MintRENW(
        address indexed projectOwner,
        uint256 indexed projectId,
        uint256 amountInKWH
    );

    /**
     * @dev Emitted when $RENW is minted
     */
    event BurnRENW(
        address indexed buyer,
        uint256 indexed projectId,
        uint256 amountInKWH
    );

    /**
     * @dev Emitted when $RENW is minted
     */
    event PurchaseRENW(
        address indexed buyer,
        uint256 indexed projectId,
        uint256 amountInKWH
    );

    /**
     * @dev Mints $RENW for Reneum certified MWH.
     */
    function mintRENW(uint256 projectId, uint256 amountInKWH)
        external
        returns (bool);

    /**
     * @dev Burns owned $RENW from their wallet balance.
     */
    function burnRENW(uint256 projectId, uint256 amountInKWH)
        external
        returns (bool);

    /**
     * @dev Purchase certified $RENW by a `buyer`.
     */
    function purchaseRENW(uint256 projectId) external payable returns (bool);
}
