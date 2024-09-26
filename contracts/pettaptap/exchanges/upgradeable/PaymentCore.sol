// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "./WithdrawableCore.sol";
import "../../libs/TransferHelper.sol";


contract PaymentCore is ReentrancyGuardUpgradeable,AccessControlUpgradeable, UUPSUpgradeable,PausableUpgradeable, WithdrawableCore {

    event Pay(address indexed owner, uint256 amount, string payload);

    function initialize() 
        initializer public {
        __PaymentCore_init();
        __ReentrancyGuard_init();
    }
    

    function __PaymentCore_init() internal onlyInitializing {
        __AccessControl_init();
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(WITHDRAW_ROLE, _msgSender());
    }

    function _authorizeUpgrade(address) internal override onlyRole(DEFAULT_ADMIN_ROLE) {}

  
    function pause() public onlyRole(DEFAULT_ADMIN_ROLE) whenNotPaused {
        _pause();
    }

    function unpause() public onlyRole(DEFAULT_ADMIN_ROLE) whenPaused {
        _unpause();
    }

    function pay(string memory payload) external payable nonReentrant {

        address user = msg.sender;
        require(!_isContract(user), 'ONLY EOA');
       
        emit Pay(user, msg.value, payload);
    }

    function _isContract(address addr) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    function getWithdrawBalance() public view returns (uint256){
        return payable(address(this)).balance;
    }
    function withdraw() external onlyRole(WITHDRAW_ROLE) {
        address receiver = msg.sender;
        if(_withdrawAddress != address(0))
             receiver = _withdrawAddress;
        
        uint256 _amount = getWithdrawBalance();
        payable(receiver).transfer(_amount);
        _emitWithdrawEvent(receiver,_amount,"admin native");
    }

}
