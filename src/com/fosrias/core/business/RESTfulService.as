////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.business
{
import com.fosrias.core.business.interfaces.ARESTfulService;
import com.fosrias.core.business.interfaces.AService;

/**
 * The RESTful service class is a concrete RESTful service.
 */
public class RESTfulService extends ARESTfulService
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function RESTfulService(showBusyCursor:Boolean=false)
	{
		super(this, showBusyCursor);
	}
}

}