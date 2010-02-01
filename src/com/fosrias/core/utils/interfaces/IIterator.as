////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils.interfaces
{
/**
* The IIterator interface is implemented by all concrete iterator classes. 
*/
public interface IIterator
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  bof
    //----------------------------------
    
    /**
     * Whether the cursor is at the beginning of the file.
     */
    function get bof():Boolean;
    
    //----------------------------------
    //  bookmark
    //----------------------------------
    
    /**
     * The bookmark for the iterator.
     * 
     * @param value The basicProperty.
     * 
     */
    function get bookmark():int;
     
    /**
     * @private
     */    
    function set bookmark(value:int):void;
    
    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * The clone of the current iterator.
     * 
     * @return A new iterator.
     * 
     */
    function get clone():IIterator;
    
    //----------------------------------
    //  eof
    //----------------------------------
    
    /**
     * Whether the cursor is at the end of the file.
     */
    function get eof():Boolean;
    
    //----------------------------------
    //  length
    //----------------------------------
    
    /**
     * The number of items in the iterator.
     */
    function get length():int;
    
    //----------------------------------
    //  value
    //----------------------------------
    
    /**
     * The value for the iterator at its current location.
     * 
     * This property is injected by the LoginEventMap
     * 
     * @param value Whether the iterator has a next item.
     * 
     */
    function get value():*;
    
    /**
     * @private 
     */
    function set value(value:*):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Adds an item to the iterator.
     */    
    function addItem(value:Object):void;
    
    /**
     * Adds an item to the iterator at the specified index.
     */    
    function addItemAt(value:Object, index:int):void;
    
    /**
     * Moves the cursor to the first item in the iterator.  
     */
    function moveFirst():void;
    
    /**
     * Moves the cursor to the last item in the iterator.  
     */
    function moveLast():void;
    
    /**
     * Moves the cursor to the next item in the iterator.  
     */
    function moveNext():void;
    
    /**
     * Moves the cursor to the previous item in the iterator.  
     */
    function movePrevious():void;
    
    /**
     * Returns the item at the current cursor location and moves the 
     * cursor to the next item.
     * 
     * @return The item.
     * 
     */
    function next():*;
    
    /**
     * Returns the item at the current cursor location and moves the 
     * cursor to the previous item.
     * 
     * @return The item.
     * 
     */
    function previous():*;
    
    /**
     * Removes an item from the iterator at the specified index.
     */    
    function removeItemAt(index:int):Object;
}

}