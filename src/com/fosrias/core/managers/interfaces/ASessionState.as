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
import com.fosrias.core.managers.interfaces.AState;
import com.fosrias.core.managers.interfaces.AStatefulManager;

/**
 * The ASessionState class is the base state for all states that are dependent
 * on the session status of their manager. The 
 * <code>hasSessionRequirement</code> property is set to <code>true</code> for 
 * <code>ASessionState</code> states. 
 * 
 * <p>Extended <code>AState</code> can mimic <code>ASessionState</code> 
 * subclasses by overridding the <code>hasSessionRequirement</code> property 
 * to <code>true</code>. This latter case typically applies to managers 
 * that use both <code>AState</code> and <code>hasSessionRequirement</code> 
 * classes.</p>
 */
public class ASessionState extends AState
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ASessionState( self:AState, type:String, 
        manager:AStatefulManager )
	{
	   super( self, type, manager );
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------

	//----------------------------------
    //  hasSessionRequirement
    //----------------------------------
    
    /**
     * Whether the state requires a current session. This value is always 
     * <code>true</code> for <code>ASessionState</code> subclasses.
     */
    override public function get hasSessionRequirement():Boolean
    {
       return true;
    }
}

}