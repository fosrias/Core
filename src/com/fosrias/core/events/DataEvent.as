////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.events
{
import flash.events.Event;

/**
 * Base class for data and reference payload events.
 */
public class DataEvent extends Event
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function DataEvent(type:String, data:Object = null, 
        reference:String = null, bubbles:Boolean = true)
    {
        super(type, bubbles);
        _data = data;
        _reference = reference;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  data
    //----------------------------------
    
    /**
     * @private
     * Storage for the data property 
     */
    private var _data:Object;
    
    /**
     * The data payload.
     */
    public function get data():Object
    {
    	return _data;
    }
    
    //----------------------------------
    //  reference
    //----------------------------------
    
    /**
     * @private
     * Storage for the reference property 
     */
    private var _reference:String;
    
    /**
     * A reference associated with the event and its payload, if any.
     */
    public function get reference():String
    {
        return _reference;
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
        return new DataEvent(type, data, reference);
    }
}
  
}