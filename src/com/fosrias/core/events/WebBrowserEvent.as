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

import mx.events.BrowserChangeEvent;

/**
 * Represents event objects that are specific to web browser interactions.
 * 
 * <ul>
 *     <li>applicationUrlChange</li>
 *     <li>back</li>
 *     <li>browserUrlChange</li>
 *     <li>urlChange</li>
 *     <li>setFragment</li>
 *     <li>setApplicationTitle</li>
 *     <li>setTitle</li>
 * </ul> 
 * 
 * @see com.fosrias.core.managers.WebBrowserManager
 */
public class WebBrowserEvent extends BrowserChangeEvent
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The WebBrowserEvent.APPLICATION_URL_CHANGE constant defines the 
     * value of the type property of the event object for an
     * applicationURLChange event.
     */
    public static const APPLICATION_URL_CHANGE:String 
        = "com.fosrias.core.events.WebBrowserEvent.applicationURLChange";
    
    /**
     * The WebBrowserEvent.BACK constant defines the value of the 
     * type property of the event object for a back event.
     */
    public static const BACK:String 
        = "com.fosrias.core.events.WebBrowserEvent.back";
    
    /**
     * The WebBrowserEvent.BROWSER_URL_CHANGE constant defines the value of the 
     * type property of the event object for a browserURLChange event.
     */
    public static const BROWSER_URL_CHANGE:String 
        = "com.fosrias.core.events.WebBrowserEvent.browserURLChange";
    
    /**
     * The WebBrowserEvent.SET_FRAGMENT constant defines the value of the 
     * type property of the event object for a setFragment event.
     */
    public static const SET_FRAGMENT:String 
        = "com.fosrias.core.events.WebBrowserEvent.setFragment";
     
    /**
     * The WebBrowserEvent.SET_TITLE constant defines the value of the 
     * type property of the event object for a setTitle event.
     */
    public static const SET_TITLE:String 
        = "com.fosrias.core.events.WebBrowserEvent.setTitle";
        
    /**
     * The WebBrowserEvent.SET_APPLICATION_TITLE constant defines 
     * the value of the type property of the event object for a 
     * setApplicationTitle event.
     */
    public static const SET_APPLICATION_TITLE:String 
        = "com.fosrias.core.events.WebBrowserEvent.setApplicationTitle";
        
    /**
     * The WebBrowserEvent.URL_CHANGE constant defines the value of the 
     * type property of the event object for a urlChange event.
     */
    public static const URL_CHANGE:String 
        = "com.fosrias.core.events.WebBrowserEvent.urlChange";
        
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function WebBrowserEvent( type:String, url:String = null,
        lastURL:String = null, reference:String = null )
    {
    	super( type, true, false, url, lastURL );
    	_reference = reference;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  reference
    //----------------------------------
    
    /**
     * @private
     * Storage for the reference property 
     */
    private var _reference:String;
    
    /**
     * The reference payload.
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
        return new WebBrowserEvent( type, url, lastURL, reference );
    }
}
  
}