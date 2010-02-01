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
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

/**
 * The ARESTfulService class is the base class for asynchronous RESTful 
 * remote services.
 * 
 * <p>Note: The new method is not included to create a new instance since this
 * should be handled locally in the flex application.</p>
 */
public class ARESTfulService extends AService
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ARESTfulService( self:AService, 
        showBusyCursor:Boolean = false )
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
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Calls the create method in the remote service controller.
     * 
     * @param args A comma delimited list of arguments.
     */
    public function create( ... args ):void
    {
        call( 'create', _showBusyCursor, args );
    }
    
    /**
     * Calls the destroy method in the remote service controller.
     * 
     * @param args A comma delimited list of arguments.
     */
    public function destroy( ... args ):void
    {
        call( 'destroy', _showBusyCursor, args );
    }
    
    /**
     * Calls the index method in the remote service controller.
     */
    public function index():void
    {
        call( 'index', _showBusyCursor );
    }
    
    /**
     * Calls the show method in the remote service controller.
     * 
     * @param args A comma delimited list of arguments.
     */
    public function show( ... args ):void
    {
    	
        call( 'show', _showBusyCursor, args );
    }
        
    /**
     * Calls the create method in the remote service controller.
     * 
     * @param args A comma delimited list of arguments.
     */
    public function update( ... args ):void 
    {
        call( 'update', _showBusyCursor, args );
    }
}

}