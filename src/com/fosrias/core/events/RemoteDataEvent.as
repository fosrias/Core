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
 * Represents event objects that are specific to <code>AState</code>
 * and <code>AStateManager</code> subclasses, which dispatch 
 * the following types of events:
 * 
 * <ul>
 *     <li>create</li>
 *     <li>destroy</li>
 *     <li>index</li>
 *     <li>show</li>
 *     <li>update</li>
 * </ul> 
 */
public class RemoteDataEvent extends Event
{
	//--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The RemoteDataEvent.CREATE constant defines the value of the 
     * type property of the event object for a create event.
     */
    public static const CREATE:String 
        = "com.fosrias.core.events.RemoteDataEvent.create";
    
    /**
     * The RemoteDataEvent.DESTROY constant defines the value of the type 
     * property of the event object for a delete event.
     */
    public static const DESTROY:String = 
        "com.fosrias.core.events.RemoteDataEvent.destroy";
    
    /**
     * The RemoteDataEvent.INDEX constant defines the value of the type 
     * property of the event object for an index event.
     */
    public static const INDEX:String = 
        "com.fosrias.core.events.RemoteDataEvent.index";
    
    /**
     * The RemoteDataEvent.SHOW constant defines the value of the type 
     * property of the event object for a show event.
     */
    public static const SHOW:String = 
        "com.fosrias.core.events.RemoteDataEvent.show";
    
    /**
     * The RemoteDataEvent.UPDATE constant defines the value of the type 
     * property of the event object for a update event.
     */
    public static const UPDATE:String = 
        "com.fosrias.core.events.RemoteDataEvent.update";
        
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function RemoteDataEvent(type:String, 
                                    data:Object = null, 
                                    reference:String = null, 
                                    bubbles:Boolean = false)
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
    	return new RemoteDataEvent( type, data, reference );
    }
}
  
}