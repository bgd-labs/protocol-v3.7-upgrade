// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {IERC20Metadata} from "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import {IPool} from "aave-v3-origin/contracts/interfaces/IPool.sol";
import {IPoolConfigurator} from "aave-v3-origin/contracts/interfaces/IPoolConfigurator.sol";
import {IPoolAddressesProvider} from "aave-v3-origin/contracts/interfaces/IPoolAddressesProvider.sol";
import {ConfiguratorInputTypes} from "aave-v3-origin/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol";
import {EModeConfiguration} from "aave-v3-origin/contracts/protocol/libraries/configuration/EModeConfiguration.sol";
import {ReserveConfiguration as ReserveConfiguration36} from "./3.6/ReserveConfiguration.sol";
import {DataTypes as DataTypes36} from "./3.6/DataTypes.sol";
import {IPoolConfigurator as IPoolConfigurator36} from "./3.6/IPoolConfigurator.sol";
import {IPool as IPool36} from "./3.6/IPool.sol";

/**
 * @title UpgradePayload
 * @notice Upgrade payload to upgrade the Aave v3.5 to v3.6
 * @author BGD Labs
 */
contract UpgradePayload {
  using EModeConfiguration for uint128;
  using ReserveConfiguration36 for DataTypes36.ReserveConfigurationMap;

  struct ConstructorParams {
    IPoolAddressesProvider poolAddressesProvider;
    address poolImpl;
    address poolConfiguratorImpl;
  }

  error WrongAddresses();

  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;
  IPool public immutable POOL;
  IPoolConfigurator public immutable POOL_CONFIGURATOR;

  address public immutable POOL_IMPL;
  address public immutable POOL_CONFIGURATOR_IMPL;

  constructor(ConstructorParams memory params) {
    POOL_ADDRESSES_PROVIDER = params.poolAddressesProvider;

    IPool pool = IPool(params.poolAddressesProvider.getPool());
    POOL = pool;
    POOL_CONFIGURATOR = IPoolConfigurator(params.poolAddressesProvider.getPoolConfigurator());

    if (IPool(params.poolImpl).ADDRESSES_PROVIDER() != params.poolAddressesProvider) {
      revert WrongAddresses();
    }
    POOL_IMPL = params.poolImpl;
    POOL_CONFIGURATOR_IMPL = params.poolConfiguratorImpl;
  }

  function execute() external virtual {
    address[] memory reserves = POOL.getReservesList();
    uint256 length = reserves.length;
    // 1. Cleanup flags that will be removed in the upgrade.
    for (uint256 i = 0; i < length; i++) {
      address reserve = reserves[i];
      DataTypes36.ReserveDataLegacy memory data = IPool36(address(POOL)).getReserveData(reserve);
      if (data.configuration.getDebtCeiling() != 0) {
        IPoolConfigurator36(address(POOL_CONFIGURATOR)).setDebtCeiling(reserve, 0);
      }
      if (data.configuration.getBorrowableInIsolation()) {
        IPoolConfigurator36(address(POOL_CONFIGURATOR)).setBorrowableInIsolation(reserve, false);
      }
    }
    // 2. Upgrade `Pool` implementation.
    POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(POOL_CONFIGURATOR_IMPL);
  }
}
