////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.events
{
import flash.events.Event;

/**
 * /**
 *  The SiteEventKind class contains constants for the valid values 
 *  of the com.fosrias.base.events.SiteEvent class <code>kind</code> property.
 *  These constants indicate the kind of data included in the event.
 */
public final class SiteEventKind
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Indicates that the data contains list items to be registered in the 
	 * <code>ListManager</code>.
	 */
	public static const REGISTER:String = "register";
	
	/**
	 * Indicates that the data contains list items to be registered in the 
	 * <code>ListManager</code>.
	 */
	public static const SHOW_ITEM:String = "showItem";
}
	
}