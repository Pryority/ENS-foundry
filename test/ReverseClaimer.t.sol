// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "forge-std/Test.sol";
// import "./mocks/MockENSRegistry.sol";
// import "../src/reverseRegistrar/IReverseRegistrar.sol";
// import "../src/registry/ENS.sol";

// contract ReverseClaimerTest is Test {
//     MockENSRegistry public ensRegistry;
//     IReverseRegistrar public reverseRegistrar;
//     address public reverseClaimer;
//     ENS public ens;
//     bytes32 constant ADDR_REVERSE_NODE =
//         0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;

//     function setUp() public {
//         ensRegistry = new MockENSRegistry();
//         reverseRegistrar = IReverseRegistrar(
//             ensRegistry.owner(ADDR_REVERSE_NODE)
//         );
//         reverseClaimer = new ENS.ReverseClaimer(
//             address(ensRegistry),
//             address(this)
//         );
//     }

//     function test_initReverseClaimer() public {
//         reverseClaimer = new ENS.ReverseClaimer(
//             address(ensRegistry),
//             address(this)
//         );
//         assertEq(
//             address(reverseRegistrar.ownerOf(address(this))),
//             address(this),
//             "Owner of reverse name is incorrect"
//         );
//     }
// }
