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
import com.fosrias.core.interfaces.AFactory;

/**
 * The AViewFactory is the base class for all view or popUp simple factories 
 * that create UIComponents.
 */
public class AViewFactory extends AFactory
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AViewFactory( self:AViewFactory ) 
    {
    	super( self );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     * 
     * <p>Overridden to always instantiate the <code>factoryType</code>.
     */
    override protected function instantiateImpl( factoryType:*, type:*, 
        args:Array ):*
    {
        return new factoryType();
    }  
}

}