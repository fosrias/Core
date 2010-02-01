package com.fosrias.core.utils.cookies
{
import flash.external.ExternalInterface;

import com.fosrias.core.utils.XORcrypt;

public class CookieUtil
{
	//--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    private static const FUNCTION_SETCOOKIE:String = 
        "document.insertScript = function ()" +
        "{ " +
            "if (document.snw_setCookie==null)" +
            "{" +
                "snw_setCookie = function (name, value, time)" +
                "{" +
                    "if (time) {"+
						"var date = new Date();"+
						"date.setTime(date.getTime()+(time));"+
						"var expires = '; expires='+date.toUTCString();"+
					"}" +
					"else var expires = '';"+
					"document.cookie = name+'='+value+expires+'; path=/';" +
	            "}" +
            "}" +
        "}";
	
	private static const FUNCTION_GETCOOKIE:String = 
        "document.insertScript = function ()" +
        "{ " +
            "if (document.snw_getCookie==null)" +
            "{" +
                "snw_getCookie = function (name)" +
                "{" +
                    "var nameEQ = name + '=';"+
					"var ca = document.cookie.split(';');"+
					"for(var i=0;i < ca.length;i++) {"+
						"var c = ca[i];"+
						"while (c.charAt(0)==' ') c = c.substring(1,c.length);"+
						"if (c.indexOf(nameEQ) == 0) " + 
						"return c.substring(nameEQ.length,c.length);"+
					"}"+
					"return null;" +
	            "}" +
            "}" +
        "}";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function CookieUtil() {}
	
    //--------------------------------------------------------------------------
    //
    //  Class Variables
    //
    //--------------------------------------------------------------------------
      
    private static var INITIALIZED:Boolean = false;
    private static var COOKIES_ENABLED:Boolean = false;
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
      
    /**
     * Initializes the external interface and checks if the 
     * browser has cookies enabled. 
     * 
     */
    private static function init():void
	{
		ExternalInterface.call(FUNCTION_GETCOOKIE);
		ExternalInterface.call(FUNCTION_SETCOOKIE);
		INITIALIZED = true;
		
		//Test to see if cookies are enabled
		
		//Create a session cookie
		CookieUtil.create("test","Success",0);
		
		//Read the session cookie
		COOKIES_ENABLED = CookieUtil.read("test") == "Success";
	}
	
	/**
	 * Creates a cookie based on the value and time until expiration.
	 * 
	 * @param value The value to be stored in the cookie.
	 * @param time The expiration time from now in milliseconds.
	 * 
	 */
	public static function create( name:String, value:Object, time:int ):void
	{
		if(!INITIALIZED)
		{
			init();
		}
		
		ExternalInterface.call("snw_setCookie", name, 
            XORcrypt.encode(value.toString()), time);
	}
	
	/**
	 * Enabled property of cookies.
	 * 
	 * @return true if cookies are enabled in the browser. Otherwise, false.
	 * 
	 */
	public static function get enabled():Boolean
	{
		if(!INITIALIZED)
        {
            init();
        }
        
		return COOKIES_ENABLED;
	}
	
	/**
	 * Reads a cookie and returns its stored value
	 *  
	 * @return The value of the cookie.
	 * 
	 */
	public static function read(name:String):Object
	{
		if(!INITIALIZED)
			init();
		
		var value:Object =  ExternalInterface.call("snw_getCookie", name);
		
		if (value != null)
		{
			value = XORcrypt.decode( value.toString() );
		}
		return value;
	}
	
	/**
	 * Destroys the cookie. 
	 * 
	 */
	public static function destroy(name:String):void
	{
		if(!INITIALIZED)
			init();
		
		ExternalInterface.call("snw_setCookie", name, "", -1);
	}
}

}