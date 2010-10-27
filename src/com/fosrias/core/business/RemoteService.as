////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.business
{
import com.fosrias.core.business.interfaces.AService;


public class RemoteService extends AService
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function RemoteService(showBusyCursor:Boolean=false)
	{
		super(this, showBusyCursor);
	}
}
	
}