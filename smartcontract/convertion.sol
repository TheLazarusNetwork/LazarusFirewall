pragma solidity ^0.5.17;

library convert{
    
    /**
     * @dev converts bytes to uint.
     * @param b memory bytes 
     * @return uint 
     * 
     */
    
    function bytesToUint(bytes memory b) public pure returns (uint){
        uint number;
        for(uint i=0;i<b.length;i++){
            number = number + uint(uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }
    
    /**
     * @dev converts uint to bytes
     * @param x uint
     * @return bytes the converted value
     * 
     */
    function toBytes(uint x) public pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
    
    /**
     * @dev converts string to bytes
     * @param s memory string
     * @return bytes the converted value
     *
     */
    function string_tobytes(string memory s) internal pure returns (bytes memory){
        bytes memory b3 = bytes(s);
        return b3;
    }
    
    
    /**
     * @dev converts string to bytes32 
     * @param source memory stringToBytes32
     * @return bytes32 the converted value
     * 
     */
    
    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
    
        assembly {
            result := mload(add(source, 32))
        }
    }
    
    
    /**
     * @dev converts bytes to string
     * @param hw bytes32
     * @return string memory
     * 
     */
    
    function convertingToString(bytes32 hw)internal pure returns(string memory){
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = hw[i];
            }
        return string(bytesArray);
    }
    
    
    /**
     * @dev converting string to uint
     * @param s string memory s, the string that need to be converted to uint
     * @return uint, unsigned integer is returned 
     * 
     */ 
    
    function stringToUint(string memory s) public pure returns(uint){
        bytes memory b = string_tobytes(s);
        return bytesToUint(b);
    }
    
    
    /**
     * @dev  converting unsigned integer to string memory
     * @param x uint, the unsigned integer that need to be converted to string
     * @return string memory, converted value 
     * 
     */
    
    function uintToString(uint x) public pure returns(string memory){
        bytes32 b = bytes32(x);
        return convertingToString(b);
    }
    
    
}
