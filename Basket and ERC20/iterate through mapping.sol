mapping (address => uint) public mappedUsers;
address[] public addressIndices;
// start adding address in array
addressIndices.push(newAddress);
// define mappedUsers as well
mappedUsers[newAddress] = someValue;
...
// We know the length of the array
uint arrayLength = addressIndices.length;
// totalValue auto init to 0
uint totalValue;
for (uint i=0; i<arrayLength; i++) {
  totalValue += mappedUsers[addressIndices[i]];
}
