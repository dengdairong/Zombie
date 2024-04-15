// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ZombieFeeding.sol";

contract ZombieBattle is ZombieFeeding {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }
    function attack(uint _zombieId,uint _targetId) external ownerOfCheck(_zombieId) {
        Zombie storage myZombir = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);
        if(rand <= attackVictoryProbability){
            myZombir.winCount++;
            myZombir.level++;
            enemyZombie.lossCount++;
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        }else{
            enemyZombie.winCount++;
            myZombir.lossCount++;
            _triggerCooldown(myZombir);
        }
    }
}