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
import com.fosrias.core.models.interfaces.IIsEqual;

import mx.collections.ArrayCollection;

/**
 * The ComparisonUtils class contains static methods for comparing objects.
 */
public class ComparisonUtils
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ComparisonUtils() {}
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    
    /**
     * Returns a new <code>ArrayCollection</code> whose source is 
     * a full slice of original's source.
     */
    public static function collectionSlice( 
        value:ArrayCollection ):ArrayCollection
    {   
        return value == null ? null : new ArrayCollection( 
            value.source.slice() );
    }
    
    /**
     * Compares two arrays containing objects that implement the 
     * <code>IIsEqual</code> interface to see if the arrays contain
     * equal objects. The order of the components does not matter.
     * 
     * @param primaryArray The main array to compare.
     * @param secondaryArray The comparison array.
     */
    public static function isEqualArray( primaryArray:Array, 
        secondaryArray:Array ):Boolean
    {
        //Must have same length to be equal
        var length:int = primaryArray.length;
        if ( length == secondaryArray.length )
        {
            //Flag to see if equal
            var isEqual:Boolean = false;
            
            //Iterate through primary array elements, the secondary
            //elements must be equal, element by element.
            var n:int = primaryArray.length;
            for (var i:int = 0; i < n; i++ )
            {
            	if ( !isEqualObject( primaryArray[i] ) )
            	{
            		return false;
            	} else if ( !isEqualObject( secondaryArray[i] ) ) {
                    return false;
                } else if ( primaryArray[i].isEqual( secondaryArray[i] ) ) {
                    isEqual = true;
                } else {
                    return false;
                }
            }
            return isEqual;
        }
        return false;
    }
    
    /**
     * Compares two array colletions containing objects that implement the 
     * <code>IIsEqual</code> interface to see if the arrays contain
     * equal objects. The order of the components does not matter.
     * 
     * @param primaryArray The main array to compare.
     * @param secondaryArray The comparison array.
     */
    public static function isEqualArrayCollection( 
        primaryArrayCollection:ArrayCollection,
        secondaryArrayCollection:ArrayCollection):Boolean
    {
    	if ( primaryArrayCollection == null 
    	   && secondaryArrayCollection == null )
    	{
    		return true;
    	} else if ( primaryArrayCollection == null 
            || secondaryArrayCollection == null ) {
            return false;
        } else {
        	return isEqualArray( primaryArrayCollection.source, 
        	   secondaryArrayCollection.source );
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     * Determines if the object implements the <code>IIsEqual</code> interface.
     * @param value The object to be tested.
     */
    private static function isEqualObject ( value:Object ):Boolean
    {
    	return value is IIsEqual;
    }

}
}