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
import flash.events.Event;
import flash.events.IEventDispatcher;

[Bindable]
/**
 * The ADispatcher class is the base class for all abstract classes that
 * have a <code>dispatcher</code> property to reference an external dispatcher.
 */
public class ADispatcher extends AClass
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ADispatcher( self:ADispatcher )
	{
		super( self );  
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dispatcher
    //----------------------------------
    
    /**
     * @private 
     * Storage for the dispatcher property. 
     */
    protected var _dispatcher:IEventDispatcher;
    
    /**
     * The dispatcher for the class.
     */
    public function get dispatcher():IEventDispatcher
    {
        return _dispatcher;
    } 
    
    /**
     * @private
     */    
    public function set dispatcher( value:IEventDispatcher ):void
    {
        _dispatcher = value;
    }
}

}