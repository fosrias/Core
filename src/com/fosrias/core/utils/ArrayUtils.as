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

/**
 * The ArrayUtils class contains utility methods for working 
 * with collections.
 */
public class ArrayUtils
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ArrayUtils() {}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Clones an array of objects. If the objects are clonable, they
     * are cloned as well. Otherwise, this use <code>slice</code>.
     */
    public static function clone( array:Array ):Array
    {
        var clone:Array = [];
        
        if ( array != null)
        {
            for each ( var object:Object in array )
            {
                if ( object != null && object.hasOwnProperty( "clone" ) )
                {
                    clone.push( object.clone );
                } else {
                    clone.push( object );
                }
            }
            return clone;
        }
        return null;
    }
}

}