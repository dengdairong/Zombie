// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
    uint levelUpFee = 0.001 ether;
    modifier aboveLevel(uint _zombieId,uint _level) {
        require(zombies[_zombieId].level >= _level); 
        _;
    }

    function changeName(uint _zombieId,string memory _name) external aboveLevel(_zombieId,2) ownerOf(_zombieId){
        zombies[_zombieId].name = _name;
    }

    function changeDna(uint _zombieId,uint _dna) external aboveLevel(_zombieId,2) ownerOf(_zombieId){
        zombies[_zombieId].dna = _dna;
    }

    function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory rs = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for (uint i = 0;i<zombies.length;i++){
            if(zombieToOwner[i] == _owner){
                rs[counter] = i;
                counter++;
            }
        }
        return rs;
    }

    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    function withdraw() external isOwner {
        address payable _owner = payable(owner);
        _owner.transfer(address(this).balance);
    }

    function setLevelUpFee(uint _fee) external isOwner {
        levelUpFee = _fee;
    }
}