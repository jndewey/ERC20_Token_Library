pragma solidity ^0.4.11;

import './ERC20.sol';
import './BasicToken.sol';


contract AccreditationRegistry {
    function get(string _name) constant returns (address);
    function getOrThrow(string _name) constant returns (address);
}


contract Accreditation {
    function isAccredited(address _address) constant returns (bool);
}


contract AccreditedToken is ERC20 {

    AccreditationRegistry accreditationRegistry = AccreditationRegistry(0x000000000000000000);
    
    bool private registrationStatementFiled = false;
    
    function getAccreditationStatus() constant returns(address) {
        return accreditationRegistry.getOrThrow("com.hk.token");
    }

    /**
    * @dev Checks modifier and allows transfer if either restrictions turned off or accreditation of proposed transferee address has been verified.
    * Otherwise, exit function.
    */
    modifier accreditationVerified(address _to) {
        if (registrationStatementFiled) {
            _;
        } else if (Accreditation(getAccreditationStatus()).isAccredited(_to)) {
            _;
        }
    }
    /**
    * @dev Function that triggers API call to third party accreditation service to verify status approved
    * @param _to The address that will receive the tokens.
    * @param _value The amount of tokens to be transferred.
    */
    function registrationFiled() returns (bool) {
        address authorizedOfficer = 0x0;
        if (msg.sender == authorizedOfficer)
            registrationStatementFiled = true;
    }
    
    /**
    * @dev Checks modifier and allows transfer if accreditation of proposed transferee address has been verified.
    * @param _to The address that will receive the tokens.
    * @param _value The amount of tokens to be transferred.
    */
    function transfer(address _to, uint256 _value) accreditationVerified(_to) returns (bool) {
        return super.transfer(_to, _value);
    }
  
    // Time Based Restrictions can be implemented with below logic

    /**
    * @dev Checks whether it can transfer or otherwise throws. 
    * 
    */
    modifier canTransfer(address _sender, uint256 _value) {
        require(_value <= transferableTokens(_sender, uint64(now)));
        _;
    }

    /**
    * @dev Checks modifier and allows transfer if tokens are not locked.
    * @param _from The address that will send the tokens.
    * @param _to The address that will receive the tokens.
    * @param _value The amount of tokens to be transferred.
    */
    function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    /**
    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
    * specific logic for limiting token transferability for a holder over time.
    */
    function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
        return balanceOf(holder);
    }


}
