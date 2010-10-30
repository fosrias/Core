////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010   Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.managers
{
import com.fosrias.core.models.NullUser;
import com.fosrias.core.vos.SessionToken;
import com.fosrias.core.models.interfaces.AUser;

import flash.events.Event;
import flash.events.EventDispatcher;

[Bindable]  
/**
 * The SessionUserManager class is a singleton that maintains the session
 * state and notifies subclasses if the session state changes that listen
 * for a <code>SessionManager.SESSION_CHANGE</code> event. Classes that
 * extend the abstract class AClass can use the hook method 
 * <code>sessionChangeHook</code> to manage session changes.
 */
public class SessionManager extends EventDispatcher 
{     
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The constant representing a session change event.
     */
    public static const SESSION_CHANGE:String = "sessionChange";
    
    /**
     * @private 
     */
    private static const _instance:SessionManager 
    	= new SessionManager(SingletonEnforcer);  
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /** 
     * Constructor 
     *  
     * @param lock The Singleton lock class to prevent outside instantiation. 
     */  
    public function SessionManager(enforcer:Class)  
    {  
        // Verify that the lock is the correct class reference.  
        if (enforcer != SingletonEnforcer)  
        {  
            throw new Error( "Invalid Singleton access. " +
                "Use SessionManager.getInstance()." );  
        }  
    }  
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  hasSession
    //----------------------------------
    
    /**
     * Whether a current session exists.
     */
    public function get hasSession():Boolean
    {
        return _token.hasSession || _user.id != -1;
    }
    
	//----------------------------------
	//  login
	//----------------------------------
	
	/**
	 * The login of the current token.
	 */
	public function get login():String
	{
		return _token.login;
	}
	
	//----------------------------------
	//  password
	//----------------------------------
	
	/**
	 * The password of the current token.
	 */
	public function get password():String
	{
		return _token.login;
	}
	
	//----------------------------------
	//  token
	//----------------------------------
	
	/**
	 * @private
	 * Storage of the token property.
	 */
	private var _token:SessionToken = new SessionToken;
	
	/**
	 * The session user.
	 */
	public function get token():SessionToken
	{
		return _token;
	}
	
	/**
	 * @private
	 */
	public function set token(value:SessionToken):void
	{
		if (value != null)
		{
			_token = value;
			
		} else {
			_token = new SessionToken;
		}
		dispatchEvent( new Event(SESSION_CHANGE) );
	}
	
	//----------------------------------
    //  user
    //----------------------------------
    
    /**
     * @private
     * Storage of the user property. 
     */
    private var _user:AUser = new NullUser;
    
	[Deprecated (replacement="Use token.")]
    /**
     * The session user.
     */
    public function get user():AUser
    {
        return _user;
    }
    
    /**
     * @private
     */
    public function set user( value:AUser ):void
    {
        if ( value != null )
        {
            _user = value;
        } else {
            _user = new NullUser;
        }
        dispatchEvent( new Event(SESSION_CHANGE) );
    }
    
    //--------------------------------------------------------------------------
	//
	//  Static methods
	//
	//--------------------------------------------------------------------------
	
	/** 
	 * Provides singleton access to the instance. 
	 */  
    public static function getInstance():SessionManager  
    {  
        return _instance;  
    }     
}

} 

/**
 * This is a private class declared outside of the package 
 * that is only accessible to classes inside of the SessionManager.as 
 * file. Because of that, no outside code is able to get a 
 * reference to this class to pass to the constructor, which 
 * enables us to prevent outside instantiation. 
 */  
class SingletonEnforcer {}