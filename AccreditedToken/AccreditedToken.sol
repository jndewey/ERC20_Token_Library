pragma solidity ^0.4.11;

import './ERC20.sol';


contract AccreditedToken is ERC20 {

    //Mapping of all approved investors who have been verified TODO: ADD VALUE FOR TIME ADDED
    mapping(address => bool) public approvedInvestors;

    /**
     * @dev Checks modifier and allows transfer if accreditation of proposed transferee address has been verified.
     * @param _to The address that will receive the tokens.
     * @param _value The amount of tokens to be transferred.
     */
    modifier accreditationVerified (address investorAddress) {
        //Check tokenRegistered value to determine if registration statement filed
        //If registration filed, modifier evaluates to true and returns to function
        //If false, then proceeds to verify investor
        //Evaluate if investorAddress stored in map of approved accredited investors
        //Require bool value returned to evaluate to true
        //otherwise, exit function
        _;
    }

    /**
    * @dev Checks whether it can transfer or otherwise throws. 
    * NOTE THIS RELATES TO TRANSFERFROM FUNCTION--NOT ACCREDITATION STATUS
    */
    modifier canTransfer(address _sender, uint256 _value) {
        require(_value <= transferableTokens(_sender, uint64(now)));
        _;
    }
    /**
     * @dev Function that triggers API call to third party accreditation service to verify status approved
     * @param _to The address that will receive the tokens.
     * @param _value The amount of tokens to be transferred.
     */
    function registrationFiled() returns (bool) {
        //msg.sender must equal designated officers authorized to remove restriction on transfers;
        //If true, sets value of registrationStatementFiled = true;
        //otherwise, exit function
    }

    /**
     * @dev Function that triggers API call to third party accreditation service to verify status approved
     * @param _to The address that will receive the tokens.
     * @param _value The amount of tokens to be transferred.
     */
    function establishAccreditation() returns (bool) {
        //address _investor = msg.sender;
        //Call API
        //if true value returned, then add _investor address to map of approved investors;
        //[TODO: ADD EXPIRATION TO APPROVAL; 
        //otherwise, exit function
    }

    /**
     * @dev Checks modifier and allows transfer if accreditation of proposed transferee address has been verified.
     * @param _to The address that will receive the tokens.
     * @param _value The amount of tokens to be transferred.
     */
    function transfer(address _to, uint256 _value) accreditationVerified(_to) returns (bool) {
        return super.transfer(_to, _value);
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
