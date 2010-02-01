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
import com.fosrias.core.utils.cookies.CookieEvent;

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

/**
 * 
 * @author Mark W. Foster
 * 
 */
public class CookieLoader extends EventDispatcher
{ 
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function CookieLoader() {}
        
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    public function create(name:String, value:Object, time:int = 0):void
    {
        CookieUtil.create(name, value, time);
        dispatchEvent(new CookieEvent(CookieEvent.CREATED, name, value));
    }
    
    public function destroy(name:String):void
    {
    	CookieUtil.destroy(name);
    }
    
    public function read(name:String):void
    {
    	if (hasCookiesEnabled())
    	{
    	   var cookieValue:Object = CookieUtil.read(name);
    	   if (cookieValue != null)
    	   {
                dispatchEvent(new CookieEvent(CookieEvent.FOUND, 
                    name, cookieValue));
                return;
            }
        }
        dispatchEvent(new CookieEvent(CookieEvent.NOT_FOUND, name, cookieValue));
    }
    
    private function hasCookiesEnabled():Boolean
    {
    	var enabled:Boolean = CookieUtil.enabled;
    	if (enabled)
    	{
    		dispatchEvent(new CookieEvent(CookieEvent.ENABLED));
    	} else {
    		dispatchEvent(new CookieEvent(CookieEvent.DISABLED));
    	}
    	return enabled;
    }
}

}