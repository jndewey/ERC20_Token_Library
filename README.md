# ERC20_Token_Library - Rule 506 / Regulation D

A library of ERC20 compliant contracts allowing for the issuance of "restricted" tokens meeting the requirements of Rule 506 of Regulation D. Primary logic is found in AccreditedToken.sol, and more specifically:

```solidity
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
  
    // Time Based Restrictions can also be implemented
    
    ***

}

```



