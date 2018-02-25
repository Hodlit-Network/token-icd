pragma solidity ^0.4.19;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract TimeWarp is Ownable {
  bool development;
  uint256 warpedTime = block.timestamp;

  function setDevelopment(bool _development)external onlyOwner {
    development = _development;
  }

  function addDays(uint256 _days) external onlyOwner {
    require(_days > 0);
    warpedTime += 1 days * _days;
  }

  function addHours(uint256 _hours) external onlyOwner {
    require(_hours > 0);
    warpedTime += 1 hours * _hours;
  }

  function getTime() public view returns(uint256) {
    if (development) {
      return warpedTime;
    } else {
      return block.timestamp;
    }
  }
}
