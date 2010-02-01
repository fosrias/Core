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
 * The DateMath class contains utility functions for working with dates.
 */
public class DateMath 
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function DateMath(){}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
     
    /**
     * Returns a shifted date relative to an old date if the date is a weekend.
     * 
     * @param newDate The date to be checked.
     * @param oldDate The date to shift relative to.
     */
    public static function checkWeekend( newDate:Date, oldDate:Date):Date
    {
        var shift:Number;
        var returnDate:Date;
        if ( newDate.day == 0 || newDate.day == 6 )
        {
            if ( ( newDate > oldDate && oldDate != null ) || oldDate == null )
            {
                if ( newDate.day == 0 )
                {
                    shift = 1;
                } else {
                    shift = 2;
                }
            } else {
                if ( newDate.day == 0 )
                {
                    shift = -2;
                } else {
                    shift = -1;
                }
            }
            returnDate = dateAdd( "d", newDate, shift);
        } else {
            returnDate = newDate;
        }
        return returnDate;
    }
    
    /**
	 * Returns a new date object with the appropriate date/time settings
	 * 
	 * <p>Valid dateParts:
	 * s: Seconds
	 * n: Minutes
	 * h: Hours
	 * d: Days
	 * m: Months
	 * y: Years
	 *
	 */
	public static function dateDiff( datePart:String, date1:Date, 
	    date2:Date):Number
	{
	    return getDateDiffPartHashMap()[datePart.toLowerCase()]( date1 ,date2 );
	}

    /**
     * Returns the difference between 2 dates
     * 
     * <p>Valid dateParts:
     * s: Seconds
     * n: Minutes
     * h: Hours
     * d: Days
     * m: Months
     * y: Years
     *
     */
    public static function dateAdd( datePart:String, date:Date, num:Number ):Date
	{
		//Get date part object;
		var dpo : Object = getDateAddPartHashMap()[ datePart.toLowerCase() ];
		
		//Create new date as a copy of date passed in
		var newDate : Date = new Date( date.getFullYear(),
									   date.getMonth(),
									   date.getDate(),
									   date.getHours(),
									   date.getMinutes(),
									   date.getSeconds(),
									   date.getMilliseconds() );
										           
		//Set the appropriate date part of the new date
		newDate[ dpo.set ]( date[dpo.get ]()+ num );
		
		//Return the new date
		return newDate;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
	/**
	 * @private
	 * Creates a map of date part functions.
	 */
	private static function getDateAddPartHashMap():Object
	{
		var dpHashMap : Object = new Object();
		
		dpHashMap[ "s" ] = new Object();
		dpHashMap[ "s" ].get = "getSeconds";
		dpHashMap[ "s" ].set = "setSeconds";
		dpHashMap[ "n" ] = new Object();
		dpHashMap[ "n" ].get = "getMinutes";
		dpHashMap[ "n" ].set = "setMinutes";
		dpHashMap[ "h" ] = new Object();
		dpHashMap[ "h" ].get = "getHours";
		dpHashMap[ "h" ].set = "setHours";
		dpHashMap[ "d" ] = new Object();
		dpHashMap[ "d" ].get = "getDate";
		dpHashMap[ "d" ].set = "setDate";
		dpHashMap[ "m" ] = new Object();
		dpHashMap[ "m" ].get = "getMonth";
		dpHashMap[ "m" ].set = "setMonth";
		dpHashMap[ "y" ] = new Object();
		dpHashMap[ "y" ].get = "getFullYear";
		dpHashMap[ "y" ].set = "setFullYear";
		
		return dpHashMap;
	}
 
	/**
	 * @private
	 * Creates a map of valid date parts to functions.
	 */
	private static function getDateDiffPartHashMap():Object
	{
		var dpHashMap:Object = new Object();
		dpHashMap[ "s" ] = getSeconds;
		dpHashMap[ "n" ] = getMinutes;
		dpHashMap[ "h" ] = getHours;
		dpHashMap[ "d" ] = getDays;
		dpHashMap[ "m" ] = getMonths;
		dpHashMap[ "y" ] = getYears;
		return dpHashMap;
	}
 
	/**
	 * @private
	 */
	private static function compareDates( date1:Date, date2:Date ):Number
	{
	    return date1.getTime() - date2.getTime();
	}

	/**
     * @private
     */
    private static function getSeconds( date1:Date, date2:Date ):Number
	{
	    return Math.floor(compareDates(date1,date2)/1000);
	}
 
	/**
     * @private
     */
    private static function getMinutes( date1:Date, date2:Date ):Number
	{
	    return Math.floor(getSeconds(date1,date2)/60);
	}
 
	/**
     * @private
     */
    private static function getHours( date1:Date, date2:Date ):Number
	{
	    return Math.floor( getMinutes( date1, date2 )/60 );
	}
	
	/**
     * @private
     */
    private static function getDays( date1:Date, date2:Date ):Number
	{
	    return Math.floor( getHours( date1, date2 )/24 );
	}
	 
	/**
     * @private
     */
    private static function getMonths( date1:Date, date2:Date ):Number
	{
	    var yearDiff:Number = getYears( date1, date2 );
	    var monthDiff:Number = date1.getMonth() - date2.getMonth();
	    if( monthDiff < 0 )
	    {
	        monthDiff += 12;
	    }
	    if( date1.getDate()< date2.getDate() )
	    {
	        monthDiff-=1;
	    }
	    return 12 *yearDiff + monthDiff;
	}
 
	/**
     * @private
     */
    private static function getYears( date1:Date, date2:Date ):Number
	{
	    return Math.floor( getDays( date1, date2 )/365 );
	}
}

}