////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.models.interfaces
{
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.interfaces.ADispatcher;
import com.fosrias.core.utils.DateMath;
import com.fosrias.core.vos.LoginData;
import com.fosrias.core.vos.UserData;
import com.fosrias.core.vos.UserPermissions;

import flash.errors.IllegalOperationError;

/**
* Abstract user class
*/
[Bindable]
public class AUser
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AUser(self:AUser) 
    {
    	super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    public var id:int;
    public var login:String;
    public var email:String;
    public var emailConfirmation:String;
    public var firstName:String;
    public var isInitialLogin:Boolean;
    public var lastName:String;
    public var nickname:String;
    public var password:String;
    public var passwordConfirmation:String;
    public var permissions:UserPermissions = new UserPermissions;
    public var rememberToken:String;
    public var rememberTokenExpiresAt:Date;
    public var terms:Boolean;
    
    
    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * Clones an exact duplicate of the user as a new user object.
     * 
     * @return A new user object with the exact same state of the user
     * that was cloned.
     * 
     * Abstract method that must be overridden.
     */
    public function get clone():AUser
    {
        throw new IllegalOperationError("Abstract method AUser.clone " + 
                    "must be overridden.");
    }
    
    //----------------------------------
    //  cookieValue
    //----------------------------------
    
    /**
     * Creates XML cookie user record based on the user.
     * 
     * @return XML to be stored in the cookie value.
     * 
     */
    public function get cookieValue():String
    {
        return "<user>" + 
                    "<firstName>" + firstName + "</firstName>" + 
                    "<login>" + login + "</login>" + 
                    "<rememberToken>" + 
                        (rememberToken != null ? rememberToken : "" ) + 
                    "</rememberToken>" + 
                "</user>";
    }
    
    //----------------------------------
    //  cookieExpiration
    //----------------------------------
    
    /**
     * Gets the time until the cookie expires.
     *  
     * @return Time in milliseconds from now until the expiration time.
     * 
     * @private
     * Hack. If there is no token, expire the cookie in 1 year. This 
     * allows the login to be remembered as long as the cookie or user
     * is not cleared.
     */
    public function get cookieExpiration():int
    {
        var now:Date = new Date;
        if (rememberToken != null)
        {
           return rememberTokenExpiresAt.time - now.time;   
        }
        return DateMath.dateAdd("y", now, 1).time - now.time;
    }
    
    //----------------------------------
    //  hasNickname
    //----------------------------------
    
    /**
     * Whether the user has a nickname or not.
     * 
     * @return true if the user has a nickname. false otherwise.
     * 
     */
    public function get hasNickname():Boolean
    {
       return !(nickname == "" || nickname == null);
    }
    
    //----------------------------------
    //  loginData
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
    public function get loginData():LoginData
    {
        throw new IllegalOperationError("Abstract method AUser.loginVO " + 
                    "must be overridden.");
    }
    
    //----------------------------------
    //  userData
    //----------------------------------
    
    /**
     * Creates a value object of the user.
     * 
     * @return A new user value object with the exact same state of the user
     * that was cloned.
     * 
     * @private
     * Abstract method that must be overridden.
     */
    public function get userData():UserData
    {
        throw new IllegalOperationError("Abstract method AUser.userVO " + 
                    "must be overridden.");
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Clears the fields used to update the user 
     * 
     */
    public function clearUpdate():void
    {
    	password = null;
        passwordConfirmation = null;
        emailConfirmation = null;
    }

    /**
     * Initialization function used in concrete classes.
     *  
     * @param id
     * @param login
     * @param email
     * @param firstName
     * @param lastName
     * @param nickname
     * @param password
     * @param passwordConfirm
     * @param oldPassword
     * @param rememberToken
     * @param rememberTokenExpiresAt
     * 
     */
    protected function initialize( id:int = 0, login:String = null,
        email:String = null, emailConfirmation:String = null, 
        firstName:String = null, lastName:String = null,
        nickname:String = null, password:String = null,  
        passwordConfirmation:String = null, rememberToken:String = null, 
        rememberTokenExpiresAt:Date = null, terms:Boolean = false, 
        permissions:UserPermissions = null,
        isInitialLogin:Boolean = false ):void
    {
        this.id = id;
        this.login = login;
        this.email = email;
        this.emailConfirmation = emailConfirmation;
        this.firstName = firstName;
        this.isInitialLogin = isInitialLogin;
        this.lastName = lastName;
        this.nickname = nickname;
        this.password = password;
        this.passwordConfirmation = passwordConfirmation;
        this.rememberToken = rememberToken;
        this.rememberTokenExpiresAt = rememberTokenExpiresAt;
        this.terms = terms;
        if ( permissions == null )
        {
        	this.permissions = new UserPermissions;
        } else {
        	this.permissions = permissions;
        }
    }
    
    /**
     * Parses the value of a cookie and sets the user values accordingly.
     * 
     * @param value The value of the cookie that contains user data.
     * 
     */
    public function parseCookieValue(value:Object):void
    {
    	var cookieUser:XML = new XML(value);
	    this.firstName = cookieUser.firstName;
	    this.login = cookieUser.login;
	    if (cookieUser.rememberToken == "")
	    {
	        this.rememberToken = null;
	    } else {
	        this.rememberToken = cookieUser.rememberToken;
	    }
    }
}

}