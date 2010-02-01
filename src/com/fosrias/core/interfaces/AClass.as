////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.interfaces
{
import com.fosrias.core.events.DebugEvent;
import com.fosrias.core.namespaces.app_internal;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getQualifiedClassName;

import mx.core.FlexGlobals;

use namespace app_internal;

/**
 * The AClass class is the base class for all core classes. It ensures abstract 
 * classes cannot be instantiated directly and provides methods and properties 
 * used in abstract and concrete subclasses.
 * 
 * <p>Only subclasses of this class can directly dispatch messages to the 
 * <code>DebugConsole</code>. Implement this as the base class for any 
 * classes which will dispatch messages to the <code>DebugConsole</code> and 
 * set the <code>hasDebugMessages</code> property on one sublclass, 
 * typically the main manager for the application. </p>
 */
public class AClass extends EventDispatcher
{
	//--------------------------------------------------------------------------
    //
    //  Class Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Flag for broadcasting debug messages.
     */
    private static var debugMessagesEnabled:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AClass( self:AClass )
	{
		if( self != this)
        {
            //Only a subclass can pass a valid reference to self
            throw new IllegalOperationError( "Abstract class did not receive " 
                +  "reference to self. " + qualifiedClassName + " cannot be " 
                +  "instantiated directly." );
        }  
	} 
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	//----------------------------------
    //  hasDebugMessages
    //----------------------------------
    
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
    public function set hasDebugMessages( value:Boolean ):void
    {
        debugMessagesEnabled = value;
    }
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  qualifiedClassName
    //----------------------------------
    
    /**
     * The class name of the implemented class including the package
     * specification.
     */
    public final function get qualifiedClassName():String
    {
        return  getQualifiedClassName( this );
    }
    
    //----------------------------------
    //  className
    //----------------------------------
    
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
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Broadcasts a debug message to the <code>DebugConsole</code> and 
     * calls trace() on the message.
     *  
     * @param message The message to be sent.
     */
    public function traceDebugMessage( message:String ):void
    {
        if ( debugMessagesEnabled )
        {
            //Send debug messages to the internal debug console.
            trace( "DebugMessage: " + message );
            
            //Send debug messages to the DebugConsole.
			FlexGlobals.topLevelApplication.dispatchEvent(
                new DebugEvent( DebugEvent.SET_MESSAGE, message ) );
         }
    } 
    
    //--------------------------------------------------------------------------
    //
    //  Protected Methods
    //
    //--------------------------------------------------------------------------
    
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
    
    /**
     * Utility method to dispatch an event of the specified type.
     * 
     * @param The string event type.
     */
    protected function dispatchEventType( type:String ):void
    {
        if ( type != null )
        {
           dispatchEvent( new Event( type ) ); 
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override public function toString():String
    {
    	return "[Object " + className + "]";
    }
}

}