# Aave V3.7 upgrade process

This document outlines the technical process for upgrading the Aave V3 protocol from version 3.6 to version 3.7 across various networks.

The upgrade is executed via a single `UpgradePayload` contract deployed on each network.

## Core components of the upgrade

1. **New implementations:** New implementations for the `Pool` and `PoolConfigurator` contracts are deployed, incorporating v3.7 features and optimizations.
2. **Upgrade payload:** `UpgradePayload` contains the sequenced steps to orchestrate the upgrade on all networks.
3. **Deployment scripts:** A single Forge script (`Deploy.s.sol`) per chain deterministically deploys the new implementation contracts, the upgrade payload, the `AaveV3ConfigEngine`, and a new `UiPoolDataProviderV3`.

## Pre-upgrade cleanup

Before upgrading the implementations, the payload cleans up reserve configuration flags and settings that are removed in v3.7. For each reserve:

1. **Reset debtCeiling:** If a reserve has a non-zero debt ceiling, it is set to zero via `setDebtCeiling(reserve, 0)`. This also resets `isolationModeTotalDebt` to zero.
2. **Disable borrowableInIsolation:** If a reserve has `borrowableInIsolation` enabled, it is set to false via `setBorrowableInIsolation(reserve, false)`.

Additionally, if a sequencer uptime price oracle sentinel is configured, it is unset via `setPriceOracleSentinel(address(0))`, as this feature is removed in v3.7.

These cleanup steps use the v3.6 interfaces to interact with the pre-upgrade contracts.

## Upgrade sequence

After the cleanup, the payload upgrades the core protocol contracts:

1. **Upgrade Pool implementation:** The `Pool` contract proxy is updated to point to the new v3.7 implementation via `POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL)`.
2. **Upgrade PoolConfigurator implementation:** The `PoolConfigurator` contract proxy is updated to the new v3.7 implementation via `POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(POOL_CONFIGURATOR_IMPL)`.
