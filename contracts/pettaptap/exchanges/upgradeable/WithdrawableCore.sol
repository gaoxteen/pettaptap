// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../../libs/TransferHelper.sol";

abstract contract WithdrawableCore is AccessControlUpgradeable {
    
    using ECDSA for bytes32;
    bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
    address _withdrawAddress;
    address public tokenAddress;

    event TokenOut(address indexed owner, uint256 amount, string data);
    function _emitWithdrawEvent(address address_,  uint256 amount_, string memory data_) internal virtual{ 
        emit TokenOut(address_, amount_, data_);
    }

    function withdrawBalance() external onlyRole(WITHDRAW_ROLE) {
        address receiver = msg.sender;
        if(_withdrawAddress != address(0))
             receiver = _withdrawAddress;
        
        uint256 _amount = getBalance();
        TransferHelper.safeTransfer(tokenAddress, receiver, _amount);
        _emitWithdrawEvent(receiver,_amount,"admin");
    }

    function getBalance() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function setWithdrawAddress(address wdAddress_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _withdrawAddress = wdAddress_;
    }
    function getWithdrawAddress() external view onlyRole(DEFAULT_ADMIN_ROLE) returns(address) {     
        return _withdrawAddress;
    }
}
