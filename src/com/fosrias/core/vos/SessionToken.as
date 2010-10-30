////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos
{
	
[RemoteClass (alias="com.fosrias.core.vos.SessionToken")]
/**
 * The SessionToken class stores information on the current session and
 * the session user.
 */	
public class SessionToken
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function SessionToken(login:String = null, password:String = null)
	{
		this.login = login;
		this.password = password;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  hasCredentials
	//----------------------------------
	
	/**
	 * Whether the token has valid creditials set or not. Returns false if
	 * if neither the login or password have been set on the token.
	 */
	public function get hasCredentials():Boolean
	{
		return _login != null || _password != null;
	}
	
	//----------------------------------
	//  hasSession
	//----------------------------------
	
	/**
	 * Whether the token corresponds to a valid session or not.
	 */
	public function get hasSession():Boolean
	{
		return userId != 0;
	}
	
	//----------------------------------
	//  login
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the login property
	 */
	private var _login:String;

	/**
	 * The login name.
	 */
	public function get login():String
	{
		return _login;
	}

	/**
	 * @private
	 */
	public function set login(value:String):void
	{
		_login = value;
		
		//When a remote object is created, this automatically populates
		//the login from the credentials in the session manager
		if (_login == null)
		{
			//_login = SessionManager.getInstance().login;
		}
	}
	
	//----------------------------------
	//  nickname
	//----------------------------------
	
	/**
	 * The alias of the user.
	 */
	public var nickname:String;
	
	//----------------------------------
	//  password
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the login property
	 */
	private var _password:String;

	/**
	 * The user password.
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
		_password = value;
		
		//When a remote object is created, this automatically populates
		//the password from the credentials in the session manager
		if (_password == null)
		{
			//_password = SessionManager.getInstance().password;
		}
	}

	//----------------------------------
	//  userId
	//----------------------------------
	
	/**
	 * The id of the user that has the session.
	 */
	public var userId:uint;
	
	//----------------------------------
	//  userRoles
	//----------------------------------
	
	/**
	 * The roles associated with the user.
	 */
	public var userRoles:Array;
}
	
}