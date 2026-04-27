// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {XLayerScript} from "solidity-utils/contracts/utils/ScriptUtils.sol";

import {
    AaveV3ConfigEngine,
    IAaveV3ConfigEngine
} from "aave-v3-origin/contracts/extensions/v3-config-engine/AaveV3ConfigEngine.sol";

import {IPool} from "aave-v3-origin/contracts/interfaces/IPool.sol";
import {
    IPoolAddressesProvider
} from "aave-v3-origin/contracts/interfaces/IPoolAddressesProvider.sol";
import {
    IPoolConfigurator
} from "aave-v3-origin/contracts/interfaces/IPoolConfigurator.sol";
import {IAaveOracle} from "aave-v3-origin/contracts/interfaces/IAaveOracle.sol";

import {AaveV3XLayer} from "aave-address-book/AaveV3XLayer.sol";

library DeploymentLibrary {
    address constant USDT_INTEREST_RATE_STRATEGY = 0x3eFfeBDD435217A8B485dfaEFDecf766F2a3c05B;
    address constant ATOKEN_IMPL = 0x384c8C9e2A201975b2ef3415b96d2204826034ae;
    address constant VTOKEN_IMPL = 0xF9e48edc704BDF494309cA457BCea4c0696f591d;

    struct DeployParameters {
        address poolAddressesProvider;
        address pool;
        address interestRateStrategy;
        address rewardsController;
        address treasury;
        address uiPoolDataProvider;
    }

    function _deployL2(
        DeployParameters memory deployParams
    ) internal returns (address) {
        return _deployPayload(deployParams);
    }

    function _deployPayload(
        DeployParameters memory deployParams
    ) private returns (address) {
        return _deployConfigEngine(deployParams);
    }

    function _deployXLayer() internal returns (address) {
        DeployParameters memory deployParams;

        deployParams.pool = address(AaveV3XLayer.POOL);
        deployParams.poolAddressesProvider = address(
            AaveV3XLayer.POOL_ADDRESSES_PROVIDER
        );
        deployParams.interestRateStrategy = USDT_INTEREST_RATE_STRATEGY;
        deployParams.rewardsController = AaveV3XLayer
            .DEFAULT_INCENTIVES_CONTROLLER;
        deployParams.treasury = address(AaveV3XLayer.COLLECTOR);
        deployParams.uiPoolDataProvider = AaveV3XLayer.UI_POOL_DATA_PROVIDER;

        return _deployL2(deployParams);
    }

    function _deployConfigEngine(
        DeployParameters memory deployParams
    ) private returns (address) {
        IAaveV3ConfigEngine.EngineConstants
            memory engineConstants = IAaveV3ConfigEngine.EngineConstants({
                pool: IPool(deployParams.pool),
                poolConfigurator: IPoolConfigurator(
                    IPoolAddressesProvider(deployParams.poolAddressesProvider)
                        .getPoolConfigurator()
                ),
                defaultInterestRateStrategy: deployParams.interestRateStrategy,
                oracle: IAaveOracle(
                    IPoolAddressesProvider(deployParams.poolAddressesProvider)
                        .getPriceOracle()
                ),
                rewardsController: deployParams.rewardsController,
                collector: deployParams.treasury
            });

        return address(
            new AaveV3ConfigEngine(ATOKEN_IMPL, VTOKEN_IMPL, engineConstants)
        );
    }
}

contract DeployxLayer is XLayerScript {
    function run() external broadcast {
        DeploymentLibrary._deployXLayer();
    }
}
