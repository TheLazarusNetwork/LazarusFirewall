pragma solidity ^0.5.17;


import "./convertion.sol";
import "./removeIndex.sol";
import "./ArrayUtils.sol";

contract blacklist_domain{
    
    using convert for string;
    using convert for bytes32;
    using removeIndex for uint256[];
    using Array256Lib for uint256[];
    
    struct Domains{
        string _domain;
    }
    
    struct DomainIndex{
        uint _index;
    }
    
    struct BlackList{
        uint256[] _indexes;
    }
    
    Domains[] domainList;
    mapping(string => DomainIndex) Index;
    mapping(address => BlackList) blacklist;
    
    function domainPresent (string calldata _domainName) external view returns(uint){
        return Index[_domainName]._index;
    }
    
    function createDomainList(string calldata _domainName) external returns(bool){
     
        require(Index[_domainName]._index == 0);
        domainList.length++;
        domainList[domainList.length-1]._domain = _domainName;
        Index[_domainName]._index = domainList.length-1;
        return true;
        
    }
    
    
    function getDomain(uint _index) external view returns(string memory){
        return domainList[_index]._domain;
    }
    
    function getDomainList() external view returns(uint){
       return domainList.length-1;
    }
    
    function convertToString(bytes32 _domain) external pure returns(string memory){
        return _domain.convertingToString();
    }
    
    function storingBlackList(uint256 _index) external returns(bool){
        blacklist[msg.sender]._indexes.push(_index);
    }
    
    function getBlackListDomain(address _address) external view returns(uint[] memory){
        require(blacklist[_address]._indexes.length > 0);
        // bytes32 [] memory _blacklistdomain;
        
        // for (uint i = 0 ; i <= blacklist[_address]._indexes.length ; i++){
        //     _blacklistdomain[i] = domainList[blacklist[_address]._indexes[i]]._domain.stringToBytes32();
        // }
        return blacklist[_address]._indexes;
        
    }
    
    function removeFromBlackList(string calldata _domainName) external  returns(bool){
        require(blacklist[msg.sender]._indexes.length > 0);
        bool found;
        uint256 index;
        (found, index) = blacklist[msg.sender]._indexes.indexOf(Index[_domainName]._index, true);
        require(found == true);
        bool flag = blacklist[msg.sender]._indexes.removeByIndex(index);
        return flag;
        
    }
    
}