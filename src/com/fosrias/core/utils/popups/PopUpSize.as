////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils.popups
{
import com.fosrias.core.interfaces.AClass;

import flash.errors.IllegalOperationError;
import flash.geom.Point;

import mx.collections.ArrayCollection;

/**
 * The PopUpSize class defines the size of a popup when it is opened
 * with a <code>PopUpLoader</code>.
 * 
 * @see com.fosrias.core.utils.PopUpLoader
 */
public class PopUpSize extends AClass
{	
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function PopUpSize( width:Number = 0, height:Number = 0 ) 
    {
        super( this );
        _width = width;
        _height = height;
    }
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * A clone of the Position instance.
     */
    public function get clone():PopUpSize
    {
    	return new PopUpSize( _width, _height );
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    /**
     * @private
     * Storage for the height property. 
     */
    private var _height:Number = 0;
    
    /**
     * The height of the popup. 
     */
    public function get height():Number
    {
    	return _height;
    }
    
    /**
     * @private
     */
    public function set height( value:Number ):void
    {
    	_height = value;
    }
	
    //----------------------------------
    //  width
    //----------------------------------
    
    /**
     * @private
     * Storage for the width property. 
     */
    private var _width:Number = 0;
    
    /**
     * The width of the popup. 
     */
    public function get width():Number
    {
        return _width;
    }
    
    /**
     * @private
     */
    public function set width( value:Number ):void
    {
        _width = value;
    }
}

}