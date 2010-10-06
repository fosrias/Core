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
import com.fosrias.core.vos.CallResult;

import mx.rpc.Fault;

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
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override protected function callFaultImpl(fault:Fault, ...args):*
	{
		//Do Nothing.
	}
	
	/**
	 * @inheritDoc
	 */
	override protected function callResultImpl(result:CallResult, ...args):*
	{
		//Do Nothing
	}
}

}