////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.managers.fragment
{
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.events.ViewModelEvent;
import com.fosrias.core.events.WebBrowserEvent;
import com.fosrias.core.managers.interfaces.AState;
import com.fosrias.core.managers.interfaces.AStatefulManager;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.views.models.SiteStatusViewModel;

use namespace app_internal;	
    
/**
 * The FragmentInvalidState class is the <code>FragmentManager</code> state
 * set when the browser address is invalid.
 * 
 * @see com.fosrias.core.managers.fragments.FragmentManager
 */
public class FragmentInvalidState extends AState
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function FragmentInvalidState( type:String, manager:AStatefulManager )
    {
        super( this, type, manager );
        
        //Set storage variables
        setModelProperties( modelTitle, SiteStatusViewModel.INVALID) ;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  manager
    //----------------------------------
        
    /**
     * The state manager.
     */
    protected function get manager():FragmentManager
    {
        return FragmentManager( super.manager );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc 
     */
    override protected function executeImpl( event:ViewModelEvent = null ):void
    {
    	switch( manager.selectedLink )
    	{
    		case SiteStatusViewModel.BACK:
    		{
    			dispatchEvent( new WebBrowserEvent( WebBrowserEvent.BACK ) );
    			break;
    		}
    		case SiteStatusViewModel.HOME:
            {
            	dispatchEvent( new StateEvent( StateEvent.SET_STATE, null, 
            	    AState.HOME_STATE ) );
                break;
            }
            case SiteStatusViewModel.LOGIN:
            {
            	dispatchEvent( new StateEvent( StateEvent.SET_STATE, null,
                    AState.LOGIN_STATE ) );
                break;
            }
    	}
    }
    
    /**
     * @inheritDoc 
     */
    override protected function resetImpl():void
    {
    	manager.setModelViewStackIndex( 1 );
    }
}

}