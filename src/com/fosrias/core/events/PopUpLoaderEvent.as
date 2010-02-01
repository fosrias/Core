////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2009 Mark W. Foster
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
 * The PopUpLoaderEvent class represents objects used to maintain 
 * <code>PopUpLoader</code> show/hide functionality in the case that a 
 * parent <code>PopUpCanvas</code>, <code>PopUpPanel</code> or 
 * <code>PopUpTitle</code> component's visibility is changed as a 
 * function of its view state. 
 * 
 * <p>For example, a particular parent component view state might correspond to 
 * the parent component being hidden but a popup child still needing to be
 * shown. In such a case, the parent show/hide events will interfere with the 
 * <code>PopUpLoader</code> default functionality that listens to show/hide 
 * events associated with its parent component so that when the parent
 * visiblility changes in a navigation container, the popup shows/hides 
 * itself as well. However, setting the parent component visible/not visible
 * is indistinguisable to navigation container changes of a parent component
 * of a default <code>PopUpLoader</code>.</p>
 * 
 * <p>To overcome this:
 *    <ol>
 *    <li>Set the <code>hideEvent</code> and <code>showEvent</code> to
 *    the corresponding event in the <code>PopUpLoader</code>.</li>
 *    <li>Dispatch the corresponding <code>PopUpLoaderEvent</code> 
 *    event on the parent component in the navigation container show/hide 
 *    event handlers accordingly.</li>
 *    </ol>
 *</p>
 * 
 * <ul>
 *     <li>destroy</li>
 *     <li>hide</li>
 *     <li>show</li>
 * </ul> 
 * 
 * @see com.fosrias.core.utils.PopUpLoader
 */
public class PopUpLoaderEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The PopUpLoaderEvent.DESTROY constant defines the  value of the type 
     * property of the event object for a destroy event.
     */
    public static const DESTROY:String 
        = "com.fosrias.events.PopUpLoaderEvent.destroy";
    
    /**
     * The PopUpLoaderEvent.HIDE constant defines the  value of the type 
     * property of the event object for a hide event.
     */
    public static const HIDE:String 
        = "com.fosrias.events.PopUpLoaderEvent.hide";
    
    /**
     * The PopUpLoaderEvent.SHOW constant defines the value of the 
     * type property of the event object for a show event.
     */
    public static const SHOW:String 
        = "com.fosrias.events.PopUpLoaderEvent.show";
        
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function PopUpLoaderEvent( type:String )
    {
    	super(type);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * A clone of the event so the event can be redispatched.
     */
    override public function clone():Event
    {
    	return new PopUpLoaderEvent( type );
    }
}
  
}