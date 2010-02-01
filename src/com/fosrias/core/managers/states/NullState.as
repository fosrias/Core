////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosware.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.managers.states
{
import com.fosrias.core.managers.interfaces.AState;
import com.fosrias.core.managers.interfaces.AStatefulManager;

/**
* The NullState class is the default state in a state manager. 
*/
public class NullState extends AState
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function NullState( manager:AStatefulManager )
	{
	   super( this, "nullState", manager );
	}
}

}