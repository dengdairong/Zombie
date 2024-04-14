// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ZombieFactory.sol";
import "./KittyCore.sol";


contract ZombieFeeding is ZombieFactory {
    // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyCore kittyContract;
    function setKittyContractAddress(address _addr) external isOwner {
      kittyContract = KittyCore(_addr);
    }

    function feedAndMultiply(uint _zombieId,uint _targetDna,string memory _species) internal ownerOf(_zombieId){
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie));
        _targetDna %= dnaModulus;
        uint nDna = (_targetDna + myZombie.dna) / 2;
        if(keccak256(bytes("kitty"))==keccak256(bytes(_species))){
            nDna -= nDna % 100 + 99;
        }
        string memory zombieName = string(abi.encodePacked("Noname"));
        _createZombie(zombieName,nDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId,uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna,"kitty");
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
      _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady (Zombie storage _zombie) internal view returns (bool){
      return block.timestamp >= _zombie.readyTime;
    }

    modifier ownerOf(uint _zombieId) {
      require(zombieToOwner[_zombieId] == msg.sender);
      _;
    }
}