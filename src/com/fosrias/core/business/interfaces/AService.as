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
     * @param remoteOperation The remote operation to be called.
     * @param arguments The arguments to be passed to the remote operation.
     */
    public function call( remoteOperation:String, ... args ):void
    {
    	//Show the cursor
    	service.showBusyCursor = _showBusyCursor;
    	
    	//Create the token
    	var token:AsyncToken;
    	var operation:Operation 
    	    = Operation( service.getOperation( remoteOperation ) );
    	
    	//Call the remote operation
    	if ( args.length > 0 )
    	{
    	   token = operation.send.apply( null, args );
    	}  else {
    		 token = operation.send();
    	} 
    	
    	//Set the token responder
    	token.addResponder( new Responder( onResult, onFault ) );
    	
    	//Display debug message
    	traceDebugMessage( className + "." + remoteOperation + " called.");
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
    //  Protected Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Handler for remote service call results.
     * 
     * @param event The result event.
     */
    protected function onResult(event:ResultEvent):void 
    {
        dispatchEvent(new ResultEvent(ResultEvent.RESULT, false, true, 
           event.result, event.token, event.message ));
           
        traceDebugMessage("Result Object: " + event.result.toString()); 
        
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
        
        dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, 
           newFault, event.token, event.message ));
           
        traceDebugMessage("Fault: " + newFault.message);
        
        //Reset showBusyCursor property
        service.showBusyCursor = false; 
    }
}

}