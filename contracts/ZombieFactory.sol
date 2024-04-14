// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie{
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    event NewZombie(uint zombieId,string name,uint dna);

    mapping(uint=>address) public zombieToOwner;
    mapping(address=>uint) ownerZombieCount;

    function _createZombie(string memory _name,uint _dna) internal  {
        zombies.push(Zombie(_name,_dna)); 
        zombieToOwner[zombies.length-1] = msg.sender;
        ownerZombieCount[msg.sender] += 1;
        emit NewZombie(zombies.length-1,_name,_dna);
    }

    function _generateRandomDna(string calldata _str) private view  returns (uint) {
        return uint(keccak256(abi.encodePacked(_str))) % dnaModulus;
    }

    function createRandomZombie(string calldata _name) public {
        require(ownerZombieCount[msg.sender]>0,"ERROR");
        _createZombie(_name,_generateRandomDna(_name));
    }

}