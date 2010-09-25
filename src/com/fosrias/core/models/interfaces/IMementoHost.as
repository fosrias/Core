////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.models.interfaces
{
import com.fosrias.core.namespaces.memento_internal;

use namespace memento_internal

/**
 * The IMementoRestore interface is implemented on classes who use IMemento
 * implementations to restore state information. Classes implementing this
 * interface must use the namespace memento_internal.
 * 
 * @see com.fosrias.core.models.interfaces.IMemento
 */
public interface IMementoHost
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  memento
    //----------------------------------
    
    /**
     * Returns a new instance of the an IMemento implementation.
     */
    function get memento():IMemento;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
 
    /**
     * Restores the state of an object from the memento. This function
	 * must call them mementos restore function.
     * 
     * @param memento The memento carrying state information.
     */
	function restore(memento:IMemento):*
}

}