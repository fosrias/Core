package com.fosrias.core.utils
{
public class DateUtils
{
	public function DateUtils() {}
	
	/**
	 * Adjusts dates for remote returns.
     * 
     * @see http://flexblog.faratasystems.com/2008/02/05/flex-local-datestime-transfer-issue
	 * 
	 */	
	public static function adjustFromRemoteTimeZone( date:Date ):Date
	{
        if ( date == null )
            return null;
        
		return new Date(date.valueOf() + date.getTimezoneOffset()*60000);
	}
	
    /**
     * Adjusts dates for remote calls.
     * 
     * @see http://flexblog.faratasystems.com/2008/02/05/flex-local-datestime-transfer-issue
	 * 
     */	
    public static function adjustToRemoteTimeZone( date:Date ):Date
    {
        if ( date == null )
            return null;
        
        return new Date(date.valueOf() - date.getTimezoneOffset()*60000);
    }
    
    public static function get tomorrow():Date
	{
		var date:Date = new Date;
		return new Date(date.fullYear, date.month, date.date + 1);
	}
}

}