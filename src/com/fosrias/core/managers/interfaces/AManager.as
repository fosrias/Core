////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.managers.interfaces
{
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.interfaces.ADispatcher;
import com.fosrias.core.models.User;
import com.fosrias.core.models.interfaces.AUser;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.vos.CallResult;

import flash.events.Event;

import mx.rpc.Fault;

use namespace app_internal;

/**
 * The AManager class is the base class for all manager subclasses.
 */		
public class AManager extends ADispatcher
{
	//--------------------------------------------------------------------------
    //
    //  Class Variables
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     * Storage for the session status.
     */
    private static var _hasSession:Boolean = false;
    
    /**
     * @private
     * Storage for the session user.
     */
    private static var _sessionUser:AUser;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AManager( self:AManager )
	{
		super( self );
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	//----------------------------------
    //  hasSession
    //----------------------------------
    
    [Bindable (event="sessionUserChange")]
    /**
     * Whether a current session exists.
     */
    public final function get hasSession():Boolean
    {
       return _hasSession;
    }
        
	//----------------------------------
    //  sessionUser
    //----------------------------------
    
    [Bindable (event="sessionUserChange")]
    /**
     * The current session user.
     */
    app_internal function get sessionUser():AUser
    {
        return _sessionUser;
    }
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	
    /**
     * Abstract method that must be overridden in concrete implmentations that 
     * returns arguments to be used in a remote call. Only call this 
     * function to initiate a remote call.
     */
    public function callArguments( ... args):*
    {
        return raiseImplementationError( "method", "AManager.callArguments" ); 
    }
    
    /**
     * Handles a remote call fault.
     * 
     * @param fault The <code>Fault</code> returned by the remote
     * call.
     */
    public function callFault( fault:Fault, ... args ):*
    {
        //Do nothing unless overridden
    }
    
    /**
     * Handles a remote call result.
     * 
     * @param callResult The <code>CallResult</code> returned by the remote
     * call.
     */
    public function callResult( result:CallResult, ... args ):*
    {
        //Do nothing unless overridden
    }
    
    /**
     * Handler for <code>StateEvent.LOGGED_IN</code> events.
     * 
     *  <p>Event priority should be set lower for managers that must 
     * process events after other managers have their session status updated. 
     * Typically these managers would process states of other managers and 
     * thus need the states, and their aggregated managers, to be current.</p>
     * 
     * <p>Typically, this method should be overridden when state changes 
     * to the manager should be made when a session is created.
     * Overridding this event requires calling the <code>loggedIn</code> 
     * method of <code>super</code> in the overridden method.</p>.
     */
    public function loggedIn( user:AUser = null ):void
    {
        _hasSession = true;
        
        //Update the session user.
        if ( user != null ) 
        {
            //Cast as user so User compiled in core swc
            _sessionUser = User( user );
        }
        
        dispatchEventType( "sessionUserChange" ); 
    }
    
    /**
     * Handler for <code>StateEvent.LOGGED_OUT</code> events.
     * 
     * <p>Event priority should be set lower for managers that must 
     * process events after other managers have their session status updated. 
     * Typically these managers would process states of other managers and 
     * thus need the states, and their aggregated managers, to be current.</p>
     * 
     * <p>Typically, this method should be overridden when state changes 
     * to the manager should be made when a session is destroyed. 
     * Overridding this event requires calling the <code>loggedOut</code> 
     * method of <code>super</code> in the overridden method.</p>.
     */
    public function loggedOut( event:StateEvent = null ):void
    {
        _hasSession = false;
        _sessionUser = null;
        
        dispatchEventType( "sessionUserChange" ); 
    }
    
    /**
     * Sets the session user, which is a class variable.
     */
    public function setSessionUser( value:AUser ):void
    {
        _sessionUser = value;
        dispatchEvent( new Event( "sessionUserChange" ) );
    }

	//--------------------------------------------------------------------------
    //
    //  Overriden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc 
     *
     * @private
     * If an external dispatcher is injected, dispatch events there as well.
     */
    override public function dispatchEvent( event:Event ):Boolean
    {
    	if ( _dispatcher != null )
    	{
    	    _dispatcher.dispatchEvent( event );
    	}
    	return super.dispatchEvent( event );
    }
}

}