////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils
{
import com.fosrias.core.utils.interfaces.IIterator;

import mx.collections.ArrayCollection;

public class Iterator implements IIterator
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function Iterator( source:Array )
    {
        _collection = new ArrayCollection( source );
        _eof = source.length - 1;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var _collection:ArrayCollection;
    private var _index:int = 0;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  bof
    //----------------------------------
    
    /**
     * @private 
     * Storage for the bof property. 
     */
    private var _bof:int;
    
    /**
     * Whether the cursor is at the beginning of the file.
     */
    public function get bof():Boolean
    {
        return _index < _bof;
    }
    
    //----------------------------------
    //  bookmark
    //----------------------------------
    
    /**
     * @private 
     * Storage for the bookmark property. 
     */
    private var _bookmark:int;
    
    /**
     * The bookmark for the iterator.
     * 
     * @param value The basicProperty.
     * 
     */
    public function get bookmark():int
    {
        return _index;
    }
     
    /**
     * @private
     */    
    public function set bookmark( value:int ):void
    {
        _index = value;
    }
    
    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * The clone of the current iterator.
     * 
     * @return The iterator.
     * 
     */
    public function get clone():IIterator
    {
        return new Iterator( _collection.source.slice() );
    }
    
    //----------------------------------
    //  eof
    //----------------------------------
    
    /**
     * @private 
     * Storage for the eof property. 
     */
    private var _eof:int;
    
    /**
     * Whether the cursor is at the end of the file.
     */
    public function get eof():Boolean
    {
        return _index > _eof;
    }
    
    //----------------------------------
    //  length
    //----------------------------------
    
    /**
     * The number of items in the iterator.
     */
    public function get length():int
    {
        return _collection.length;
    }
    
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
    public function get value():*
    {
        if ( _index < _bof || _index > _eof )
        {
            return null;
        } else {
            return _collection.getItemAt( _index );
        }
    }
    
    public function set value(value:*):void
    {
    	if ( _index >= _bof && _index <= _eof )
    	{
            _collection.removeItemAt( _index );
            _collection.addItemAt( value, _index );
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Adds an item to the iterator.
     */    
    public function addItem( value:Object ):void
    {
        _collection.addItem( value );
        _eof ++;
    } 
    
    /**
     * Adds an item to the iterator at the specified index.
     */    
    public function addItemAt( value:Object, index:int ):void
    {
        _collection.addItemAt( value, index );
        _eof ++;
    }    
    
    /**
     * Moves the cursor to the first item in the iterator.  
     */
    public function moveFirst():void
    {
        _index = _bof;
    }
    
    /**
     * Moves the cursor to the last item in the iterator.  
     */
    public function moveLast():void
    {
        _index = _eof;
    }
    
    /**
     * Moves the cursor to the next item in the iterator.  
     */
    public function moveNext():void
    {
        _index ++;
    }
    
    /**
     * Moves the cursor to the previous item in the iterator.  
     */
    public function movePrevious():void
    {
        _index --;
    }
    
    /**
     * Returns the item at the current cursor location and moves the 
     * cursor to the next item.
     * 
     * @return The item.
     * 
     */
    public function next():*
    {
        var oldIndex:int = _index;
        _index ++;
        return _collection.getItemAt( oldIndex );
    }
    
    /**
     * Returns the item at the current cursor location and moves the 
     * cursor to the previous item.
     * 
     * @return The item.
     * 
     */
    public function previous():*
    {
        var oldIndex:int = _index;
        _index --;
        return _collection.getItemAt( oldIndex );
    }
    
    /**
     * Removes an item from the iterator at the specified index.
     */    
    public function removeItemAt( index:int ):Object
    {
        return _collection.removeItemAt( index );
    }
}

}