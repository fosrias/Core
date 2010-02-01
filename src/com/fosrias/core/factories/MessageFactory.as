////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.factories
{
import com.fosrias.core.business.interfaces.AService;
import com.fosrias.core.interfaces.AFactory;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.vos.Message;

import flash.errors.IllegalOperationError;

import mx.controls.Alert;
import mx.messaging.messages.RemotingMessage;
import mx.rpc.AsyncToken;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

use namespace app_internal;

/**
 * The MessageFactory class creates all the system messages. It serves as a
 * proxy for messages on the server so that only messages requested are 
 * uploaded to the application. 
 * 
 * <p>In order for remote messaging to properly function, the main application 
 * map section must include the MessageEventMap.mxml as a tag.</p>
 * 
 * @see com.fosrias.core.business.MessageService
 * @see com.fosrias.core.vos.Message
 */
public class MessageFactory extends AFactory
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function MessageFactory()
	{
        super( this );
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  service
    //----------------------------------
    
    /**
     * @private
     * Storage for the service property. 
     */
    private var _service:AService;
    
    /**
     * The remote service the factory proxies.
     */
    public function set service( value:AService ):void
    {
    	_service = value;
    	_service.addEventListener( ResultEvent.RESULT, onResult );
    	_service.addEventListener( FaultEvent.FAULT, onFault );
    	
    	_service.call( "show_default" );
    	
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     * 
     * <p>The second argument of the <code>create</code> method must be a 
     * function that takes a <code>message</code> as its argument. This 
     * function should process the returned message accordingly.</p>
     */    
    override public function create( type:String, ...args ):*
    {
    	var message:Message = map[ type ];
    	if ( args.length == 0 )
    	{
    		throw new IllegalOperationError( className + ".create did " + 
    				"not recieve a second argument." );
    	}
    	var handler:Function = args[ 0 ];
    	if ( message == null )
    	{
    		message = new Message;
    		message.code = type;
    		
    		//Get the message from the server and show the busy cursor
    		_service.call( "show_by_code", true, type, message, handler );
    	} else {
    		
    		//Use the handler to set the message
    		handler( message );
    	}
    	//return message;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     * Result handler for remote calls. The show_default call should return
     * all messages that are to be loaded into the application upon start up.
     */
    private function onResult( event:ResultEvent ):void
    {
        var token:AsyncToken = event.token;
        var call:String = RemotingMessage( token.message ).operation;
        
        switch ( call )
        {
            case "show_default":
            {
                //Map any default messages
                setMessages( event.result.data as Array );
                break;
            }
            
            case "show_by_code":
            {
                //Get the pending message from the token
                var pendingMessage:Message = token.message.body[ 0 ][ 1 ];
                var handler:Function = token.message.body[ 0 ][ 2 ];
                
                //Update pending message to the retrieved value
                pendingMessage.update( Message( event.result.data ) );
                
                //Map the message so future calls do not call the server
                setMessage( pendingMessage );
                
                //Set the message with the handler
                handler( pendingMessage );
            }
        }
    }
    
    /**
     * @private
     * Fault handler for remote calls
     */
    private function onFault( event:FaultEvent ):void
    {
        Alert.show(event.fault.faultString, "Message Factory Fault");
    }
    
    /**
     * @private
     * Adds a message to the map.
     */
    private function setMessage( value:Message ):void
    {
    	if ( map[ value.code ] == null )
        {
        	//Don't store messages that are remote only. Typically, these
        	//are large messages that are seldom accessed.
        	if ( !value.remoteOnly )
        	{
	    	    map[ value.code ] = value;
	            types.push( value.code );
	        }
        }
    }
    
    /**
     * @private
     * Adds an array of messages to the map.
     */
    private function setMessages( value:Array ):void
    {
        if ( value != null )
        {   
            while (value.length > 0)
            {
                setMessage( value.pop() );
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * inheritDoc
     */
    override protected function mapImpl():void
    {
    	//Do nothing.
    }
    
    /**
     * inheritDoc
     */
    override protected function typesImpl():Array
    {
        return [];
    }
}

}