////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.interfaces
{
import flash.events.Event;
import com.fosrias.core.events.ViewModelEvent;
import com.fosrias.core.events.WebBrowserEvent;
import com.fosrias.core.views.interfaces.AViewModel;

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
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  mainViewStackIndex
    //----------------------------------
    
    /**
     * @private
     * Storage for the mainViewStackIndex property. 
     */    
    private var _mainViewStackIndex:int
    
    [Bindable(event="viewStackIndexChanged")]
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
}

}