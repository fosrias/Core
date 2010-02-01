package com.fosrias.core.managers   
{
import com.asual.swfaddress.SWFAddress;
import com.fosrias.core.events.WebBrowserEvent;
import com.fosrias.core.managers.interfaces.AManager;
import com.fosrias.core.utils.cookies.CookieEvent;
import com.fosrias.core.utils.cookies.CookieLoader;

import mx.core.Application;
import mx.core.FlexGlobals;
import mx.events.BrowserChangeEvent;
import mx.managers.BrowserManager;
import mx.managers.IBrowserManager;
import mx.utils.StringUtil;

public class WebBrowserManager extends AManager
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function WebBrowserManager()
    {
    	super(this);
        
        //Set listeners on the browser manager
        _bm.addEventListener(BrowserChangeEvent.APPLICATION_URL_CHANGE, 
            applicationUrlChangeHandler);
        _bm.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, 
            browserUrlChangeHandler);
        _bm.addEventListener(BrowserChangeEvent.URL_CHANGE, 
            urlChangeHandler);
        
        //Set listeners on cookieLoader   
        _cookieLoader.addEventListener(CookieEvent.CREATED, dispatchEvent);
        _cookieLoader.addEventListener(CookieEvent.DISABLED, dispatchEvent);
        _cookieLoader.addEventListener(CookieEvent.ENABLED, dispatchEvent);
        _cookieLoader.addEventListener(CookieEvent.FOUND, dispatchEvent);
        _cookieLoader.addEventListener(CookieEvent.NOT_FOUND, dispatchEvent);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var _applicationTitle:String;
    private var _bm:IBrowserManager = BrowserManager.getInstance();
    private var _cookieLoader:CookieLoader = new CookieLoader;
    private var _title:String;
    private var _siteInitialized:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    public function back():void
    {
        SWFAddress.back();
    }
    
    public function readCookie(name:String):void
    {
    	_cookieLoader.read(name);
    }
    
    public function destroyCookie(name:String):void
    {
        _cookieLoader.destroy(name);
    }
    
    public function createCookie(name:String, value:Object, time:int):void
    {
    	_cookieLoader.create(name,value,time);
    }
    
    public function setFragment(fragment:String):void
    {
    	if (_bm.fragment != fragment)
    	{
    	    _bm.setFragment(fragment);
    	}
    }
    
    public function setApplicationTitle(title:String):void
    {
    	_applicationTitle = StringUtil.trim(title);
    	if (_title != null && _title != "")
    	{
    		setTitle(_title);
    	} else if (_applicationTitle != null && _applicationTitle != "") {
    		 _bm.setTitle(_applicationTitle);
    	}
    }
    
    public function setTitle(title:String):void
    {
    	_title = StringUtil.trim(title);
    	if (_applicationTitle != null && _applicationTitle != "")
    	{
    		if (title != null && title != "")
    		{ 
                title = title + "| " + _applicationTitle;
            } else {
            	title = _applicationTitle
            }
    	} else {
    		title = _title;
    	}
        _bm.setTitle(title);
    }
    
    public function siteInitialized():void
    {
    	_bm.init("", _applicationTitle);
    	_siteInitialized = true; 
		FlexGlobals.topLevelApplication.validateNow();
        browserUrlChangeHandler(new WebBrowserEvent(
            WebBrowserEvent.BROWSER_URL_CHANGE, _bm.url, null, _bm.fragment));
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    private function applicationUrlChangeHandler(event:BrowserChangeEvent):void
    {
    	dispatcher.dispatchEvent(new WebBrowserEvent(
                WebBrowserEvent.APPLICATION_URL_CHANGE, event.url, 
                event.lastURL, _bm.fragment));
    }
    
    private function browserUrlChangeHandler(event:BrowserChangeEvent):void
    {
        if (_siteInitialized)
        {
            _dispatcher.dispatchEvent(new WebBrowserEvent(
                 WebBrowserEvent.BROWSER_URL_CHANGE, event.url, 
                 event.lastURL, _bm.fragment));
        }
    }
    
    private function urlChangeHandler(event:BrowserChangeEvent):void
    {
        dispatcher.dispatchEvent(new WebBrowserEvent(
                WebBrowserEvent.URL_CHANGE, event.url, 
                event.lastURL, _bm.fragment));
    }
}

}