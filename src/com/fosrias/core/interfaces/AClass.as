////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009-2010   Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.interfaces
{
import com.fosrias.core.events.DebugEvent;
import com.fosrias.core.managers.SessionManager;
import com.fosrias.core.vos.SessionToken;
import com.fosrias.core.models.interfaces.AUser;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.utils.NullIterator;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.clearTimeout;
import flash.utils.getQualifiedClassName;
import flash.utils.setTimeout;

import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.events.PropertyChangeEvent;

use namespace app_internal;

/**
 * The AClass class is the base class for all abstract core classes. It ensures 
 * abstract classes cannot be instantiated directly and provides methods and 
 * properties used in abstract and concrete subclasses.
 * 
 * <p>Only subclasses of this class can directly dispatch messages to the 
 * <code>DebugConsole</code> through the <code>traceDebug</code) method. 
 * Implement this as the base class for any classes which will dispatch 
 * messages to the <code>DebugConsole</code>.</p>
 * 
 * @see com.fosrias.core.views.DebugConsole	
 */
public class AClass extends EventDispatcher
{
	//--------------------------------------------------------------------------
    //
    //  Class Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     * Flag for broadcasting debug messages.
     */
    private static var _debugMessagesEnabled:Boolean = false;
    
    /**
     * @private
     * Storage for the sessionManager instance.
     */
    protected static var _sessionManager:SessionManager 
        = SessionManager.getInstance();
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AClass(self:AClass)
	{
		if( self != this)
        {
            //Only a subclass can pass a valid reference to self
            throw new IllegalOperationError( "Abstract class did not receive " 
                +  "reference to self. " + qualifiedClassName + " cannot be " 
                +  "instantiated directly." );
        } 
        
        //Broadcasts sessionChange event to all subclasses and calls
		//the sessionChangeHook method
        sessionManager.addEventListener(SessionManager.SESSION_CHANGE,
            sessionChangeHandler, false, 0, true);
	} 
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private var _retryId:uint;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
    //----------------------------------
    //  className
    //----------------------------------
    
    [Transient]
    /**
     * The class name of the implemented class excluding the package
     * specification.
     */
    public final function get className():String
    {
        var name:String = qualifiedClassName;
        if( name.lastIndexOf( "::" ) > 0 )
        {
            name = name.slice( name.lastIndexOf( "::" ) + 2, name.length );
        }
        return name;    
    }
    
    //----------------------------------
    //  hasDebugMessages
    //----------------------------------
    
	[Transient]
    /**
     * Sets whether the application dispatches debug messages to a
     * <code>DebugConsole</code> or not. This property only needs to be set 
     * on one instantiated object that extends <code>AClass</code> 
     * or any of its subclasses to enable debug messaging. Typically, this 
     * property is set in the main manager for the application.
     *  
     * @param value <code>true</code>, if the application monitors debug 
     * messages.
     */
	public function get hasDebugMessages():Boolean
	{
		return _debugMessagesEnabled;
	}
	
	/**
	 * @private
	 */
	public function set hasDebugMessages(value:Boolean):void
    {
        _debugMessagesEnabled = value;
    }
    
    //----------------------------------
    //  hasSession
    //----------------------------------
    
    [Transient] 
    [Bindable(event="sessionChange")]
    /**
     * Whether the application has a current session or not.
     */
    public function get hasSession():Boolean
    {
        return _sessionManager.hasSession;
    }
	
	//----------------------------------
    //  qualifiedClassName
    //----------------------------------
    
    [Transient]
    /**
     * The class name of the implemented class including the package
     * specification.
     */
    public final function get qualifiedClassName():String
    {
        return  getQualifiedClassName(this);
    }
	
	//----------------------------------
	//  sessionManager
	//----------------------------------
	
	[Transient] 
	/**
	 * The session manager instance.
	 */
	public function get sessionManager():SessionManager
	{
		return _sessionManager;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  sessionToken
	//----------------------------------
	
	[Transient] 
	[Bindable(event="sessionChange")]
	/**
	 * The current session token. <code>null</code> if there is no current
	 * session.
	 */
	protected function get sessionToken():SessionToken
	{
		return _sessionManager.token;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
     * Queues a function to be called later.
     *
     * <p>Before each update of the screen, Flash Player or AIR calls
     * the set of functions that are scheduled for the update.
     * Sometimes, a function should be called in the next update
     * to allow the rest of the code scheduled for the current
     * update to be executed.
     * Some features, like effects, can cause queued functions to be
     * delayed until the feature completes.</p>
     *
     * @param method Reference to a method to be executed later.
     *
     * @param args Array of Objects that represent the arguments to pass to 
     * the method.
     *
     */
    public function callLater(method:Function,
                              args:Array = null):void
    {
        UIComponent(FlexGlobals.topLevelApplication).callLater(method, args);
    }
    
    /**
     * Determines whether a session exists or not.
     */
    public function checkSession():Boolean
    {
        return sessionManager.hasSession;
    }

    /**
     * Broadcasts a debug message to the <code>DebugConsole</code> and 
     * calls trace() on the message.
     *  
     * @param message The message to be sent.
     * @param reference The debug message reference. Set to "event" for events.
     */
    public function traceDebug( message:String, 
                                reference:String = null ):void
    {
        //Broadcast messages if enabled and not from the DebugManager
        if (_debugMessagesEnabled && className != "DebugManager")
        {
            message = qualifiedClassName + "\n     " + message;
            
            //Send debug messages to the DebugConsole.
			FlexGlobals.topLevelApplication.dispatchEvent(
                new DebugEvent(DebugEvent.SET_MESSAGE, message, reference) );
         }
        
        //Always send debug messages to the internal debug console.
        trace("DebugMessage: " + message);
    } 
    
    //--------------------------------------------------------------------------
    //
    //  Protected methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * A utility method to cancel a pending <code>retryMethod</code> call.
     * 
     * @param closure The method to retry.
     * @param delay The delay in milliseconds.
     * @param arguments The arguments of the method.
     * 
     */
    protected function clearRetry(retryIndex:Number = NaN):void
    {
		if ( isNaN(retryIndex) )
		{
			clearTimeout(_retryId);
			
		} else {
			
			clearTimeout(retryIndex);
		}
    }
    
    /**
     * Utility method to dispatch an event of the specified type internally
	 * to the instance.
     * 
     * @param The string event type.
     */
    protected function dispatchEventType(type:String):Boolean
    {
        if (type != null)
        {
           return dispatchEvent( new Event(type) ); 
        }
        return false;
    }
	
	/**
	 * A utility method to retry a method after a specified delay.
	 * 
	 * @param closure The method to retry.
	 * @param delay The delay in milliseconds.
	 * @param arguments The arguments of the method.
	 * 
	 */
	protected function retryMethod(closure:Function, 
								   delay:Number, 
								   ...arguments):uint
	{
		_retryId = setTimeout.apply( null, [closure, delay].concat(arguments) );
		return _retryId;
	}
	
	/**
	 * A hook function that is called anytime a session changes. It is called 
	 * before the <code>SessionManager.SESSION_CHANGE</code> event is
	 * dispatched to the class.
	 */
	protected function sessionChangeHook():void
	{
		//Do nothing unless overridden
	}
    
    /**
     * The return value for abstract methods, getters, and setters in 
     * abstract classes which raise and <code>IllegalOperationError</code> 
     * if not overridden. E.g. Abstract getter name must be overridden in 
     * com.fosrias.core.interfaces.AClass.
     * 
     * @param type A string specifying the type of function. Valid values are 
     * "method," "getter" or "setter."
     * @param name The name of the abstract function.
     * 
     * @return Undefined so that it can be used in a return statement
     * in abstract functions that return a defined type.
     */
    protected function raiseImplementationError( type:String, name:String ):*
    {
    	throw new IllegalOperationError( "Abstract " + type + " "
                + name + " must be overridden in " 
                + qualifiedClassName + "." );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override public function dispatchEvent( event:Event ):Boolean
    {
        if ( event.type != PropertyChangeEvent.PROPERTY_CHANGE &&
             event.type != "errorStringChange" &&
             event.type != "sessionChange" )
        {
            traceDebug( "Event Dispatched: " + event.type, "event" );
        }
        
        return super.dispatchEvent( event ); 
    }
    
    /**
     * @inheritDoc
     */
    override public function toString():String
    {
    	return "[Object " + className + "]";
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function sessionChangeHandler(event:Event):void
    {
		//Dispatch first in case any changes need to be made before
		//the sessionChange event is broadcast to the class.
		sessionChangeHook();
		
		dispatchEventType(event.type);
    }
}

}