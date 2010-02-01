////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos
{
import flash.events.EventDispatcher;

import mx.events.PropertyChangeEvent;

[Bindable]
[RemoteClass(alias="Message")]	
/**
 * The Message class is a value object that references messages on the server
 * and serves as a proxy class while a remote call is made to request the 
 * message.
 */
public class Message extends EventDispatcher
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function Message()
	{
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  id
    //----------------------------------
    
    /**
     * @private
     * Storage for the id property. 
     */
    private var _id:int;
    
    /**
     * The id of the message. 
     */
    public function get id():int
    {
    	return _id;
    }
    
    /**
     * @private
     */
    public function set id(value:int):void
    {
    	_id = value;
    }
    
    //----------------------------------
    //  code
    //----------------------------------
    
    /**
     * @private
     * Storage for the code property. 
     */
    private var _code:String;
    
    /**
     * The code of the message. 
     */
    public function get code():String
    {
        return _code;
    }
    
    /**
     * @private
     */
    public function set code( value:String ):void
    {
        _code = value;
    }
    
    //----------------------------------
    //  isPending
    //----------------------------------
    
    /**
     * @private
     * Storage for the isPending property. 
     */
    private var _isPending:Boolean = true;
    
    /**
     * Whether the message has a pending remote service call to 
     * update its value. 
     */
    public function get isPending():Boolean
    {
        return _isPending;
    }
    
    /**
     * @private
     */
    public function set isPending(value:Boolean):void
    {
        _isPending = value;
    }
    
    //----------------------------------
    //  remoteOnly
    //----------------------------------
    
    /**
     * @private
     * Storage for the remoteOnly property. 
     */
    private var _remoteOnly:Boolean;
    
    /**
     * Whether the message is only stored on the remote server and 
     * not mapped in the application. 
     */
    public function get remoteOnly():Boolean
    {
        return _remoteOnly;
    }
    
    /**
     * @private
     */
    public function set remoteOnly(value:Boolean):void
    {
        _remoteOnly = value;
    }
    
    //----------------------------------
    //  text
    //----------------------------------
    
    /**
     * @private
     * Storage for the text property. 
     */
    private var _text:String = "Retrieving information. Please wait...";
    
    /**
     * The text of the message. 
     */
    public function get text():String
    {
        return _text;
    }
    
    /**
     * @private
     */
    public function set text(value:String):void
    {
        _text = value;
    }
    
    //----------------------------------
    //  version
    //----------------------------------
    
    /**
     * @private
     * Storage for the version property. 
     */
    private var _version:String;
    
    /**
     * The id of the message. 
     */
    public function get version():String
    {
        return _version;
    }
    
    /**
     * @private
     */
    public function set version(value:String):void
    {
        _version = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Updates the proxy message to the actual message value. 
     */
    public function update( value:Message ):void
    {
    	_code = value.code;
    	_text = value.text;
    	_version = value.version;
    	
    	_isPending = false;
    	
    	dispatchEvent( new PropertyChangeEvent( 
    	    PropertyChangeEvent.PROPERTY_CHANGE ) );
    }
}

}