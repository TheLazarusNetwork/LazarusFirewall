pragma solidity ^0.5.17;

library removeIndex{
    

    
    function find(uint256[] memory values, uint value) public pure returns(uint) {
        uint i = 0;
        while (values[i] != value) {
            i++;
        }
        return i;
    }
    
    
    function removeByValue(uint256[] storage values, uint value) public{
        uint i = find(values, value);
        removeByIndex(values, i);
    }
    
    
    function removeByIndex(uint256[] storage values, uint i) public returns(bool){
        while (i<values.length-1) {
            values[i] = values[i+1];
            i++;
        }
        values.length--;
        return true;
    }
    
     function getValues(uint256[] memory values) internal pure returns(uint[] memory) {
        return values;
    }

    
}
