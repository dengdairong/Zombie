// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ZombieBattle.sol";
import "./ERC721.sol";
import "./SafeMath.sol";

contract ZombieOwnership is ZombieBattle,ERC721 {
    using SafeMath for uint256;

    function balanceOf(address _owner) override public view returns (uint256 _balance) {
        return ownerZombieCount[_owner];
    }
    function ownerOf(uint256 _tokenId) override public view returns (address _owner) {
        return zombieToOwner[_tokenId];
    }
    function transfer(address _to, uint256 _tokenId) override public ownerOfCheck(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }
    
    function _transfer(address _from,address _to,uint256 _tokenId) private {
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from,_to,_tokenId);
    }
    mapping(uint=>address) zombieApprovals;
    function approve(address _to, uint256 _tokenId) override public  ownerOfCheck(_tokenId) {
        zombieApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }
    function takeOwnership(uint256 _tokenId) override public {
        require(zombieApprovals[_tokenId] == msg.sender);
        _transfer(ownerOf(_tokenId),msg.sender,_tokenId);
    }
}