////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils
{

/**
 * The ClonableArray class extends an <code>Array</code> to have a clone 
 * property that clones the array and any clonable elements in the array.
 */
public class ClonableArray extends Array
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function ClonableArray( ...parameters )
    {
        super( parameters );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * A clone of the instance.
     */
    public function get clone():ClonableArray
    {
        var clone:ClonableArray = new ClonableArray;
        
        for each ( var object:Object in this )
        {
            if ( object != null && object.hasOwnProperty( "clone" ) )
            {
                clone.push( object.clone );
            } else if ( object is Array ) {
                clone.push( object.slice() );
            } else {
                clone.push( object );
            }
        }
        return clone;
    }
}

}