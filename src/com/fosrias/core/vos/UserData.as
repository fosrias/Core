package com.fosrias.core.vos
{

public class UserData
{
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function UserData(login:String = null,
        email:String = null, emailConfirmation:String = null, 
        firstName:String = null, lastName:String = null,
        nickname:String = null, password:String = null,  
        passwordConfirmation:String = null, terms:Boolean = false):void
    {
        this.login = login;
        this.email = email;
        this.emailConfirmation = emailConfirmation;
        this.firstName = firstName;
        this.lastName = lastName;
        this.nickname = nickname;
        this.password = password;
        this.passwordConfirmation = passwordConfirmation;
        this.terms = terms;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    public var login:String;
    public var email:String;
    public var emailConfirmation:String;
    public var firstName:String;
    public var lastName:String;
    public var nickname:String;
    public var password:String;
    public var passwordConfirmation:String;
    public var terms:Boolean;

}

}