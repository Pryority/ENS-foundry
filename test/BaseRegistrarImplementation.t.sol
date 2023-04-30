// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.19;

import "ds-test/test.sol";
import "@openzeppelin/token/ERC721/IERC721.sol";
import "../src/BaseRegistrarImplementation.sol";
import "./mocks/MockENSRegistry.sol";

interface TestRegistrar {
    function ownerOf(uint256 tokenId) external view returns (address);

    function tokensOfOwner(
        address owner
    ) external view returns (uint256[] memory);
}

interface TestBaseRegistrar {
    function available(uint256 tokenId) external view returns (bool);

    function isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) external view returns (bool);

    function rentDuration() external view returns (uint256);

    function rentPrice(
        string calldata label,
        uint256 duration
    ) external view returns (uint256);

    function rentExpirationDate(
        uint256 tokenId
    ) external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function mint(uint256 tokenId, address owner, uint256 duration) external;

    function setResolver(address resolver) external;

    function setOwner(address owner) external;

    function setController(address controller) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function renew(uint256 tokenId, uint256 duration) external;
}

interface TestENS {
    function setApprovalForAll(address operator, bool approved) external;

    function setResolver(bytes32 node, address resolver) external;

    function owner(bytes32 node) external view returns (address);

    function resolver(bytes32 node) external view returns (address);

    function ttl(bytes32 node) external view returns (uint64);
}

contract BaseRegistrarTest is DSTest {
    TestRegistrar public registrar;
    TestBaseRegistrar public testBaseRegistrar;
    BaseRegistrarImplementation public baseRegistrar;
    MockENSRegistry public mockENS;
    TestENS public ens;
    IERC721 public token;
    bytes32 public node;
    bytes32 public parentNode;
    bytes32 public baseNode = 0x2e65746800000000000000000000000000000000000000000000000000000000;

    uint256 constant duration = 31536000; // 1 year

    function setUp() public {
        registrar = TestRegistrar(address(this));
        baseRegistrar = new BaseRegistrarImplementation(mockENS, baseNode);
        token = IERC721(address(baseRegistrar));
        ens = TestENS(address(this));
        node = keccak256(abi.encodePacked("test"));
        parentNode = keccak256(abi.encodePacked("eth"));
        ens.setApprovalForAll(address(baseRegistrar), true);
        ens.setResolver(parentNode, address(this));
        ens.setResolver(node, address(this));
    }

    function test_mint() public {
        uint256 price = testBaseRegistrar.rentPrice("test-lala.eth", duration);
        token.approve(address(baseRegistrar), price);
        uint256 balanceBefore = token.balanceOf(address(this));
        testBaseRegistrar.mint(uint256(node), address(this), duration);
        uint256 balanceAfter = token.balanceOf(address(this));
        assertEq(balanceBefore + 1, balanceAfter);
        assertEq(registrar.ownerOf(uint256(node)), address(this));
    }

    function test_mint_not_available() public {
        testBaseRegistrar.mint(uint256(node), address(this), duration);
        token.approve(
            address(baseRegistrar),
            testBaseRegistrar.rentPrice("test-lala.eth", duration)
        );
        baseRegistrar.renew(uint256(node), duration);
        assert(baseRegistrar.available(uint256(node)) == false);
        uint256 balanceBefore = token.balanceOf(address(this));
        (bool success, ) = address(baseRegistrar).call(
            abi.encodeWithSelector(
                testBaseRegistrar.mint.selector,
                uint256(node),
                address(this),
                duration
            )
        );
        assert(success == false);
        uint256 balanceAfter = token.balanceOf(address(this));
        assertEq(balanceBefore, balanceAfter);
        // assertEq(registrar.ownerOf(uint
    }
}
