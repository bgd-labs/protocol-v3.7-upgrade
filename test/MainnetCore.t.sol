// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from "aave-address-book/AaveV3Ethereum.sol";
import {IATokenWithDelegation} from "aave-v3-origin/contracts/interfaces/IATokenWithDelegation.sol";
import {
  VariableDebtTokenMainnetInstanceGHO
} from "aave-v3-origin/contracts/instances/VariableDebtTokenMainnetInstanceGHO.sol";

import {DeploymentLibrary} from "../script/Deploy.s.sol";

import {Deployments} from "../src/Deployments.sol";

import {UpgradeTest} from "./UpgradeTest.t.sol";

contract MainnetCoreTest is UpgradeTest("mainnet", 24677635) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployMainnetCore();
  }

  function _getDeployedPayload() internal virtual override returns (address) {
    return Deployments.MAINNET_CORE;
  }
}
