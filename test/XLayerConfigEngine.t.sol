// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {
    IAaveV3ConfigEngine
} from "aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol";

import {DeploymentLibrary} from "../script/Deploy.s.sol";

contract XLayerConfigEngineParityTest is Test {
    address constant LIVE_ENGINE = 0x2eb21BCE2C5D59a67C648BfD2e700AdDB752DD7B;

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("xLayer"));
    }

    function test_newEngineMatchesLive() public {
        IAaveV3ConfigEngine live = IAaveV3ConfigEngine(LIVE_ENGINE);
        IAaveV3ConfigEngine fresh = IAaveV3ConfigEngine(
            DeploymentLibrary._deployXLayer()
        );

        assertEq(address(fresh.POOL()), address(live.POOL()), "POOL");
        assertEq(
            address(fresh.POOL_CONFIGURATOR()),
            address(live.POOL_CONFIGURATOR()),
            "POOL_CONFIGURATOR"
        );
        assertEq(address(fresh.ORACLE()), address(live.ORACLE()), "ORACLE");
        assertEq(
            fresh.DEFAULT_INTEREST_RATE_STRATEGY(),
            live.DEFAULT_INTEREST_RATE_STRATEGY(),
            "DEFAULT_INTEREST_RATE_STRATEGY"
        );
        assertEq(
            fresh.REWARDS_CONTROLLER(),
            live.REWARDS_CONTROLLER(),
            "REWARDS_CONTROLLER"
        );
        assertEq(fresh.COLLECTOR(), live.COLLECTOR(), "COLLECTOR");
        assertEq(fresh.ATOKEN_IMPL(), live.ATOKEN_IMPL(), "ATOKEN_IMPL");
        assertEq(fresh.VTOKEN_IMPL(), live.VTOKEN_IMPL(), "VTOKEN_IMPL");
    }
}
