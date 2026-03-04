// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {
  EthereumScript,
  PolygonScript,
  AvalancheScript,
  OptimismScript,
  ArbitrumScript,
  MetisScript,
  BaseScript,
  GnosisScript,
  ScrollScript,
  BNBScript,
  LineaScript,
  SonicScript,
  CeloScript,
  SoneiumScript,
  InkScript,
  PlasmaScript,
  MantleScript,
  MegaEthScript
} from "solidity-utils/contracts/utils/ScriptUtils.sol";

import {GovV3Helpers} from "aave-helpers/src/GovV3Helpers.sol";

import {
  AaveV3ConfigEngine,
  IAaveV3ConfigEngine,
  CapsEngine,
  BorrowEngine,
  CollateralEngine,
  RateEngine,
  PriceFeedEngine,
  EModeEngine,
  ListingEngine
} from "aave-v3-origin/contracts/extensions/v3-config-engine/AaveV3ConfigEngine.sol";
import {Create2Utils} from "aave-v3-origin/deployments/contracts/utilities/Create2Utils.sol";

import {PoolConfiguratorInstance} from "aave-v3-origin/contracts/instances/PoolConfiguratorInstance.sol";
import {PoolInstance} from "aave-v3-origin/contracts/instances/PoolInstance.sol";
import {L2PoolInstance} from "aave-v3-origin/contracts/instances/L2PoolInstance.sol";
import {ATokenInstance} from "aave-v3-origin/contracts/instances/ATokenInstance.sol";
import {VariableDebtTokenInstance} from "aave-v3-origin/contracts/instances/VariableDebtTokenInstance.sol";
import {ATokenWithDelegationInstance} from "aave-v3-origin/contracts/instances/ATokenWithDelegationInstance.sol";
import {
  VariableDebtTokenMainnetInstanceGHO
} from "aave-v3-origin/contracts/instances/VariableDebtTokenMainnetInstanceGHO.sol";

import {IPool} from "aave-v3-origin/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "aave-v3-origin/contracts/interfaces/IPoolAddressesProvider.sol";
import {IPoolConfigurator} from "aave-v3-origin/contracts/interfaces/IPoolConfigurator.sol";
import {IAaveOracle} from "aave-v3-origin/contracts/interfaces/IAaveOracle.sol";
import {UiPoolDataProviderV3} from "aave-v3-origin/contracts/helpers/UiPoolDataProviderV3.sol";
import {AggregatorInterface} from "aave-v3-origin/contracts/dependencies/chainlink/AggregatorInterface.sol";

import {AaveV3Polygon, AaveV3PolygonAssets} from "aave-address-book/AaveV3Polygon.sol";
import {AaveV3Avalanche, AaveV3AvalancheAssets} from "aave-address-book/AaveV3Avalanche.sol";
import {AaveV3Optimism, AaveV3OptimismAssets} from "aave-address-book/AaveV3Optimism.sol";
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from "aave-address-book/AaveV3Arbitrum.sol";
import {AaveV3Ethereum, AaveV3EthereumAssets} from "aave-address-book/AaveV3Ethereum.sol";
import {AaveV3BNB, AaveV3BNBAssets} from "aave-address-book/AaveV3BNB.sol";
import {AaveV3Gnosis, AaveV3GnosisAssets} from "aave-address-book/AaveV3Gnosis.sol";
import {AaveV3Scroll, AaveV3ScrollAssets} from "aave-address-book/AaveV3Scroll.sol";
import {AaveV3Base, AaveV3BaseAssets} from "aave-address-book/AaveV3Base.sol";
import {AaveV3Metis, AaveV3MetisAssets} from "aave-address-book/AaveV3Metis.sol";
import {AaveV3EthereumLido, AaveV3EthereumLidoAssets} from "aave-address-book/AaveV3EthereumLido.sol";
import {AaveV3EthereumEtherFi, AaveV3EthereumEtherFiAssets} from "aave-address-book/AaveV3EthereumEtherFi.sol";
import {AaveV3Linea, AaveV3LineaAssets} from "aave-address-book/AaveV3Linea.sol";
import {AaveV3Sonic, AaveV3SonicAssets} from "aave-address-book/AaveV3Sonic.sol";
import {AaveV3Celo, AaveV3CeloAssets} from "aave-address-book/AaveV3Celo.sol";
import {AaveV3Soneium, AaveV3SoneiumAssets} from "aave-address-book/AaveV3Soneium.sol";
import {AaveV3InkWhitelabel, AaveV3InkWhitelabelAssets} from "aave-address-book/AaveV3InkWhitelabel.sol";
import {AaveV3Plasma, AaveV3PlasmaAssets} from "aave-address-book/AaveV3Plasma.sol";
import {AaveV3Mantle, AaveV3MantleAssets} from "aave-address-book/AaveV3Mantle.sol";
import {AaveV3MegaEth, AaveV3MegaEthAssets} from "aave-address-book/AaveV3MegaEth.sol";

import {UpgradePayload} from "../src/UpgradePayload.sol";

library DeploymentLibrary {
  struct DeployParameters {
    address poolAddressesProvider;
    address pool;
    address interestRateStrategy;
    address rewardsController;
    address treasury;
    address uiPoolDataProvider;
  }
  // rollups

  function _deployOptimism() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Optimism.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Optimism.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3OptimismAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Optimism.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Optimism.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Optimism.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  function _deployBase() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Base.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Base.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3BaseAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Base.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Base.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Base.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  function _deployArbitrum() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Arbitrum.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3ArbitrumAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Arbitrum.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Arbitrum.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Arbitrum.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  function _deployInk() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3InkWhitelabel.POOL);
    deployParams.poolAddressesProvider = address(AaveV3InkWhitelabel.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3InkWhitelabelAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3InkWhitelabel.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3InkWhitelabel.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3InkWhitelabel.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  function _deployPlasma() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Plasma.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Plasma.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3PlasmaAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Plasma.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Plasma.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Plasma.UI_POOL_DATA_PROVIDER;

    return _deployL1(deployParams);
  }

  function _deployScroll() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Scroll.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Scroll.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3ScrollAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Scroll.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Scroll.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Scroll.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  function _deployMetis() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Metis.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Metis.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3MetisAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Metis.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Metis.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Metis.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  // L1s
  function _deployMainnetCore() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Ethereum.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Ethereum.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3EthereumAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Ethereum.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Ethereum.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Ethereum.UI_POOL_DATA_PROVIDER;

    return _deployMainnetCore(deployParams);
  }

  function _deployMainnetLido() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3EthereumLido.POOL);
    deployParams.poolAddressesProvider = address(AaveV3EthereumLido.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3EthereumLidoAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3EthereumLido.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3EthereumLido.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3EthereumLido.UI_POOL_DATA_PROVIDER;

    return _deployL1(deployParams);
  }

  function _deployMainnetEtherfi() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3EthereumEtherFi.POOL);
    deployParams.poolAddressesProvider = address(AaveV3EthereumEtherFi.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3EthereumEtherFiAssets.FRAX_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3EthereumEtherFi.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3EthereumEtherFi.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3EthereumEtherFi.UI_POOL_DATA_PROVIDER;

    return _deployL1(deployParams);
  }

  function _deployGnosis() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Gnosis.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Gnosis.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3GnosisAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Gnosis.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Gnosis.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Gnosis.UI_POOL_DATA_PROVIDER;

    return _deployL1(deployParams);
  }

  function _deployBNB() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3BNB.POOL);
    deployParams.poolAddressesProvider = address(AaveV3BNB.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3BNBAssets.ETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3BNB.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3BNB.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3BNB.UI_POOL_DATA_PROVIDER;

    return _deployL1(deployParams);
  }

  function _deployAvalanche() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Avalanche.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Avalanche.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3AvalancheAssets.WETHe_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Avalanche.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Avalanche.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Avalanche.UI_POOL_DATA_PROVIDER;

    return _deployL1(deployParams);
  }

  function _deployPolygon() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Polygon.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Polygon.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3PolygonAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Polygon.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Polygon.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Polygon.UI_POOL_DATA_PROVIDER;

    return _deployL1(deployParams);
  }

  function _deployLinea() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Linea.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Linea.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3LineaAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Linea.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Linea.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Linea.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  function _deploySonic() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Sonic.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Sonic.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3SonicAssets.WETH_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Sonic.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Sonic.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Sonic.UI_POOL_DATA_PROVIDER;

    return _deployL1(deployParams);
  }

  function _deployCelo() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Celo.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Celo.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3CeloAssets.CELO_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Celo.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Celo.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Celo.UI_POOL_DATA_PROVIDER;

    return _deployL1(deployParams);
  }

  function _deploySoneium() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Soneium.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Soneium.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(AaveV3SoneiumAssets.USDT_INTEREST_RATE_STRATEGY);
    deployParams.rewardsController = AaveV3Soneium.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Soneium.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Soneium.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  function _deployL2(DeployParameters memory deployParams) internal returns (address) {
    UpgradePayload.ConstructorParams memory payloadParams;

    payloadParams.poolAddressesProvider = IPoolAddressesProvider(deployParams.poolAddressesProvider);
    payloadParams.poolImpl = GovV3Helpers.deployDeterministic(
      type(L2PoolInstance).creationCode,
      abi.encode(deployParams.poolAddressesProvider, deployParams.interestRateStrategy)
    );

    return _deployPayload(deployParams, payloadParams, false);
  }

  function _deployL1(DeployParameters memory deployParams) internal returns (address) {
    UpgradePayload.ConstructorParams memory payloadParams;

    payloadParams.poolAddressesProvider = IPoolAddressesProvider(deployParams.poolAddressesProvider);
    payloadParams.poolImpl = GovV3Helpers.deployDeterministic(
      type(PoolInstance).creationCode, abi.encode(deployParams.poolAddressesProvider, deployParams.interestRateStrategy)
    );

    return _deployPayload({deployParams: deployParams, payloadParams: payloadParams, isMainnetCore: false});
  }

  function _deployMainnetCore(DeployParameters memory deployParams) internal returns (address) {
    UpgradePayload.ConstructorParams memory payloadParams;

    payloadParams.poolAddressesProvider = IPoolAddressesProvider(deployParams.poolAddressesProvider);
    payloadParams.poolImpl = GovV3Helpers.deployDeterministic(
      type(PoolInstance).creationCode, abi.encode(deployParams.poolAddressesProvider, deployParams.interestRateStrategy)
    );

    return _deployPayload({deployParams: deployParams, payloadParams: payloadParams, isMainnetCore: true});
  }

  function _deployPayload(
    DeployParameters memory deployParams,
    UpgradePayload.ConstructorParams memory payloadParams,
    bool isMainnetCore
  ) private returns (address) {
    payloadParams.poolConfiguratorImpl = GovV3Helpers.deployDeterministic(type(PoolConfiguratorInstance).creationCode);

    payloadParams.aTokenImpl = GovV3Helpers.deployDeterministic(
      type(ATokenInstance).creationCode,
      abi.encode(deployParams.pool, deployParams.rewardsController, deployParams.treasury)
    );

    payloadParams.vTokenImpl = GovV3Helpers.deployDeterministic(
      type(VariableDebtTokenInstance).creationCode, abi.encode(deployParams.pool, deployParams.rewardsController)
    );

    _deployConfigEngine(deployParams);
    _deployUiPoolDataProvider(deployParams);

    return GovV3Helpers.deployDeterministic(type(UpgradePayload).creationCode, abi.encode(payloadParams));
  }

  function _deployUiPoolDataProvider(DeployParameters memory deployParams) private {
    UiPoolDataProviderV3 existing = UiPoolDataProviderV3(deployParams.uiPoolDataProvider);
    new UiPoolDataProviderV3(
      existing.networkBaseTokenPriceInUsdProxyAggregator(),
      existing.marketReferenceCurrencyPriceInUsdProxyAggregator()
    );
  }

  function _deployMantle() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3Mantle.POOL);
    deployParams.poolAddressesProvider = address(AaveV3Mantle.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(0x0a215D8ba66387DCA84B284D18c3B4ec3de6E54a);
    deployParams.rewardsController = AaveV3Mantle.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3Mantle.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3Mantle.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  function _deployMegaEth() internal returns (address) {
    DeployParameters memory deployParams;

    deployParams.pool = address(AaveV3MegaEth.POOL);
    deployParams.poolAddressesProvider = address(AaveV3MegaEth.POOL_ADDRESSES_PROVIDER);
    deployParams.interestRateStrategy = address(0x5cC4f782cFe249286476A7eFfD9D7bd215768194);
    deployParams.rewardsController = AaveV3MegaEth.DEFAULT_INCENTIVES_CONTROLLER;
    deployParams.treasury = address(AaveV3MegaEth.COLLECTOR);
    deployParams.uiPoolDataProvider = AaveV3MegaEth.UI_POOL_DATA_PROVIDER;

    return _deployL2(deployParams);
  }

  function _deployConfigEngine(DeployParameters memory deployParams) private {
    IAaveV3ConfigEngine.EngineLibraries memory engineLibraries =
      IAaveV3ConfigEngine.EngineLibraries({
        listingEngine: Create2Utils._create2Deploy("v1", type(ListingEngine).creationCode),
        eModeEngine: Create2Utils._create2Deploy("v1", type(EModeEngine).creationCode),
        borrowEngine: Create2Utils._create2Deploy("v1", type(BorrowEngine).creationCode),
        collateralEngine: Create2Utils._create2Deploy("v1", type(CollateralEngine).creationCode),
        priceFeedEngine: Create2Utils._create2Deploy("v1", type(PriceFeedEngine).creationCode),
        rateEngine: Create2Utils._create2Deploy("v1", type(RateEngine).creationCode),
        capsEngine: Create2Utils._create2Deploy("v1", type(CapsEngine).creationCode)
      });

    IAaveV3ConfigEngine.EngineConstants memory engineConstants = IAaveV3ConfigEngine.EngineConstants({
      pool: IPool(deployParams.pool),
      poolConfigurator: IPoolConfigurator(IPoolAddressesProvider(deployParams.poolAddressesProvider).getPoolConfigurator()),
      defaultInterestRateStrategy: deployParams.interestRateStrategy,
      oracle: IAaveOracle(IPoolAddressesProvider(deployParams.poolAddressesProvider).getPriceOracle()),
      rewardsController: deployParams.rewardsController,
      collector: deployParams.treasury
    });

    new AaveV3ConfigEngine(
      GovV3Helpers.deployDeterministic(
        type(ATokenInstance).creationCode, abi.encode(deployParams.pool, deployParams.rewardsController, deployParams.treasury)
      ),
      GovV3Helpers.deployDeterministic(
        type(VariableDebtTokenInstance).creationCode, abi.encode(deployParams.pool, deployParams.rewardsController)
      ),
      engineConstants,
      engineLibraries
    );
  }
}

contract Deploypolygon is PolygonScript {
  function run() external broadcast {
    DeploymentLibrary._deployPolygon();
  }
}

contract Deploygnosis is GnosisScript {
  function run() external broadcast {
    DeploymentLibrary._deployGnosis();
  }
}

contract Deployoptimism is OptimismScript {
  function run() external broadcast {
    DeploymentLibrary._deployOptimism();
  }
}

contract Deployarbitrum is ArbitrumScript {
  function run() external broadcast {
    DeploymentLibrary._deployArbitrum();
  }
}

contract Deployavalanche is AvalancheScript {
  function run() external broadcast {
    DeploymentLibrary._deployAvalanche();
  }
}

contract Deploybase is BaseScript {
  function run() external broadcast {
    DeploymentLibrary._deployBase();
  }
}

contract Deployscroll is ScrollScript {
  function run() external broadcast {
    DeploymentLibrary._deployScroll();
  }
}

contract Deploybnb is BNBScript {
  function run() external broadcast {
    DeploymentLibrary._deployBNB();
  }
}

// metis is broken
contract Deploymetis is MetisScript {
  function run() external broadcast {
    DeploymentLibrary._deployMetis();
  }
}

contract Deploymainnet is EthereumScript {
  function run() external broadcast {
    DeploymentLibrary._deployMainnetCore();
  }
}

contract Deploylido is EthereumScript {
  function run() external broadcast {
    DeploymentLibrary._deployMainnetLido();
  }
}

contract Deployetherfi is EthereumScript {
  function run() external broadcast {
    DeploymentLibrary._deployMainnetEtherfi();
  }
}

contract Deploylinea is LineaScript {
  function run() external broadcast {
    DeploymentLibrary._deployLinea();
  }
}

contract Deploysonic is SonicScript {
  function run() external broadcast {
    DeploymentLibrary._deploySonic();
  }
}

contract Deploycelo is CeloScript {
  function run() external broadcast {
    DeploymentLibrary._deployCelo();
  }
}

contract Deploysoneium is SoneiumScript {
  function run() external broadcast {
    DeploymentLibrary._deploySoneium();
  }
}

contract Deployink is InkScript {
  function run() external broadcast {
    DeploymentLibrary._deployInk();
  }
}

contract Deployplasma is PlasmaScript {
  function run() external broadcast {
    DeploymentLibrary._deployPlasma();
  }
}

contract Deploymantle is MantleScript {
  function run() external broadcast {
    DeploymentLibrary._deployMantle();
  }
}

contract Deploymegaeth is MegaEthScript {
  function run() external broadcast {
    DeploymentLibrary._deployMegaEth();
  }
}
