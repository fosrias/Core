////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils.cookies
{
import flash.events.Event;

/**
 * Represents event objects that are specific to browser session actions. Login
 * related models and managers dispatch the following types of events:
 * 
 * <ul>
 *     <li>create</li>
 *     <li>created</li>
 *     <li>destroy</li>
 *     <li>disabled</li>
 *     <li>enabled</li>
 *     <li>found</li>
 *     <li>read</li>
 * </ul> 
 * 
 */
public class CookieEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The CookieEvent.CREATE constant defines the value of the 
     * type property of the event object for a create event.
     */
    public static const CREATE:String 
        = "com.fosrias.events.CookieEvent.create";
    
    /**
     * The CookieEvent.CREATED constant defines the value of the 
     * type property of the event object for a created event.
     */
    public static const CREATED:String 
        = "com.fosrias.events.CookieEvent.created";
    
    /**
     * The CookieEvent.DESTROYED constant defines the value of the 
     * type property of the event object for a destroy event.
     */
    public static const DESTROY:String 
        = "com.fosrias.events.CookieEvent.destroy";
        
    /**
     * The CookieEvent.DISABLED constant defines the value of the 
     * type property of the event object for a disabled event.
     */
    public static const DISABLED:String 
        = "com.fosrias.events.CookieEvent.disabled";
                
    /**
     * The CookieEvent.ENABLED constant defines the value of the 
     * type property of the event object for a cookiesEnabled event.
     */
    public static const ENABLED:String 
        = "com.fosrias.events.CookieEvent.enabled";
    
    /**
     * The CookieEvent.FOUND constant defines the value of the type 
     * property of the event object for a found event.
     */
    public static const FOUND:String = 
        "com.fosrias.events.CookieEvent.found";
               
    /**
     * The CookieEvent.NOT_FOUND constant defines the value of the type 
     * property of the event object for a notFound event.
     */
    public static const NOT_FOUND:String = 
        "com.fosrias.events.CookieEvent.notFound";
               
    /**
     * The CookieEvent.READ constant defines the value of the type 
     * property of the event object for a READ event.
     */
    public static const READ:String = 
        "com.fosrias.events.CookieEvent.read";
        
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function CookieEvent(type:String, name:String = null, 
        value:Object = null, expiration:int = -1)
    {
        super(type,true);
        _name = name;
        _value = value;
        _expiration = expiration;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  name
    //----------------------------------
    
    /**
     * @private
     * Storage for the name property 
     */
    private var _name:String;
    
    /**
     * 
     * @return The associated name for the cookie.
     * 
     */
    public function get name():String
    {
        return _name;
    }
    
    //----------------------------------
    //  expiration
    //----------------------------------
    
    /**
     * @private
     * Storage for the expiration property 
     */
    private var _expiration:int;
    
    /**
     * 
     * @return The associated expiration for the cookie.
     * 
     */
    public function get expiration():int
    {
        return _expiration;
    }
     
    //----------------------------------
    //  value
    //----------------------------------
    
    /**
     * @private
     * Storage for the value property 
     */
    private var _value:Object;
    
    /**
     * 
     * @return The associated value for the cookie.
     * 
     */
    public function get value():Object
    {
        return _value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override public function clone():Event
    {
    	return new CookieEvent(type, name, value, expiration);
    }
}
  
}