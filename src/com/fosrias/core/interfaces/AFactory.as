////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.interfaces
{
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;

/**
 * The AFactory class is the base class for all simple factory subclasses.  
 */
public class AFactory extends AClass
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AFactory( self:AFactory ) 
    {
        super( self );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
        
    //----------------------------------
    //  types
    //----------------------------------
    
    /**
     * @private
     * Storage for the types property. 
     */
    protected var _types:Array;
    
    /**
     * The string types of objects built by the factory. This is typically
     * an array of the static type constants defined in the factory.
     */
    public function get types():Array
    {
        if ( _types == null )
        {
            _types = typesImpl();
        }
        return _types;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  map
    //----------------------------------
    
    /**
     * @private
     * Storage for the map property. 
     */
    protected var _map:Dictionary;
    
    /**
     * The type to object class map.
     */
    protected function get map():Dictionary
    {
        if ( _map == null )
        {
            _map = new Dictionary;
            mapImpl();
        }
        return _map;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Clears the base factory map and types for garbage collection. 
     */    
    public function clear( event:Event = null ):void
    {
    	_types = null;
    	clearMap( _map );
    	_map = null;
    }
    
    /**
     * Whether the factory creates an object specified by the type.
     * 
     * @param type The type to check.
     */
    public function contains( type:String ):Boolean
    {
        return new ArrayCollection( types ).contains( type );
    }
    
    /**
     * Creates a new object instance.
     * 
     * @param type A string key corresponding to the type of object class.
     * 
     * @return The instantiated  object.
     */    
    public function create( type:String, ... args ):*
    {
        var factoryType:* = map[ type ];
        
        if ( !contains( type ) )
        {
        	throw new IllegalOperationError("The factory " + qualifiedClassName 
        	    + " does not contain the type " + type );
        }
        
        if ( factoryType != null )
        {
        	return instantiateImpl( factoryType, type, args );
        } else {
            return null;
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Clears a map for garbage collection.
     *  
     * @param map The map to be cleared.
     */    
    protected function clearMap(map:Dictionary):void
    {
        for (var type:* in map)
        {
            map[type] = null;
            delete map[type];
        }
    }
    
    /**
     * An abstract method that returns the types array definiton for 
     * the factory. This method must be overridden in subclasses.
     */ 
    protected function typesImpl():Array
    {
        return raiseImplementationError("method","typesImpl");
    }
    
    /**
     * An abstract method that returns the map definiton for the factory. 
     * This method must be overridden in subclasses.
     * 
     * <p>Typically, a type constant for the factory is used as a key 
     * mapped to a class the the factory instantiates. An alternative is 
     * to define private functions in the factory and map the functions to the
     * the keys. This way the <code>instantiateImpl</code> can be overriden 
     * to call the <code>factoryType</code> parameter as a function with 
     * arguments versus the typical implementation to instantiate a new 
     * instance of the <code>factoryType</code> parameter.
     */ 
    protected function mapImpl():void
    {
        raiseImplementationError("method","mapImpl");
    }
    
    /**
     * An abstract method that specifies how ... args from the 
     * <code>create</code> method are cast to the class being instantiated. 
     * 
     * <p>Must be overridden in concrete implementations to return a new 
     * instance of the factory class using the appropriate constructor 
     * arguments.</p>
     * 
     * @param factoryType The type to be created. This may be a class or 
     * a function defined in the factory that returns an object. Typically,
     * the <code>factoryType</code> is instantiated as a new object using
     * the <code>args</code> parameter in the constructor. The 
     * <code>type</code> key is passed in to allow further options in defining
     * how the instance is created.
     * @param key The type key used to create the class.
     * @param args The arguments.
     * 
     * @return The instantiated class.
     * 
     */
    protected function instantiateImpl( factoryType:*, type:String, 
        args:Array ):*
    {
    	raiseImplementationError( "method", "instantiateImpl" );
    }
}

}