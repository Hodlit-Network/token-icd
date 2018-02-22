pragma solidity ^0.4.19;

import './HODLIT.sol';

contract Mock {
  HODLIT public hodlit;

  function Mock(address _hodlit) public {
    hodlit = HODLIT(_hodlit);
  }

  function setTokenAddress(address _hodlit) external {
    hodlit = HODLIT(_hodlit);
  }

  function mintFor(address _to, uint256 _amount) external {
    require(hodlit.mintPCD(_to, _amount));
  }
}
