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
import com.fosrias.core.managers.interfaces.AStateFactory;

/**
 * The FragementStateFactory class is the simple factory that creates states
 * for the <code>FragmentManager</code>.
 * 
 * @see com.fosrias.core.managers.fragments.FragmentManager
 */
public class FragmentStateFactory extends AStateFactory
{
	//--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The state type corresponding to the <code>FragmentInvalid</code> state. 
     */
    public static const INVALID:String 
        = "com.fosrias.core.managers.fragment.FragmentStateFactory.invalid";
     
    /**
     * The state type corresponding to the <code>FragmentRequiresSession</code> 
     * state. 
     */
    public static const REQUIRES_SESSION:String 
        = "com.fosrias.core.managers.fragment." + 
        		"FragmentStateFactory.requiresSession";
    
    /**
     * The state type corresponding to the <code>FragmentValid</code> state. 
     */
    public static const VALID:String 
        = "com.fosrias.core.managers.fragment.FragmentStateFactory.valid";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function FragmentStateFactory()
	{
	    super(this);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override protected function typesImpl():Array
    {
    	return [ INVALID,
    	         REQUIRES_SESSION,
    	         VALID ];
    }
    
    /**
     * @inheritDoc
     */
    override protected function mapImpl():void
    {
        _map[ INVALID ] = FragmentInvalidState;
        _map[ REQUIRES_SESSION ] = FragmentRequiresSessionState;
        _map[ VALID ] = FragmentValidState;
    }   
}

}