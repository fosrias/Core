////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.business.interfaces
{
import com.fosrias.core.interfaces.ADispatcher;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.utils.DateUtils;

import flash.utils.Dictionary;

import mx.formatters.DateFormatter;
import mx.rpc.AsyncToken;
import mx.rpc.Fault;
import mx.rpc.Responder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.Operation;
import mx.rpc.remoting.mxml.RemoteObject;

/**
 * The AService class is the base class for asynchronous remote services.
 */
public class AService extends ADispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     */
    private static var pendingCallTimestamps:Dictionary = new Dictionary;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AService( self:AService, showBusyCursor:Boolean = false )
    {
    	super( self );
        _showBusyCursor = showBusyCursor;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     */
    private var _showBusyCursor:Boolean; 
    
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
    private var _service:RemoteObject;
    
    /**
     * The remote service.
     */
     
    public function get service():RemoteObject
    {
    	return _service
    }
    
    /**
     * @private
     */
    public function set service( value:RemoteObject ):void
    {
        _service = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Calls a remote operation on the service using an <code>AsyncToken</code>
     * so that all response events include a token with its associated 
     * properties including a reference to the initial arguments in the 
     * <code>message.body</code> property of the event token.
	 * 
	 * If this method is called using a single data element, it must be an
	 * array that starts with the remote operation name.
     * 
     * @param remoteOperation The remote operation to be called.
     * @param arguments The arguments to be passed to the remote operation.
     */
    public function call(... args):void
    {
    	//Show the cursor
    	service.showBusyCursor = _showBusyCursor;
		
		//Allows event.data to be used as the sole argument in a call.
		if (args[0] is Array)
		{
			args = args[0];
		}
		
		var remoteOperation:String = args.shift();
		
		//Create the token
    	var token:AsyncToken;
    	var operation:Operation 
    	    = Operation( service.getOperation(remoteOperation) );
			
		//Apply user credentials from the current session token.
		service.setRemoteCredentials(sessionToken.login, sessionToken.password);
			
		 //Get a timestamp
    	var now:Date = new Date();
            
        //Call the remote operation
        if ( args.length > 0 )
    	{
    	   token = operation.send.apply( null, args );
    	}  else {
    		 token = operation.send();
    	} 
        
        //Set the token responder
    	token.addResponder( new Responder( onResult, onFault ) );
    	
        //Store the time for reference
        pendingCallTimestamps[token] = now;
    	
    	//Display debug message
    	traceDebug( className + "." + remoteOperation + " called.");
    }
	
	public function oldCall(remoteOperation:String, ... args):void
	{
		//Show the cursor
		service.showBusyCursor = _showBusyCursor;
		
		//Create the token
		var token:AsyncToken;
		var operation:Operation 
		= Operation( service.getOperation(remoteOperation) );
		
		//Get a timestamp
		var now:Date = new Date();
		
		//Call the remote operation
		if ( args.length > 0 )
		{
			token = operation.send.apply( null, args );
		}  else {
			token = operation.send();
		} 
		
		//Set the token responder
		token.addResponder( new Responder( onResult, onFault ) );
		
		//Store the time for reference
		pendingCallTimestamps[token] = now;
		
		//Display debug message
		traceDebug( className + "." + remoteOperation + " called.");
	}
    
    /**
     * Changes the remote object of the service.
     */
    public function changeService( value:RemoteObject ):void
    {
        _service = value;
    }
    
    /**
     * Changes the showBusyCursor status of the service.
     */
    public function changeShowBusyCursor( value:Boolean = false ):void
    {
        _showBusyCursor = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function findTimestamp(date:Date, token:AsyncToken):String
    {
        var timestamp:Date = pendingCallTimestamps[token];
        
        //Clear dictionary reference
        pendingCallTimestamps[token] = null;
        delete pendingCallTimestamps[token];
        
        return ((date.getTime() - timestamp.getTime())/1000).toString() + " s" 
    }
            
    //--------------------------------------------------------------------------
    //
    //  Protected methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Handler for remote service call results.
     * 
     * @param event The result event.
     */
    protected function onResult(event:ResultEvent):void 
    {
        //Get a timestamp
        var now:Date = new Date();

        dispatchEvent(new ResultEvent(ResultEvent.RESULT, false, true, 
           event.result, event.token, event.message ));
        
		var resultString:String = "Null";
		
		if (event.result != null)
			resultString = event.result.toString()
			
        traceDebug("Result: " + resultString + " returned "
            + " in " + findTimestamp(now, event.token) + " ."); 
        
        //Reset showBusyCursor property
        service.showBusyCursor = false; 
    }
        
    /**
     * Handler for remote service call faults.
     * 
     * @param event The fault of the service call.
     */
    protected function onFault(event:FaultEvent):void 
    {
        //Get a timestamp
        var now:Date = new Date();

    	var oldFault:Fault = event.fault;
    	var newFault:Fault = new Fault(oldFault.faultCode,
            oldFault.faultString, oldFault.faultDetail);
        
        //Look for extended data associated with server error strings
        var extendedData:String =  event.message['extendedData'];     
        if ( extendedData != null && extendedData != "" )
        {
            newFault.message =  event.message['extendedData'];          
        } else {
        	newFault.message = oldFault.message;
        }
        
        traceDebug("Fault: " + newFault.message + " returned "
            + " in " + findTimestamp(now, event.token) + " .");
        
        dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, 
           newFault, event.token, event.message ));
           
        //Reset showBusyCursor property
        service.showBusyCursor = false; 
    }
}

}