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
 * remote services for the following actions:
 * 
 * <p><ul>
 *    <li>create</li>
 *    <li>destroy</li>
 *    <li>index</li>
 *    <li>show</li>
 *    <li>update</li>
 * </p>
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
        super( self, showBusyCursor );
    }
    
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
        call.apply( null, ['create'].concat( args ) );
    }
    
    /**
     * Calls the destroy method in the remote service controller.
     * 
     * @param args A comma delimited list of arguments.
     */
    public function destroy( ... args ):void
    {
        call.apply( null, ['destroy'].concat( args ) );
    }
    
    /**
     * Calls the index method in the remote service controller.
     */
    public function index( ... args ):void
    {
        call.apply(null, ['index'].concat(args));
    }
    
    /**
     * Calls the show method in the remote service controller.
     * 
     * @param args A comma delimited list of arguments.
     */
    public function show( ... args ):void
    {
        call.apply( null, ['show'].concat( args ) );
    }
    
    /**
     * Calls the create method in the remote service controller.
     * 
     * @param args A comma delimited list of arguments.
     */
    public function update( ... args ):void 
    {
        call.apply( null, ['update'].concat( args ) );
    }
}

}