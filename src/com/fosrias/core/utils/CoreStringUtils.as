////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009   Mark W. Foster  www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils
{
import mx.formatters.NumberFormatter;
	
/**
 * The StringUtils class contains string utility methods.
 */
public class CoreStringUtils
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function CoreStringUtils() {}
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     * @private 
     */
    private static var _numberFormatter:NumberFormatter = new NumberFormatter;
    
    /**
     * A number formatter with the specified precision.
     * 
     * @param precision The decimal places to be shown.
     */
    public static function numberFormatter( precision:int = 0 ):NumberFormatter
    {
    	var nf:NumberFormatter = new NumberFormatter;
    	nf.precision = precision;
    	return nf;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Formats a number as a string to the specified decimal precision.
     */
    public static function toPrecision( value:Number, precision:int ):String
    {
    	_numberFormatter.precision = precision;
    	return _numberFormatter.format( value );
    }
    
    /**
     *  Formats a Date into a String according to the <code>outputFormat</code> argument.
     *  The <code>outputFormat</code> argument contains a pattern in which
     *  the <code>value</code> String is formatted.
     *  It can contain <code>"M"</code>,<code>"D"</code>,<code>"Y"</code>,
     *  and delimiter and punctuation characters.
     *
     *  @param value Date value to format.
     *
     *  @param outputFormat String defining the date format.
     *
     *  @return The formatted date as a String.
     *
     *  @example <pre>var todaysDate:String = DateField.dateToString(new Date(), "MM/DD/YYYY");</pre>
     */
    public static function dateToString(value:Date, outputFormat:String):String
    {
        if (!value)
            return "";

        var date:String = String(value.getDate());
        if (date.length < 2)
            date = "0" + date;

        var month:String = String(value.getMonth() + 1);
        if (month.length < 2)
            month = "0" + month;

        var year:String = String(value.getFullYear());

        var output:String = "";
        var mask:String;

        // outputFormat will be null if there are no resources.
        var n:int = outputFormat != null ? outputFormat.length : 0;
        for (var i:int = 0; i < n; i++)
        {
            mask = outputFormat.charAt(i);

            if (mask == "M")
            {
                if ( outputFormat.charAt(i+1) == "/" && value.getMonth() < 9 ) {
                    output += month.substring(1) + "/";
                } else {
                    output += month;
                }
                i++;    
            }
            else if (mask == "D")
            {
                if ( outputFormat.charAt(i+1) == "/" && value.getDate() < 10 ) {
                    output += date.substring(1) + "/";
                } else {    
                    output += date;                         
                }
                i++;
            }
            else if (mask == "Y")
            {
                if (outputFormat.charAt(i+2) == "Y")
                {
                    output += year;
                    i += 3;
                }
                else
                {
                    output += year.substring(2,4);
                    i++;
                }
            }
            else
            {
                output += mask;
            }
        }

        return output;
    }
    
    /**
     * Underscores camel case strings.
     */
    public static function underscore( value:String ):String
    {        
        var underscored:String = value.replace(/([A-Z]+)([A-Z][a-z])/,"$1_$2");
        underscored = underscored.replace(/([a-z\d])([A-Z])/,"$1_$2");
        
        return underscored.toLowerCase();
    }
}

}