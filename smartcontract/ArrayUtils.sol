pragma solidity ^0.5.17;


/**
 * @title Array256 library
 * 
 * The Array256 Library provides a few utility functions to work with 
 * storage uint256 [] types in place
 * 
 */


library Array256Lib{
    
    /**
     * @dev Sum vector
     * @param self storage array containing uint256 type variables
     * @return sum The sum of all elements, does not check the overflow
     * 
     */
    
    function sumElements(uint256[] storage self) public view returns(uint256 sum){
        assembly {
            mstore(0x60, self_slot)
            
            for {let i := 0} lt(i, sload(self_slot)) {i := add(i, 1)}{
                sum := add(sload(add(keccak256(0x60, 0x20), i)), sum)
            }
        }
    }
    
    
    
    /// @dev Returns the maxmimum value in an array
    /// @param self Storage array containing uint256 type variables
    /// @return maxValue The highest value in the array
     
    function getMax(uint256[] storage self) public view returns(uint256 maxValue){
        assembly {
            mstore(0x60, self_slot)
            maxValue := sload(keccak256(0x60, 0x20))
            
            for {let i := 0} lt(i, sload(self_slot)) {i := add(i, 1)} {
                switch gt(sload(add(keccak256(0x60, 0x20), i)), maxValue)
                case 1{
                    maxValue := sload(add(keccak256(0x60, 0x20), i))
                }
            }
        }
    }
    
    
    
    /**
     * @dev Returns the minimum value in an array
     * @param self Storage array containing uint256 type variables
     * @return minValue The lowest value in the array
     * 
     */
    
    function getMin(uint256[] storage self) public view returns(uint256 minValue){
        assembly {
            mstore(0x60, self_slot)
            minValue := sload(keccak256(0x60, 0x20))
            
            for {let i := 0} lt(i, sload(self_slot)) {i := add(i, 1)} {
                switch gt(sload(add(keccak256(0x60, 0x20), i)), minValue)
                case 1{
                    minValue := sload(add(keccak256(0x60, 0x20), i))
                }
            }
        }
    }
    
    /**
     * @dev Find the index of the given value in an array
     * @param self storage array containing uint256 type variables
     * @param value The value to search for
     * @param isSorted True if the array is sorted, false otherwise
     * @return found True if the value was found, false otherwise
     * @return index, The Index of the given value, returns 0 if found is false
     * 
     */
    
    function indexOf(uint256[] storage self, uint256 value, bool isSorted)  public view returns(bool found , uint256 index){
        assembly{
            mstore(0x60, self_slot)
            switch isSorted
            
            case 1 {
                let high := sub(sload(self_slot), 1)
                let mid := 0
                let low := 0
                
                for { } iszero(gt(low, high)) { }{
                    mid := div(add(low, high), 2)
                     
                    switch lt(sload(add(keccak256(0x60, 0x20), mid)), value)
                    
                    case 1{
                        low := add(mid,1)
                    }
                    case 0 {
                        switch gt(sload(add(keccak256(0x60, 0x20), mid)), value)
                        case 1 {
                            high := sub(mid, 1)
                        }
                        case 0 {
                            found := 1
                            index := mid
                            low := add(high,1)
                        }
                    }
                }
            }
            
            case 0 {
                for { let low := 0 } lt(low, sload(self_slot)) {low := add(low, 1)} {
                    switch eq(sload(add(keccak256(0x60, 0x20), low)), value)
                    case 1 {
                        found := 1
                        index := low
                        low := sload(self_slot)
                    }
                }
            }
        }
    }
    
    
    /**
     * @dev utility function for heapSort
     * @param index The index of the child node
     * @return pI The parent node index
     * 
     */
    function getParentI(uint256 index) private pure returns(uint256 pI){
        uint256 i = index - 1;
        pI = i/2;
    }
    
    
    /**
     * @dev utility function for heapsort
     * @param index The index of parent node
     * @return lcI The index of left child
     * 
     */
    function getLeftChildI(uint256 index) private pure returns (uint256 lcI){
        uint256 i = index * 2;
        lcI = i + 1;
    }
    
    
    /**
     * @dev Sort given array in place
     * @param self Storage array containing uint256 type variables
     *
     */
    function heapSort(uint256[] storage self) public {
        uint256 end = self.length - 1;
        uint256 start = getParentI(end);
        uint256 root = start;
        uint256 lChild;
        uint256 rChild;
        uint256 swap;
        uint256 temp;
        
        while(start > 0){
            root = start;
            lChild = getLeftChildI(start);
            while(lChild <= end){
                rChild = lChild + 1;
                swap = root;
                if(self[swap] < self[lChild])
                    swap = lChild;
                if((rChild <= end) && (self[swap]<self[rChild]))
                    swap =lChild;
                if(swap == root)
                    lChild = end + 1;
                else{
                    temp = self[swap];
                    self[swap] = self[root];
                    self[root] = temp;
                    root == swap;
                    lChild = getLeftChildI(root);
                }
            }
            if(start == 0)
                break;
            else
                start =  start + 1;
        }
        while(end > 0){
            temp = self[end];
            self[end] = self[0];
            self[0] = temp;
            end = end - 1 ;
            root = 0;
            lChild = getLeftChildI(0);
            while(lChild <= end){
                rChild = lChild + 1;
                swap = root;
                if(self[swap] < self[lChild])
                    swap = rChild;
                if(swap == root)
                    lChild = end + 1;
                    
                else{
                    temp = self[swap];
                    self[swap] = self[root];
                    self[root] = temp;
                    root = swap;
                    lChild = getLeftChildI(root);
                }
            }
        }
    }
    
    /**
     * @dev Removes duplicates from given array.
     * @param self storage array containing uint256 type variables
     * 
     */
    function uniq(uint256[] storage self) public returns (uint256 length){
        bool contains;
        uint256 index;
        
        for (uint256 i = 0; i < self.length; i++){
            (contains, index) = indexOf(self, self[i], false);
            
            if(i > index){
                for(uint256 j = i; j < self.length - 1; j++){
                    self[j] = self[j + 1];
                }
                
                delete self[self.length - 1];
                self.length--;
                i--;
            }
        }
        
        length = self.length;
    }
    

}