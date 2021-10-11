//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AyaaToken {
  string private _name;
  string private _symbol;

  uint256 private _totalSupply;
  mapping(address => uint256) balances;
  address owner;

  constructor() {
    owner = msg.sender;
    _name = "Ayaa Token";
    _symbol = "AYAA";
    _totalSupply = 10000000 * 1e18;
    balances[owner] = 1000000 * 1e18;
  }

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view returns (uint8) {
    return 18;
  }

  function totalSupply() public view returns (uint256) {
    return 10000000 * 1e18;
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(balances[msg.sender] > _value, "Not enough balance!");
    balances[_to] += _value;
    balances[msg.sender] -= _value;

    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  ) public returns (bool success) {
    if (balances[_from] < _value) return false;

    if (allowances[_from][msg.sender] < _value) return false;

    balances[_from] -= _value;
    balances[_to] += _value;
    allowances[_from][msg.sender] -= _value;

    emit Transfer(_from, _to, _value);

    return true;
  }

  mapping(address => mapping(address => uint256)) allowances;

  function approve(address _spender, uint256 _value)
    public
    returns (bool success)
  {
    allowances[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender)
    public
    view
    returns (uint256 remaining)
  {
    return allowances[_owner][_spender];
  }

  mapping(uint256 => bool) blockMined;
  uint256 totalMinted = 1000000 * 1e18; //1M that has been minted to the deployer in constructor()

  function mine() public returns (bool success) {
    if (blockMined[block.number]) {
      // rewards of this block already mined
      return false;
    }
    if (block.number % 10 != 0) {
      // not a 10th block
      return false;
    }

    require(totalMinted + 10 * 1e18 < totalSupply());

    balances[msg.sender] = balances[msg.sender] + 10 * 1e18;
    totalMinted = totalMinted + 10 * 1e18;
    blockMined[block.number] = true;

    return true;
  }

  function getCurrentBlock() public view returns (uint256) {
    return block.number;
  }

  function isMined(uint256 blockNumber) public view returns (bool) {
    return blockMined[blockNumber];
  }
}
