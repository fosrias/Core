package com.fosrias.core.vos
{

/**
* Value object for logging into registered user functionality. 
*/
[Bindable]
public class LoginData
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function LoginData(id:int = 0, login:String = null, 
        password:String = null, rememberMe:Boolean = false, 
        rememberToken:String = null)
    {
    	this.id = id;
    	this.login = login;
    	this.rememberMe = rememberMe;
    	this.rememberToken = rememberToken;    	
    	
    	//Intialized last since logic involved in password setting
    	this.password = password;
    }   
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  id
    //----------------------------------
    
    /**
     * The id of the user. 
     */
    public var id:int;
    
    //----------------------------------
    //  login
    //----------------------------------
    
    /**
     * The login of the user. 
     */
    public var login:String;
    
    //----------------------------------
    //  password
    //----------------------------------
    
    /**
     * @private 
     * Storage for the password property 
     */
    private var _password:String;
    
    /**
     * The password of the user
     * 
     * @return The password of the user as a string
     * 
     */
    public function get password():String
    {
    	return _password;
    }
    
    /**
     * @private
     */
    public function set password(value:String):void
    {
    	if (value != "" && value != null)
    	{
    	   _password = value;
    	   
    	   //Force login by password verification if password is set
    	   this.rememberToken = null;
    	} else {
    		_password = null;
    	}
    }
    
    //----------------------------------
    //  rememberMe
    //----------------------------------
    
    /**
     * Selection to remember the user with a shared object on the client. 
     */
    public var rememberMe:Boolean;
    
    //----------------------------------
    //  rememberToken
    //----------------------------------
    
    /**
     * The remember token value of the shared object on the client. 
     */
    public var rememberToken:String;

}

}