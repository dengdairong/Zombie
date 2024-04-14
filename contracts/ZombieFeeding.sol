// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ZombieFactory.sol";

abstract contract KittyInterface {
  function getKitty(uint256 _id) external view virtual returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);

    function feedAndMultiply(uint _zombieId,uint _targetDna,string memory _species) public {
        require(zombieToOwner[_zombieId]!=msg.sender);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna %= dnaModulus;
        uint nDna = (_targetDna + myZombie.dna) / 2;
        if(keccak256(bytes("kitty"))==keccak256(bytes(_species))){
            nDna -= nDna % 100 + 99;
        }
        string memory zombieName = string(abi.encodePacked("Noname"));
        _createZombie(zombieName,nDna);
    }

    function feedOnKitty(uint _zombieId,uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna,"kitty");
    }
}