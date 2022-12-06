// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyToken is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public _whitelist;
    
    address public _owner;

    uint256 private _totalSupply;
    uint8 public _decimals;
    string public _symbol;
    string public _name;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 totalSupply_
    ) {
        _owner = msg.sender;
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _totalSupply = totalSupply_;
        _balances[_owner] = _totalSupply;
        _whitelist[_owner] = true;

        //emit Transfer(address(0), msg.sender, _totalSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the contract owner can perform this action");
        _;
    }

    function addToWhitelist(address _addr) public onlyOwner {
        _whitelist[_addr] = true;
    }

    function removeFromWhitelist(address _addr) public onlyOwner {
        _whitelist[_addr] = false;
    }

    modifier onlyWhitelisted() {
        require(_whitelist[msg.sender], "You must be on the whitelist to perform this action");
        _;
    }
   
   function decimals() external view returns (uint8) {
        return _decimals;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function name() external view  returns (string memory) {
        return _name;
    }


    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf(address account)
        external
        view
        override(IERC20) 
        returns (uint256)
    {
        return _balances[account];
    }
    
    function transfer(address recipient, uint256 amount)
        external
        override(IERC20) 
        onlyWhitelisted 
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        override(IERC20) 
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        external
        override(IERC20) 
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

   function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override(IERC20)  onlyWhitelisted returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] -= amount);
        return true;
    }
    
     function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");
        require(
            _balances[sender] >= amount,
            "BEP20: Sender didn't have the amount"
        );

        _balances[sender] = _balances[sender] - amount;
        _balances[recipient] = _balances[recipient] + amount;

        emit Transfer(sender, recipient, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}