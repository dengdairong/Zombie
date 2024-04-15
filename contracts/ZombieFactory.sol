// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./2_Owner.sol";
import "./SafeMath.sol";

contract ZombieFactory is Owner {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie{
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    event NewZombie(uint zombieId,string name,uint dna);

    mapping(uint=>address) public zombieToOwner;
    mapping(address=>uint) public ownerZombieCount;

    function _createZombie(string memory _name,uint _dna) internal  {
        zombies.push(Zombie(_name,_dna,1,uint32(block.timestamp + cooldownTime),0,0)); 
        zombieToOwner[zombies.length-1] = msg.sender;
        ownerZombieCount[msg.sender] += 1;
        emit NewZombie(zombies.length-1,_name,_dna);
    }

    function _generateRandomDna(string calldata _str) private view  returns (uint) {
        return uint(keccak256(abi.encodePacked(_str))) % dnaModulus;
    }

    function createRandomZombie(string calldata _name) public {
        require(ownerZombieCount[msg.sender] == 0,"ERROR");
        _createZombie(_name,_generateRandomDna(_name));
    }

}