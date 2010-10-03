////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009-2010   Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.interfaces
{
import com.fosrias.core.events.ViewModelEvent;
import com.fosrias.core.events.WebBrowserEvent;
import com.fosrias.core.views.interfaces.AViewModel;

import flash.events.Event;

[Bindable]
public class AMainViewModel extends AViewModel
{  
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AMainViewModel(self:AMainViewModel)
	{
	   super(self);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Injected properties
    //
    //--------------------------------------------------------------------------
    
	//----------------------------------
	//  menuBarDataProvider
	//----------------------------------
	
	public var menuBarDataProvider:Object;
	
	//----------------------------------
	//  menuBarDataProvider
	//----------------------------------
	
	public var bodyViewStackIndex:int = 0;
	
	//----------------------------------
    //  setSiteItems
    //----------------------------------
    
    /**
     * @private
     * Storage for the mainViewStackIndex property. 
     */    
    
    public function setSiteItems(value:Object):void
    {
        
    }
    
    //----------------------------------
    //  mainViewStackIndex
    //----------------------------------
    
    /**
     * @private
     * Storage for the mainViewStackIndex property. 
     */    
    private var _mainViewStackIndex:int
    
    [Bindable(event="viewStackIndexChanged")]
	[Deprecated]
    /**
     * 
     * @return 
     * 
     */    
    public function get mainViewStackIndex():int
    {
        return _mainViewStackIndex;
    }
    
    /**
     * @private
     */    
    public function set mainViewStackIndex(value:int):void
    {
        _mainViewStackIndex = value;
        dispatchEvent(new Event("viewStackIndexChanged"));
    }
    
    //----------------------------------
    //  pageViewStackIndex
    //----------------------------------
    
    /**
     * @private
     * Storage for the pageViewStackIndex property. 
     */    
    private var _pageViewStackIndex:int
    
    [Bindable(event="viewStackIndexChanged")]
    /**
     * 
     * @return 
     * 
     */    
    public function get pageViewStackIndex():int
    {
        return _pageViewStackIndex;
    }
    
    /**
     * @private
     */    
    public function set pageViewStackIndex(value:int):void
    {
        _pageViewStackIndex = value;
        dispatchEvent(new Event("viewStackIndexChanged"));
    }
    
    //----------------------------------
    //  siteViewStackIndex
    //----------------------------------
    
    /**
     * @private
     * Storage for the siteViewStackIndex property. 
     */    
    private var _siteViewStackIndex:int
    
    [Bindable(event="viewStackIndexChanged")]
    /**
     * 
     * @return 
     * 
     */    
    public function get siteViewStackIndex():int
    {
        return _siteViewStackIndex;
    }
    
    /**
     * @private
     */    
    public function set siteViewStackIndex(value:int):void
    {
        _siteViewStackIndex = value;
        dispatchEvent(new Event("viewStackIndexChanged"));
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  menubarDataProvider
    //----------------------------------
    
    /**
     * @private
     * Storage for the menubarDataProvider property 
     */
    private var _menubarDataProvider:Object;
    
    /**
     * @private 
     */
    private var _menubarSessionDataProvider:Object;
    
    [Bindable("sessionChange")]
    /**
     * The data provider for the site menu bar.
     */
    public function get menubarDataProvider():Object
    {
        if (hasSession)
        {
            return _menubarSessionDataProvider;
        } else {
            return _menubarDataProvider;
        }
    }
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * A utility method that dispatches a <code>ViewModelEvent.MENU_CHANGE</code> 
	 * event.
	 *  
	 * @param args Optional arguments passed to the <code>data</code> property
	 * of the <code>ViewModelEvent</code>.
	 */
	public function menuChange( ... args ):void
	{ 
		dispatchEvent( new ViewModelEvent(ViewModelEvent.MENU_CHANGE, args) );
	}
	
	
}

}