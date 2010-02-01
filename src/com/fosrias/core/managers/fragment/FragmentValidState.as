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

use namespace app_internal;

/**
 * The FragmentValidState class is the <code>FragmentManager</code> state
 * set when browser address is valid.
 * 
 * @see com.fosrias.core.managers.fragments.FragmentManager
 */
public class FragmentValidState extends FragmentInvalidState
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function FragmentValidState( type:String, manager:AStatefulManager )
	{
	    super( type, manager );
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
	/**
     * @inheritDoc 
     */
    override protected function resetImpl():void
    {
        manager.setModelViewStackIndex( 0 );
    }
}

}