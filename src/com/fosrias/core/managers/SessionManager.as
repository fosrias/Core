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
import com.fosrias.core.models.interfaces.AUser;

import flash.events.Event;
import flash.events.EventDispatcher;

[Bindable]  
/**
 * The SessionUserManager class is a singleton that maintains the session
 * state and updates subclasses if the session state changes.
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
        = new SessionManager( SingletonLock );  
      
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
    public function SessionManager( lock:Class )  
    {  
        // Verify that the lock is the correct class reference.  
        if ( lock != SingletonLock )  
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
        return _user != null;
    }
    
    //----------------------------------
    //  user
    //----------------------------------
    
    /**
     * @private
     * Storage of the user property. 
     */
    private var _user:AUser

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
        _user = value;
        dispatchEvent( new Event( SESSION_CHANGE ) );
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /** Provides singleton access to the instance. */  
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
class SingletonLock  
{  
}