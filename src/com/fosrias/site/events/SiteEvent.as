////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.events
{
import com.fosrias.core.events.DataPayloadEvent;

import flash.events.Event;

/**
 * Represents event objects that are specific to site managment
 * of the following types:"
 * 
 * <ul>
 *     <li>com.fosrias.core.events.SiteEvent.initialize</li>
 * 	   <li>com.fosrias.core.events.SiteEvent.loadDefaults</li>
 * 	   <li>com.fosrias.core.events.SiteEvent.login</li>
 * 	   <li>com.fosrias.core.events.SiteEvent.logout</li>
 * 	   <li>com.fosrias.core.events.SiteEvent.openLink</li>
 * 	   <li>com.fosrias.core.events.SiteEvent.openList</li>
 *     <li>com.fosrias.core.events.SiteEvent.registerLists</li>
 *     <li>com.fosrias.core.events.SiteEvent.search</li>
 *     <li>com.fosrias.core.events.SiteEvent.servicesInitialized</li>
 *     <li>com.fosrias.core.events.SiteEvent.showList</li>
 * </ul> 
 */
public class SiteEvent extends DataPayloadEvent
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The SiteEvent.INITIALIZE constant defines the value of the 
	 * type property of the event object for a initialize event.
	 */
	public static const INITIALIZE:String 
	= "com.fosrias.core.events.SiteEvent.initialize";
	
	/**
	 * The SiteEvent.LOAD_DEFAULTS constant defines the value of the 
	 * type property of the event object for a loadDefaults event.
	 */
	public static const LOAD_DEFAULTS:String 
	= "com.fosrias.core.events.SiteEvent.loadDefaults";
	
	/**
	 * The SiteEvent.LOGIN constant defines the value of the 
	 * type property of the event object for a login event.
	 */
	public static const LOGIN:String 
	= "com.fosrias.core.events.SiteEvent.login";
	
	/**
	 * The SiteEvent.LOGOUT constant defines the value of the 
	 * type property of the event object for a logout event.
	 */
	public static const LOGOUT:String 
	= "com.fosrias.core.events.SiteEvent.logout";
	
	/**
	 * The SiteEvent.OPEN_LINK constant defines the value of the 
	 * type property of the event object for a openLink event.
	 */
	public static const OPEN_LINK:String 
	= "com.fosrias.core.events.SiteEvent.openLink";
	
	/**
	 * The SiteEvent.OPEN_LIST constant defines the value of the 
	 * type property of the event object for a openList event.
	 */
	public static const OPEN_LIST:String 
	= "com.fosrias.core.events.SiteEvent.openList";
	
	/**
	 * The SiteEvent.REGISTER_LISTS constant defines the value of the 
	 * type property of the event object for a registerLists event.
	 */
	public static const REGISTER_LISTS:String 
	= "com.fosrias.core.events.SiteEvent.registerLists";
	
	/**
	 * The SiteEvent.SEARCH constant defines the value of the 
	 * type property of the event object for a search event.
	 */
	public static const SEARCH:String 
	= "com.fosrias.core.events.SiteEvent.search";
	
	/**
	 * The SiteEvent.SERVICES_INITIALIZED constant defines the value of the 
	 * type property of the event object for a servicesInitialized event.
	 */
	public static const SERVICES_INITIALIZED:String 
	= "com.fosrias.core.events.SiteEvent.servicesInitialized";
	
	/**
	 * The SiteEvent.SHOW_LIST constant defines the value of the 
	 * type property of the event object for a showList event.
	 */
	public static const SHOW_LIST:String 
	= "com.fosrias.core.events.SiteEvent.showList";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function SiteEvent(type:String, 
							  data:Object=null, 
							  kind:String=null, 
							  bubbles:Boolean=true, 
							  relatedEvent:Event=null)
	{
		super(type, data, kind, bubbles, relatedEvent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	override public function clone():Event
	{
		return new SiteEvent(type, data, reference, bubbles, relatedEvent);
	}
}
	
}