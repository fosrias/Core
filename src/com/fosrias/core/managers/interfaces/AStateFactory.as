////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.managers.interfaces
{
import com.fosrias.core.interfaces.AFactory;

public class AStateFactory extends AFactory
{
	//--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    //Define static constants as state keys here.
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AStateFactory(self:AStateFactory)
	{
        super(self);
	}

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override protected function instantiateImpl(factoryType:*, type:String, 
        args:Array):*
    {
    	return new factoryType(type, args[0]);
    }
}

}