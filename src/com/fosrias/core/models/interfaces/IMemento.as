
package com.fosrias.core.models.interfaces
{
/**
 * The IMemento interface is implemented on classes who carry state
 * information. 
 */
public interface IMemento
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
     * @param object The object to restore state to.
     */
	function restoreTo( object:Object ):*
        
    /**
     * Clears the property map in a memento for garbage collection. 
     */
    function clear():void
}

}