////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.models.interfaces
{
	
/**
 * The IMemento interface is implemented on classes who carry state
 * information. 
 */
public interface IMemento extends IIsEqual
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  isEmpty
    //----------------------------------
    
    /**
     * Whether the memento has been cleared or not.
     */
    function get isEmpty():Boolean;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
 
    /**
     * Restores the state of an object from the memento.
     * 
     * @param value The object to restore its state to that of the memento.
	 * @param clearForGC Clears the memento for garbage collection.
     */
	function restore(value:Object, 
					 clearForGC:Boolean = true):*
        
    /**
     * Clears the property map in a memento for garbage collection. 
     */
    function clear():void
}

}