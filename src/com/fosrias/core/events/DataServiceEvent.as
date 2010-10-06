////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010   Mark W. Foster  www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.events
{

import flash.events.Event;

/**
 * Represents event objects that are specific to <code>ADataService</code> and 
 * <code>ARESTfulDataService</code> remote methods of the following types:"
 * 
 * <ul>
 *     <li>call</li>
 *     <li>callElements</li>
 *     <li>callType</li>
 *     <li>callTypes</li>
 *     <li>count</li>
 *     <li>destroy</li>
 *     <li>create</li>
 *     <li>index</li>
 *     <li>indexPaged</li>
 *     <li>show</li>
 *     <li>search</li>
 *     <li>searchCount</li>
 *     <li>searchPage</li> 
 *     <li>show</li>
 *     <li>update</li>   
 * </ul> 
 */
public class DataServiceEvent extends DataPayloadEvent
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The DataServiceEvent.CALL constant defines the value of the 
	 * type property of the event object for a call event.
	 */
	public static const CALL:String 
	= "com.fosrias.core.events.DataServiceEvent.call";
	
	/**
	 * The DataServiceEvent.CALL_ELEMENTS constant defines the value of the 
	 * type property of the event object for a callElements event.
	 */
	public static const CALL_ELEMENTS:String 
	= "com.fosrias.core.events.DataServiceEvent.callElements";
	
	/**
	 * The DataServiceEvent.CALL_TYPE constant defines the value of the 
	 * type property of the event object for a callType event.
	 */
	public static const CALL_TYPE:String 
	= "com.fosrias.core.events.DataServiceEvent.callType";
	
	/**
	 * The DataServiceEvent.CALL_TYPES constant defines the value of the 
	 * type property of the event object for a callTypes event.
	 */
	public static const CALL_TYPES:String 
	= "com.fosrias.core.events.DataServiceEvent.callTypes";
	
	/**
	 * The DataServiceEvent.COUNT constant defines the value of the 
	 * type property of the event object for a count event.
	 */
	public static const COUNT:String 
	= "com.fosrias.core.events.DataServiceEvent.count";
	
	/**
	 * The DataServiceEvent.CREATE constant defines the value of the 
	 * type property of the event object for a create event.
	 */
	public static const CREATE:String 
	= "com.fosrias.core.events.DataServiceEvent.create";
	
	/**
	 * The DataServiceEvent.DESTROY constant defines the value of the type 
	 * property of the event object for a delete event.
	 */
	public static const DESTROY:String = 
		"com.fosrias.core.events.DataServiceEvent.destroy";
	
	/**
	 * The DataServiceEvent.INDEX constant defines the value of the type 
	 * property of the event object for an index event.
	 */
	public static const INDEX:String = 
		"com.fosrias.core.events.DataServiceEvent.index";
	
	/**
	 * The DataServiceEvent.INDEX_PAGED constant defines the value of the type 
	 * property of the event object for an indexPaged event.
	 */
	public static const INDEX_PAGED:String = 
		"com.fosrias.core.events.DataServiceEvent.indexPaged";
	
	/**
	 * The DataServiceEvent.SEARCH constant defines the value of the type 
	 * property of the event object for a search event.
	 */
	public static const SEARCH:String = 
		"com.fosrias.core.events.DataServiceEvent.search";
	
	/**
	 * The DataServiceEvent.SEARCH_COUNT constant defines the value of the type 
	 * property of the event object for a searchCount event.
	 */
	public static const SEARCH_COUNT:String = 
		"com.fosrias.core.events.DataServiceEvent.searchCount";
	
	/**
	 * The DataServiceEvent.SEARCH_PAGED constant defines the value of the type 
	 * property of the event object for a searchPaged event.
	 */
	public static const SEARCH_PAGED:String = 
		"com.fosrias.core.events.DataServiceEvent.searchPaged";
	
	/**
	 * The DataServiceEvent.SHOW constant defines the value of the type 
	 * property of the event object for a show event.
	 */
	public static const SHOW:String = 
		"com.fosrias.core.events.DataServiceEvent.show";
	
	/**
	 * The DataServiceEvent.UPDATE constant defines the value of the type 
	 * property of the event object for a update event.
	 */
	public static const UPDATE:String = 
		"com.fosrias.core.events.DataServiceEvent.update";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function DataServiceEvent(type:String, 
									 data:Object=null, 
									 reference:String=null, 
									 bubbles:Boolean=true, 
									 relatedEvent:Event=null)
	{
		super(type, data, reference, bubbles, relatedEvent);
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
		return new DataServiceEvent(type, data, reference, bubbles, 
			relatedEvent);
	}
}

}