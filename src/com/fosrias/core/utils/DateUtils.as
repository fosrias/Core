package com.fosrias.core.utils
{
public class DateUtils
{
	public function DateUtils() {}
	
	/**
	 * Adjusts dates for remote calls and returns.
	 * 
	 */	
	public static function adjustRemoteTimeZone( date:Date ):Date
	{
		return new Date(date.valueOf() + date.getTimezoneOffset()*60000);
	}
	
	public static function get tomorrow():Date
	{
		var date:Date = new Date;
		return new Date(date.fullYear, date.month, date.date + 1);
	}
}

}