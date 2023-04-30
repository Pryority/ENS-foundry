// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import "../src/ETHRegistrarController.sol";
// import "../src/IPriceOracle.sol";

// contract ETHRegistrarControllerTest is Test {
//     ETHRegistrarController public registrarController;

//     ENS public ens;

//     function setUp() public {
//         BaseRegistrarImplementation base = new BaseRegistrarImplementation(
//             ens,
//             bytes32(0)
//         );

//         IPriceOracle prices = new IPriceOracle();
//         ReverseRegistrar reverseRegistrar = new ReverseRegistrar(
//             base,
//             address(0),
//             bytes32(0)
//         );

//         INameWrapper nameWrapper = new INameWrapper();

//         registrarController = new ETHRegistrarController(
//             base,
//             prices,
//             0,
//             100,
//             reverseRegistrar,
//             nameWrapper,
//             ENS(0)
//         );
//     }

//     function testRentPrice() public {
//         IPriceOracle.Price memory price = registrarController.rentPrice(
//             "testname",
//             30 days
//         );
//         assert(price.cost == 100);
//     }

//     function testValid() public {
//         bool valid = registrarController.valid("abc");
//         assert(valid == true);
//     }

//     function testInvalid() public {
//         bool valid = registrarController.valid("a");
//         assert(valid == false);
//     }

//     function testAvailable() public {
//         bool available = registrarController.available("testname");
//         assert(available == true);
//     }

//     function testUnavailable() public {
//         BaseRegistrarImplementation base = registrarController.base();
//         bytes32 label = keccak256(bytes("testname"));
//         base.register(uint256(label), address(this), 0);
//         bool available = registrarController.available("testname");
//         assert(available == false);
//     }

//     function testMakeCommitment() public {
//         bytes32 commitment = registrarController.makeCommitment(
//             "testname",
//             address(this),
//             30 days,
//             bytes32(0),
//             address(0),
//             new bytes[](0),
//             false,
//             0
//         );
//         assert(commitment != bytes32(0));
//     }

//     function testCommit() public {
//         bytes32 commitment = registrarController.makeCommitment(
//             "testname",
//             address(this),
//             30 days,
//             bytes32(0),
//             address(0),
//             new bytes[](0),
//             false,
//             0
//         );
//         registrarController.commit(commitment);
//         uint256 blockTimestamp = block.timestamp;
//         assert(
//             registrarController.commitments(commitment) >= blockTimestamp &&
//                 registrarController.commitments(commitment) <=
//                 blockTimestamp + 100
//         );
//     }
// }
