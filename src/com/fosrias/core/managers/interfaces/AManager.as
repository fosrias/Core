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
import com.fosrias.core.validators.ServerErrors;
import com.fosrias.core.vos.CallResult;

import flash.events.Event;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.rpc.AsyncToken;
import mx.rpc.Fault;

use namespace app_internal;

[Bindable]
/**
 * The AManager class is the base class for all manager subclasses.
 */		
public class AManager extends ADispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The fragment that corresponds to the Home page of the application.
     */
    public static const INITIAL_REGISTRATION:String 
        = "com.fosrias.core.AManager.initialRegistration";
    
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
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private var _remoteCallIntervalId:int;
	
	/**
	 * @private
	 */
	protected var _lastRemoteCall:String;
	
	/**
	 * @private
	 */
	protected var _lastRemoteCallParameters:Object;
	
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	//----------------------------------
    //  modelServerErrors
    //----------------------------------
    
    /**
     * @private 
     * Storage for the modelServerErrors property. 
     */
    private var _modelServerErrors:ServerErrors = null;
    
    /**
     * The server errors returned by a remote call.
     * 
     * <p>This property is typically injected into a <code>AViewModel</code>
     * presentation model's <code>serverErrors</code> property.</p>
     */
    [Bindable(event="serverErrorsChange")]
    public final function get modelServerErrors():ServerErrors
    {
        return _modelServerErrors;
    }    
 
	//--------------------------------------------------------------------------
    //
    //  Namespaced properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  sessionUser
    //----------------------------------
    
    [Bindable (event="sessionChange")]
    /**
     * The current session user.
     */
    app_internal function get sessionUser():AUser
    {
        return sessionManager.user;
    }

    //----------------------------------
    //  watchedStates
    //----------------------------------
    
    /**
     * @private 
     */
    private var _watchedStates:Array;
    
    /**
     * The states watched by this manager if any.
     */
    app_internal function get watchedStates():Array
    {
        return _watchedStates;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  hasPendingRemoteCall
    //----------------------------------
    
    /**
     * A that can be used to monitor remote calls.
     */
    protected var hasPendingRemoteCall:Boolean = false;

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
        traceDebug(fault.message);
    }
    
    /**
     * Handles a remote call result. Override this and call super to 
	 * set the <code>lastCall</code> and <code>lastParameters</code>.
     * 
     * @param callResult The <code>CallResult</code> returned by the remote
     * call.
     */
    public function callResult( result:CallResult, ... args):*
    {
		for each (var object:Object in args[0])
		{
			if (object is AsyncToken)
			{
				_lastRemoteCall = object.message.operation;
				_lastRemoteCallParameters = object.message.body;
				
				if (_lastRemoteCallParameters is Array && 
					_lastRemoteCallParameters.length == 0)
					_lastRemoteCallParameters = null;
				
				break;
			}
		}
        //Do nothing else unless overridden
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
    public function loggedIn( event:StateEvent = null ):void
    {
        //Update the session user.
        if ( event != null ) 
        {
            sessionManager.user = User( event.data );
        }
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
        sessionManager.user = null;
    }
    
    /**
     * Sets the session user, which is a class variable.
     */
    public function setSessionUser( value:AUser ):void
    {
        sessionManager.user = value;
    }
    
    /**
     * Montitors other states being set in the system.
     * 
     * <p>This method is typically called in a global event listener. By doing
     * this, other states and managers communicate their state to this manager 
     * by dispatching a <code>StateEvent.STATE_SET</code> event.</p>
     * 
     * <p>The default use of this method is to auto-close a state that
     * is set to automatically close (see the <code>AState.stateSet</code> 
     * internal method.</p>
     * 
     * @param event The event with and AState payload
     */
    public function stateSet(event:StateEvent):void
    {
        raiseImplementationError("method", "stateSet");
    }

    //--------------------------------------------------------------------------
    //
    //  Internal Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Dispatches an event to the main application to register the manager.
     */
    app_internal final function registerManager(initial:Boolean = false):void
    {
        var reference:String = null;
        if ( initial )
        {
            reference = INITIAL_REGISTRATION;
        }
        //Dispatch the manager so the it can be registered
        //in the FragmentManager and let main application know the 
        //state registered so that child manager can register in 
        //AState.register event handler
        UIComponent(FlexGlobals.topLevelApplication ).dispatchEvent(
            new StateEvent(StateEvent.REGISTER, this, reference));
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
    
    //--------------------------------------------------------------------------
    //
    //  Protected methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * The current session user.
     */
    protected function clearCallTimeout():void
    {
        hasPendingRemoteCall = false;
        clearTimeout( _remoteCallIntervalId );
    }
    
    /**
     * The current sessioin user.
     */
    protected function setCallTimeout( closure:Function, 
                                       delay:Number, 
                                       ... arguments ):void
    {
        hasPendingRemoteCall = true;
       _remoteCallIntervalId = setTimeout( closure, delay, arguments );
    }
    
    /**
     * Sets the <code>modelServerErrors</code> property.
     * 
     * <p>Typically, called by states that handle a callFault.</p>
     */    
    protected function setServerErrors( value:String ):void
    {
        if ( value != null )
        {
            _modelServerErrors = new ServerErrors( XML( value ) );
        } else {
            _modelServerErrors = null;
        }
        dispatchEvent( new Event( "serverErrorsChange" ) );
    }
    
    /**
     * Sets the watched states for the manager.
     */
    protected function setWatchedStates(value:Array):void
    {
        _watchedStates = value;
        
        if ( !(this is AStatefulManager) )
        {
            registerManager(true);
        }
    }
}

}