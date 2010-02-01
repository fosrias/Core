////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.models
{
import com.fosrias.core.models.interfaces.AUser;
import com.fosrias.core.vos.LoginData;
import com.fosrias.core.vos.UserData;
import com.fosrias.core.vos.UserPermissions;

/**
 * The User class is 
 */
[RemoteClass(alias="User")]
[Bindable]
public class User extends AUser
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function User(id:int = 0, login:String = null,
        email:String = null, emailConfirmation:String = null, 
        firstName:String = null, lastName:String = null,
        nickname:String = null, password:String = null,  
        passwordConfirmation:String = null, rememberToken:String = null, 
        rememberTokenExpiresAt:Date = null, terms:Boolean = false,
        permissions:UserPermissions = null, 
        isInitialLogin:Boolean = false) 
    {
    	super(this);
        super.initialize(id, login, email, emailConfirmation, firstName, 
            lastName, nickname, password, passwordConfirmation, rememberToken, 
            rememberTokenExpiresAt, terms, permissions, isInitialLogin);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  Clone
    //----------------------------------
    
    /** 
     * @inheritDoc
     */
    override public function get clone():AUser
    {
    	return new User(id, login, email, emailConfirmation, firstName, 
    	    lastName, nickname, password, passwordConfirmation, rememberToken, 
            rememberTokenExpiresAt, terms, permissions, isInitialLogin);
    }
    
    //----------------------------------
    //  loginVO
    //----------------------------------
    
    /**
     * Creates a value object of the login information.
     * 
     * @return A new user value object with the exact same state of the user
     * that was cloned.
     * 
     * @private
     * Abstract method that must be overridden.
     */
    override public function get loginData():LoginData
    {
        return new LoginData(id, login, password, 
            rememberToken != null, rememberToken);
    }
                    
    //----------------------------------
    //  userVO
    //----------------------------------
    
    /**
     * Value Object property
     * 
     * @return Value Object of the user.
     * 
     */
    override public function get userData():UserData
    {
        return new UserData(login, email, emailConfirmation, firstName, lastName, 
            nickname, password, passwordConfirmation,terms); 
    }
    
        
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc 
     */    
    public function toString():String
    {
        return "Class: User" +
               "\n    id: " + id +
               "\n    username: " + login +
               "\n    email: " + email +
               "\n    firstName: " + firstName +
               "\n    nickname: " + nickname +
               "\n    rememberToken: " + rememberToken +
               "\n    rememberTokenExpiresAt: " + 
                    rememberTokenExpiresAt.toDateString();   
    }
}

}