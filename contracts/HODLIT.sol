pragma solidity ^0.4.19;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./TimeWarp.sol";


contract HODLIT is StandardToken, Ownable, TimeWarp {
  using SafeMath for uint256;
  string public name = "HODL INCENTIVE TOKEN";
  string public symbol = "HIT";
  uint256 public decimals = 18;
  uint256 public multiplicator = 10 ** decimals;
  uint256 public totalSupply;
  uint256 public ICDSupply;

  uint256 public hardCap = SafeMath.mul(100000000, multiplicator);
  uint256 public ICDCap = SafeMath.mul(20000000, multiplicator);

  mapping (address => uint256) public etherBalances;
  mapping (address => bool) public ICDClaims;
  mapping (address => uint256) public referrals;
  mapping (address => bool) public bonusReceived;


  uint256 public regStartTime = 1519848000; // 28 feb 2018 20:00 GMT
  uint256 public regStopTime = regStartTime + 7 days;
  uint256 public POHStartTime = regStopTime;
  uint256 public POHStopTime = POHStartTime + 7 days;
  uint256 public ICDStartTime = POHStopTime;
  uint256 public ICDStopTime = ICDStartTime + 7 days;
  uint256 public PCDStartTime = ICDStopTime + 14 days;

  address public ERC721Address;

  modifier forRegistration {
    uint256 currentTime = getTime();
    require(currentTime >= regStartTime && currentTime < regStopTime);
    _;
  }

  modifier forICD {
    uint256 currentTime = getTime();
    require(currentTime >= ICDStartTime && currentTime < ICDStopTime);
    _;
  }

  modifier forERC721 {
    uint256 currentTime = getTime();
    require(msg.sender == ERC721Address);
    require(currentTime >= PCDStartTime);
    _;
  }

  function HODLIT() public {
    uint256 reserve = SafeMath.mul(30000000, multiplicator);
    owner = msg.sender;
    totalSupply = totalSupply.add(reserve);
    balances[owner] = balances[owner].add(reserve);
    Transfer(address(0), owner, reserve);
  }

  function() external payable {
    revert();
  }

  function setERC721Address(address _ERC721Address) external onlyOwner {
    ERC721Address = _ERC721Address;
  }

  function registerEtherBalance(address _referral) external forRegistration {
    require(msg.sender.balance > 0.1 ether && etherBalances[msg.sender] == 0);
    if (_referral != address(0) && referrals[_referral] < 20) {
      referrals[_referral]++;
    }
    etherBalances[msg.sender] = msg.sender.balance;
  }

  function claimTokens() external forICD {
    require(ICDClaims[msg.sender] == false);
    require(etherBalances[msg.sender] > 0);
    require(etherBalances[msg.sender] <= msg.sender.balance + 50 finney);
    ICDClaims[msg.sender] = true;
    require(mintICD(msg.sender, computeReward(etherBalances[msg.sender])));
  }

  function mintPCD(address _to, uint256 _amount) external forERC721 returns(bool) {
    require(_to != address(0));
    require(_amount + totalSupply <= hardCap);
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    etherBalances[_to] = _to.balance;
    Transfer(address(0), _to, _amount);
    return true;
  }

  function claimTwitterBonus() external forICD {
    require(balances[msg.sender] > 0 && !bonusReceived[msg.sender]);
    bonusReceived[msg.sender] = true;
    mintICD(msg.sender, multiplicator.mul(20));
  }

  function claimReferralBonus() external forICD {
    require(referrals[msg.sender] > 0 && balances[msg.sender] > 0);
    referrals[msg.sender] = 0;
    mintICD(msg.sender, SafeMath.mul(referrals[msg.sender], multiplicator));
  }

  function computeReward(uint256 _amount) internal view returns(uint256) {
    if (_amount < 1 ether) return SafeMath.mul(20, multiplicator);
    if (_amount < 2 ether) return SafeMath.mul(100, multiplicator);
    if (_amount < 3 ether) return SafeMath.mul(240, multiplicator);
    if (_amount < 4 ether) return SafeMath.mul(430, multiplicator);
    if (_amount < 5 ether) return SafeMath.mul(680, multiplicator);
    if (_amount < 6 ether) return SafeMath.mul(950, multiplicator);
    if (_amount < 7 ether) return SafeMath.mul(1260, multiplicator);
    if (_amount < 8 ether) return SafeMath.mul(1580, multiplicator);
    if (_amount < 9 ether) return SafeMath.mul(1900, multiplicator);
    if (_amount < 10 ether) return SafeMath.mul(2240, multiplicator);
    if (_amount < 11 ether) return SafeMath.mul(2560, multiplicator);
    if (_amount < 12 ether) return SafeMath.mul(2890, multiplicator);
    if (_amount < 13 ether) return SafeMath.mul(3210, multiplicator);
    if (_amount < 14 ether) return SafeMath.mul(3520, multiplicator);
    if (_amount < 15 ether) return SafeMath.mul(3830, multiplicator);
    if (_amount < 16 ether) return SafeMath.mul(4120, multiplicator);
    if (_amount < 17 ether) return SafeMath.mul(4410, multiplicator);
    if (_amount < 18 ether) return SafeMath.mul(4680, multiplicator);
    if (_amount < 19 ether) return SafeMath.mul(4950, multiplicator);
    if (_amount < 20 ether) return SafeMath.mul(5210, multiplicator);
    if (_amount < 21 ether) return SafeMath.mul(5460, multiplicator);
    if (_amount < 22 ether) return SafeMath.mul(5700, multiplicator);
    if (_amount < 23 ether) return SafeMath.mul(5930, multiplicator);
    if (_amount < 24 ether) return SafeMath.mul(6150, multiplicator);
    if (_amount < 25 ether) return SafeMath.mul(6360, multiplicator);
    if (_amount < 26 ether) return SafeMath.mul(6570, multiplicator);
    if (_amount < 27 ether) return SafeMath.mul(6770, multiplicator);
    if (_amount < 28 ether) return SafeMath.mul(6960, multiplicator);
    if (_amount < 29 ether) return SafeMath.mul(7140, multiplicator);
    if (_amount < 30 ether) return SafeMath.mul(7320, multiplicator);
    if (_amount < 31 ether) return SafeMath.mul(7500, multiplicator);
    if (_amount < 32 ether) return SafeMath.mul(7660, multiplicator);
    if (_amount < 33 ether) return SafeMath.mul(7820, multiplicator);
    if (_amount < 34 ether) return SafeMath.mul(7980, multiplicator);
    if (_amount < 35 ether) return SafeMath.mul(8130, multiplicator);
    if (_amount < 36 ether) return SafeMath.mul(8270, multiplicator);
    if (_amount < 37 ether) return SafeMath.mul(8410, multiplicator);
    if (_amount < 38 ether) return SafeMath.mul(8550, multiplicator);
    if (_amount < 39 ether) return SafeMath.mul(8680, multiplicator);
    if (_amount < 40 ether) return SafeMath.mul(8810, multiplicator);
    if (_amount < 41 ether) return SafeMath.mul(8930, multiplicator);
    if (_amount < 42 ether) return SafeMath.mul(9050, multiplicator);
    if (_amount < 43 ether) return SafeMath.mul(9170, multiplicator);
    if (_amount < 44 ether) return SafeMath.mul(9280, multiplicator);
    if (_amount < 45 ether) return SafeMath.mul(9390, multiplicator);
    if (_amount < 46 ether) return SafeMath.mul(9500, multiplicator);
    if (_amount < 47 ether) return SafeMath.mul(9600, multiplicator);
    if (_amount < 48 ether) return SafeMath.mul(9700, multiplicator);
    if (_amount < 49 ether) return SafeMath.mul(9800, multiplicator);
    if (_amount < 50 ether) return SafeMath.mul(9890, multiplicator);
    return SafeMath.mul(10000, multiplicator);
  }

  function mintICD(address _to, uint256 _amount) internal returns(bool) {
    require(_to != address(0));
    require(_amount + ICDSupply <= ICDCap);
    totalSupply = totalSupply.add(_amount);
    ICDSupply = ICDSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    etherBalances[_to] = _to.balance;
    Transfer(address(0), _to, _amount);
    return true;
  }
}
