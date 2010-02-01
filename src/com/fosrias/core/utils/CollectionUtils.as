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
import mx.collections.ArrayCollection;
	
/**
 * The CollectionUtils class contains utility methods for working 
 * with collections.
 */
public class CollectionUtils
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function CollectionUtils() {}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Mimics slice functionality of Array class.
     */
    public static function clone( arrayCollection:ArrayCollection 
        ):ArrayCollection
    {
        var source:Array = [];
        
        if ( arrayCollection != null)
        {
            for each ( var object:Object in arrayCollection )
            {
                if ( object.hasOwnProperty( "clone" ) )
                {
                    source.push( object.clone );
                } else {
                    source.push( object );
                }
            }
            return new ArrayCollection( source );
        }
        return null;
    }
    
    /**
     * Mimics slice functionality of Array class.
     */
    public static function slice( arrayCollection:ArrayCollection, 
        startIndex:int = 0, endIndex:int = 16777215 ):ArrayCollection
    {
        var source:Array;
        
        if ( arrayCollection != null)
        {
        	source = arrayCollection.source;
        }
        
        if ( source != null )
        {
            source == source.slice( startIndex, endIndex )
        }
        return new ArrayCollection( source );
    }
}

}