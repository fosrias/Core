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
 * The MathUtils class contains math utility methods.
 */
public final class MathUtils
{
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns the base 10 multiplier of a number.
	 * 
	 * @param value The number.
     */
    public static function baseOf( value:Number ):int
    {
        return Math.pow( 10, powerOf( value ) );
    }
    
    /**
     * Returns the ceiling of a number with respect to an interval.
	 * 
	 * @param value The number.
	 * @param unit The interval unit.

     */
    public static function ceilOf( value:Number, unit:Number = 1):Number
    {
        return Math.ceil( value / unit ) * unit;
    }
    
    /**
     * Returns the floor of a number with respect to an interval.
	 *
	 * @param value The number.
	 * @param unit The interval unit.
     */
    public static function floorOf( value:Number, unit:Number = 1 ):Number
    {
        return Math.floor( value / unit ) * unit;
    }

    /**
     * Returns the scientific notation coeficient of a number.
	 * 
	 * @param value The number.
     */
    public static function coefficientOf( value:Number ):Number
    {
        return value / baseOf( value );
    }
    
    /**
     * Returns the decimal portion of a number.
	 * 
	 * @param value The number.
     */
    public static function decimalOf( value:Number ):Number
    {
        return Math.abs( value ) - Math.floor( Math.abs(value) );
    }
    
    /**
     * Returns the decimal portion of a number.
	 * 
	 * @param value The number.
     */
    public static function log10( value:Number ):Number
    {
        return Math.log( value ) / Math.LN10;
    }
    
    /**
     * Returns the base 10 exponential power of a number.
	 * 
	 * @param value The number.
     */
    public static function powerOf( value:Number ):int
    {
        return Math.floor( Math.log( Math.abs( value ) ) / Math.LN10 );
    }
    
   /**
     * Calculates the decimal place precision of a number.
	 * 
	 * @param value The number.
     */
    public static function precisionOf( value:Number):int
    {
    	var precision:Number = 0;
        var decimal:Number = decimalOf( value );
            
        precision =
            decimal == 0 ? 0 : -Math.floor(Math.log(decimal) / Math.LN10);
            
        decimal = Math.abs(value) - Math.floor(Math.abs(value));
            
        precision = Math.max(precision,
                decimal == 0 ? 0: -Math.floor(Math.log(decimal) / Math.LN10));
        
        return precision;
    }
    
	/**
	 * Returns the sign of a number.
	 * 
	 * @param value The number.
	 */
	public static function signOf(value:Number): int
    {
    	if ( value == 0 )
    	{
    		return 1;
    	} else {
    	    return Math.round(value /Math.abs(value));
    	}
    }
    
    /**
     * Returns a number as a percent to the specified decimal precision.
     * 
     * @param value The number to be converted to a percent.
     * @param precision The number of decimal places.
     */
    public static function percent( value:Number, precision:int = 0):Number
    {
    	var roundBase:int = Math.pow( 10, precision );
    	return Math.round( value * roundBase * 100 ) / roundBase;
    }
	
	/**
	 * Rounds a number to the specified decimal precision.
	 * 
	 * @param value The number to be rounded.
	 * @param precision The number of decimal places.
	 */
	public static function round( value:Number, precision:int = 0):Number
	{
		var roundBase:int = Math.pow( 10, precision );
		return Math.round( value * roundBase ) / roundBase;
	}
}

}