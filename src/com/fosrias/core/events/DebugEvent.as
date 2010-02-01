////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.events
{
import com.fosrias.core.models.DebugMessage;

import flash.events.Event;

/**
 * Represents event objects that are specific to debug message handling.
 * 
 * @see com.fosrias.core.models.DebugMessage
 */
public class DebugEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The DebugEvent.SET_MESSAGE constant defines the value of the type 
     * property of the event object for a setMessage event.
     */
    public static const SET_MESSAGE:String 
        = "com.fosrias.core.events.DebugEvent.setMessage";
        
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function DebugEvent( type:String, message:String )
    {
    	super( type, true, false );
    	_message = new DebugMessage( message );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  message
    //----------------------------------
    
    /**
     * @private
     * Storage for the message property 
     */
    private var _message:DebugMessage;
    
    /**
     * The debug message.
     */
    public function get message():DebugMessage
    {
        return _message;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods 
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc 
     */
    override public function clone():Event
    {
        return new DebugEvent( type, _message.message );
    }
}
  
}