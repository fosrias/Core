package com.fosrias.core.utils
{
	public class DateFunctions 
	{
	/**
	
	dateAdd(datePart:String,date:Date,num:Number):Date
 	returns a new date object with the appropriate date/time settings
 	
	dateDiff(datePart:String, date1:Date, date2:Date):Number
		returns the difference between 2 dates
		 
	Valid dateParts:
		s: Seconds
		n: Minutes
		h: Hours
		d: Days
		m: Months
		y: Years
	**/

 	public static function dateDiff(datePart:String, date1:Date, date2:Date):Number
 	{
  		return getDateDiffPartHashMap()[datePart.toLowerCase()](date1,date2);
	}
	
 	public static function dateAdd(datePart:String,date:Date,num:Number):Date
 	{
  		// get date part object;
  		var dpo : Object = getDateAddPartHashMap()[datePart.toLowerCase()];
  		// create new date as a copy of date passed in
  		var newDate : Date = new Date(date.getFullYear(),date.getMonth(),date.getDate(),date.getHours(),date.getMinutes(),date.getSeconds(),date.getMilliseconds());
  		// set the appropriate date part of the new date
  		newDate[dpo.set](date[dpo.get]()+num);
  		// return the new date
  		return newDate;
 	}
 	
 	private static function getDateAddPartHashMap():Object
 	{
  		var dpHashMap : Object = new Object();
  		dpHashMap["s"] = new Object();
  		dpHashMap["s"].get = "getSeconds";
  		dpHashMap["s"].set = "setSeconds";
  		dpHashMap["n"] = new Object();
  		dpHashMap["n"].get = "getMinutes";
  		dpHashMap["n"].set = "setMinutes";
  		dpHashMap["h"] = new Object();
  		dpHashMap["h"].get = "getHours";
  		dpHashMap["h"].set = "setHours";
  		dpHashMap["d"] = new Object();
  		dpHashMap["d"].get = "getDate";
  		dpHashMap["d"].set = "setDate";
  		dpHashMap["m"] = new Object();
  		dpHashMap["m"].get = "getMonth";
  		dpHashMap["m"].set = "setMonth";
  		dpHashMap["y"] = new Object();
  		dpHashMap["y"].get = "getFullYear";
  		dpHashMap["y"].set = "setFullYear";
  		return dpHashMap;
 	}
 	
 	//Checks if new date and returns a date shifted relative to the old date
 	public static function checkWeekend(newDate:Date,oldDate:Date):Date
	{	
		var shift:Number;
		var returnDate:Date;
		if (newDate.day == 0 || newDate.day == 6)
		{
			if ((newDate > oldDate && oldDate != null) || oldDate == null)
			{
				if (newDate.day == 0)
				{
					shift = 1;
				} else {
					shift = 2;
				}
			} else {
				if (newDate.day == 0)
				{
					shift = -2;
				} else {
					shift = -1;
				}
			}
				returnDate = dateAdd("d",newDate,shift);
		} else {
			returnDate = newDate;
		}
		return returnDate;
	}
 	
 	private static function getDateDiffPartHashMap():Object
 	{
  		var dpHashMap:Object = new Object();
  		dpHashMap["s"] = getSeconds;
  		dpHashMap["n"] = getMinutes;
  		dpHashMap["h"] = getHours;
  		dpHashMap["d"] = getDays;
  		dpHashMap["m"] = getMonths;
  		dpHashMap["y"] = getYears;
  		return dpHashMap;
 	}
 	
 	private static function compareDates(date1:Date,date2:Date):Number
 	{
  		return date1.getTime() - date2.getTime();
 	}
 	
 	private static function getSeconds(date1:Date,date2:Date):Number
 	{
  		return Math.floor(compareDates(date1,date2)/1000);
 	}
 	
 	private static function getMinutes(date1:Date,date2:Date):Number
 	{
  		return Math.floor(getSeconds(date1,date2)/60);
 	}
 	
 	private static function getHours(date1:Date,date2:Date):Number
 	{
  		return Math.floor(getMinutes(date1,date2)/60);
 	}
 	
 	private static function getDays(date1:Date,date2:Date):Number
 	{
  		return Math.floor(getHours(date1,date2)/24);
 	}
 	
 	private static function getMonths(date1:Date,date2:Date):Number
 	{
  		var yearDiff:Number = getYears(date1,date2);
  		var monthDiff:Number = date1.getMonth() - date2.getMonth();
  		if(monthDiff < 0)
  		{
   			monthDiff += 12;
  		}
  		if(date1.getDate()< date2.getDate())
  		{
   			monthDiff-=1;
  		}
  		return 12 *yearDiff + monthDiff;
 	}
 	
 	private static function getYears(date1:Date,date2:Date):Number
 	{
  		return Math.floor(getDays(date1,date2)/365);
 	}
	}
}