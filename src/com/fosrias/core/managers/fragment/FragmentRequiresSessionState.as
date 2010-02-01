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
import com.fosrias.core.managers.interfaces.AStatefulManager;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.views.models.SiteStatusViewModel;

use namespace app_internal;

/**
 * The FragmentInvalidState class is the <code>FragmentManager</code> state
 * set when the browser address corresponds to states that required a valid 
 * session and no session exists.
 * 
 * @see com.fosrias.core.managers.fragments.FragmentManager
 */
public class FragmentRequiresSessionState extends FragmentInvalidState
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function FragmentRequiresSessionState( type:String, 
        manager:AStatefulManager )
	{
	    super( type, manager );
	    
	    //Set storage variables
        setModelProperties( modelTitle, SiteStatusViewModel.REQUIRES_SESSION );
	}
}

}