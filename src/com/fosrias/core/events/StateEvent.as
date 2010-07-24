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
 * Represents event objects that are specific to <code>AState</code>
 * and <code>AStateManager</code> subclasses, which dispatch 
 * the following types of events:
 * 
 * <ul>
 *     <li>closed</li>
 *     <li>loggedIn</li>
 *     <li>loggedOut</li>
 *     <li>register</li>
 *     <li>resetHome</li>
 *     <li>setSubstate</li>
 *     <li>setState</li>
 *     <li>siteInitialzed</li>
 *     <li>stateSet</li>
 * </ul> 
 * 
 * @see com.fosrias.core.interface.AState
 * @see com.fosrias.core.interface.AStateManager
 * @see com.fosrias.core.views.interfaces.AViewModel.
 */
public class StateEvent extends DataPayloadEvent
{
	//--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The StateEvent.CLOSED constant defines the value of the 
     * type property of the event object for a closed event.
     */
    public static const CLOSED:String 
        = "com.fosrias.core.events.StateEvent.closed";
    
    /**
     * The StateEvent.LOGGED_IN constant defines the value of the type 
     * property of the event object for a loggedIn event.
     */
    public static const LOGGED_IN:String = 
        "com.fosrias.core.events.StateEvent.loggedIn";
    
    /**
     * The StateEvent.LOGGED_OUT constant defines the value of the type 
     * property of the event object for a loggedOut event.
     */
    public static const LOGGED_OUT:String = 
        "com.fosrias.core.events.StateEvent.loggedOut";
        
    /**
     * The StateEvent.REGISTER constant defines the value of the type 
     * property of the event object for a register event.
     */
    public static const REGISTER:String 
        = "com.fosrias.core.events.StateEvent.register";
        
    /**
     * The StateEvent.RESET_HOME constant defines the value of the type 
     * property of the event object for a resetHome event.
     */
    public static const RESET_HOME:String 
        = "com.fosrias.core.events.StateEvent.resetHome";
        
    /**
     * The StateEvent.SET_SUBSTATE constant defines the value of the type 
     * property of the event object for a setSubstate event.
     */
    public static const SET_SUBSTATE:String = 
        "com.fosrias.core.events.StateEvent.setSubstate";
        
    /**
     * The StateEvent.SET_STATE constant defines the value of the type 
     * property of the event object for a setState event.
     */
    public static const SET_STATE:String = 
        "com.fosrias.core.events.StateEvent.setState";
	        
    /**
     * The StateEvent.SITE_INITIALIZED constant defines the value of the 
     * type property of the event object for a siteInitialized event.
     */
    public static const SITE_INITIALIZED:String 
        = "com.fosrias.core.events.StateEvent.siteInitialized";       
    /**
     * The StateEvent.STATE_SET constant defines the value of the type 
     * property of the event object for a stateSet event.
     */
    public static const STATE_SET:String = 
        "com.fosrias.core.events.StateEvent.stateSet";
        
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function StateEvent(type:String, data:Object = null, 
        reference:String = null, relatedEvent:Event = null)
    {
        super(type, data, reference, true, relatedEvent);
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
    	return new StateEvent(type, data, reference, relatedEvent);
    }
}
  
}