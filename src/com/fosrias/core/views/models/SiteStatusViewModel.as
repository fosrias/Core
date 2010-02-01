////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.models
{
import com.fosrias.core.events.ViewModelEvent;
import com.fosrias.core.views.interfaces.AViewModel;

public class SiteStatusViewModel extends AViewModel
{
	//--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    //Link Types
    
    public static const BACK:String 
        = "com.fosrias.managers.states.AddressStatusViewModel.back";
        
    public static const HOME:String 
        = "com.fosrias.managers.states.AddressStatusViewModel.home";
    
    public static const LOGIN:String 
        = "com.fosrias.managers.states.AddressStatusViewModel.login";
    
    //View States
    public static const INVALID:String = "";
    
    public static const REQUIRES_SESSION:String 
        = "urlRequiresSession";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function SiteStatusViewModel()
	{
	   super(this);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
       
    /** 
     * Responds to home link selection.
     */
    public function home():void
    {
    	processLink(HOME);
    }
    
    /** 
     * Responds to login link selection.
     */
    public function login():void
    {
    	processLink(LOGIN);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
       
    /**
     * @private
     */
    private function processLink(type:String):void
    {
    	setDirty(new ViewModelEvent(ViewModelEvent.DIRTY, type));
        execute();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
       
    /**
     * @inheritDoc 
     */
    override public function back( ... args ):void
    {
    	processLink(BACK);
    }
}

}