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
import flash.events.Event;

/**
 * Represents event objects that are specific to <code>AViewModel</code>
 * subclass actions. View models dispatch the following types of events:
 * 
 * <ul>
 *     <li>back</li>
 *     <li>cancel</li>
 *     <li>close</li>
 *     <li>closeHelp</li>
 *     <li>clear</li>
 *     <li>dirty</li>
 *     <li>execute</li>
 *     <li>next</li>
 *     <li>openHelp</li>
 *     <li>open</li>
 * </ul> 
 */
public class ViewModelEvent extends Event
{
	//--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
       
    /**
     * The ViewModelEvent.BACK constant defines the value of the type 
     * property of the event object for a back event.
     */
    public static const BACK:String = 
        "com.fosrias.events.ViewModelEvent.back";
        
	/**
	 * The ViewModelEvent.CANCEL constant defines the value of the type 
	 * property of the event object for a cancel event.
	 */
	public static const CANCEL:String = 
		"com.fosrias.events.ViewModelEvent.cancel";
	
	/**
	 * The ViewModelEvent.CLEAR constant defines the value of the type 
	 * property of the event object for a clear event.
	 */
	public static const CLEAR:String = 
		"com.fosrias.events.ViewModelEvent.clear";
	
	/**
     * The ViewModelEvent.CLOSE constant defines the value of the type 
     * property of the event object for a close event.
     */
    public static const CLOSE:String = 
        "com.fosrias.events.ViewModelEvent.close";
        
    /**
     * The ViewModelEvent.CLOSE_HELP constant defines the value of the type 
     * property of the event object for an closeHelp event.
     */
    public static const CLOSE_HELP:String = 
        "com.fosrias.events.ViewModelEvent.closeHelp";
        
    /**
     * The ViewModelEvent.DIRTY constant defines the value of the type 
     * property of the event object for a dirty event.
     */
    public static const DIRTY:String = 
        "com.fosrias.events.ViewModelEvent.dirty";
        
    /**
     * The ViewModelEvent.EXECUTE constant defines the value of the type 
     * property of the event object for a execute event. 
     */
    public static const EXECUTE:String = 
        "com.fosrias.events.ViewModelEvent.execute";
        
    /**
     * The ViewModelEvent.NEXT constant defines the value of the type 
     * property of the event object for a next event.
     */
    public static const NEXT:String = 
        "com.fosrias.events.ViewModelEvent.next";
        
    /**
     * The ViewModelEvent.OPEN constant defines the value of the type 
     * property of the event object for an open event.
     */
    public static const OPEN:String = 
        "com.fosrias.events.ViewModelEvent.open";
        
    /**
     * The ViewModelEvent.OPEN_HELP constant defines the value of the type 
     * property of the event object for an openHelp event.
     */
    public static const OPEN_HELP:String = 
        "com.fosrias.events.ViewModelEvent.openHelp";
           
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ViewModelEvent( type:String, data:Object = null, 
        reference:String = null )
    {
    	//Does not bubble
        super( type );
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
        return new ViewModelEvent( type, data, reference );
    }
}
  
}