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
    public static function baseOf(value:Number):int
    {
        return Math.pow(10, powerOf(value));
    }
    
    /**
     * Returns the ceiling of a number with respect to an interval.
	 * 
	 * @param value The number.
	 * @param unit The interval unit.

     */
    public static function ceilOf(value:Number, unit:Number = 1):Number
    {
        return Math.ceil(value / unit) * unit;
    }
    
    /**
     * Returns the floor of a number with respect to an interval.
	 *
	 * @param value The number.
	 * @param unit The interval unit.
     */
    public static function floorOf(value:Number, unit:Number = 1):Number
    {
        return Math.floor(value / unit) * unit;
    }

    /**
     * Returns the scientific notation coeficient of a number.
	 * 
	 * @param value The number.
     */
    public static function coefficientOf(value:Number):Number
    {
        return value / baseOf(value);
    }
    
    /**
     * Returns the decimal portion of a number.
	 * 
	 * @param value The number.
     * @param precision The precision to cutoff floating point errors. Default
     * is 7.
     */
    public static function decimalOf(value:Number, precision:Number = 7):Number
    {
        return round(Math.abs(value) - Math.floor( Math.abs(value)), precision);
    }
    
    /**
     * Returns the decimal portion of a number.
	 * 
	 * @param value The number.
     */
    public static function log10(value:Number):Number
    {
        return Math.log( value ) / Math.LN10;
    }
    
    /**
     * Returns the base 10 exponential power of a number.
	 * 
	 * @param value The number.
     */
    public static function powerOf(value:Number):int
    {
        return Math.floor(Math.log(Math.abs(value)) / Math.LN10);
    }
    
   /**
     * Calculates the decimal place precision of a number.
	 * 
	 * @param value The number.
     * @param precision The precision to cutoff floating point errors. Default
     * is 7.
     */
    public static function precisionOf(value:Number, precision:Number = 7):int
    {
        var decimal:Number = decimalOf(value, precision);
            
        precision = 0;
        
        while (decimal != 0)
        {
            precision += 1;
            decimal = decimalOf(10*decimal);
        }
        return precision;
    }
    
	/**
	 * Returns the sign of a number.
	 * 
	 * @param value The number.
	 */
	public static function signOf(value:Number):int
    {
    	if ( value == 0 )
    	{
    		return 1;
    	} else {
    	    return Math.round(value /Math.abs(value));
    	}
    }
    
    /**
     * Returns the sign of a number.
     * 
     * @param value The number.
     */
    public static function signSymbolOf(value:Number):String
    {
        if ( value == 0 )
        {
            return "+";
        } else {
            value = Math.round(value /Math.abs(value));
            if (value > 0)
            {
                return "+";
            } else {
                return "-";
            }
        }
    }
    
    /**
     * Returns a number as a percent to the specified decimal precision.
     * 
     * @param value The number to be converted to a percent.
     * @param precision The number of decimal places.
     */
    public static function percent(value:Number, precision:int = 0):Number
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
	public static function round(value:Number, precision:int = 0):Number
	{
		var roundBase:int = Math.pow( 10, precision );
		return Math.round(value * roundBase) / roundBase;
	}
}

}