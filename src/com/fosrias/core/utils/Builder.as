////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils
{
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.interfaces.AFactory;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.utils.interfaces.IBuilder;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;

use namespace app_internal;

/**
 * The Builder class creates an instance of a class, updates its properties,
 * and/or decorates it with any specified decorators. Use it as a delegate 
 * in classes requiring complex building of internal instances or in
 * an AFactory subclass to build instances.
 */
public class Builder extends AClass implements IBuilder
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function Builder( factory:AFactory = null )
	{
	     super( this );
	     
	     _factory = factory;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     */
    private var _args:Array = [];
    
    /**
     * @private 
     */
    private var _decoratorKeys:ArrayCollection = new ArrayCollection;
    
    /**
     * @private 
     */
    private var _decoratorsMap:Dictionary = new Dictionary;
    
    /**
     * @private 
     */
    private var _type:Object;
    
    /**
     * @private 
     */
    private var _propertiesMap:Dictionary = new Dictionary;
    
    /**
     * @private 
     */
    private var _propertyKeys:ArrayCollection = new ArrayCollection;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  factory
    //----------------------------------
    
    /**
     * @private 
     * Storage for the factory property. 
     */
    private var _factory:AFactory = null;
    
    /**
     * The factory for the builder. Allows the factory to be changed at
     * runtime.
     * 
     * @param value The factory.
     */
    public function get factory():AFactory
    {
        return _factory;
    }
     
    /**
     * @private
     */    
    public function set factory( value:AFactory ):void
    {
        _factory = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Clears the builder. Override this method to clear any custom variables 
     * or properites in subclasses.
     */
    public function clear():void
    {
        //Clear properties
        var key:*;
        
        while ( _propertyKeys.length > 0 )
        {
            key = _propertyKeys.removeItemAt( 0 );
            _propertiesMap[ key ] = null;
            delete _propertiesMap[ key ];
        }
        
        //Clear decorators
        while ( _decoratorKeys.length > 0 )
        {
            key = _decoratorKeys.removeItemAt( 0 );
            _decoratorsMap[ key ] = null;
            delete _decoratorsMap[ key ];
        }
        
         //Clear variables
        _args = [];
        _type = null;
    }
    
    /**
     * Creates and returns an instance of the class type set in the builder.
     */
    public function create():*
    {
    	return buildInstance();
    }
    
    /**
     * Sets a decorator to decorate the class. The decorator constructor
     * must take the instance to be decorated as the first argument and
     * any other arguments must follow the instance argument as a comma
     * delimited list.
     * 
     * @param type The class of the decorator.
     * @param args A comma separated list of arguments that correspond to 
     * the constructor arguments of the decorator.
     */
    public function setDecorator( type:Class, ... args ):void
    {
        //Keep unique. Allows overwriting a decorator
        if ( !_decoratorKeys.contains( type ) )
            _decoratorKeys.addItem( type );
        _decoratorsMap[ type ] = args;
    }
    
    /**
     * Sets a property on the built instance. If the property does not
     * exist an error is thrown when the instance is created.
     * 
     * @param property The name of the property.
     * @param value The value to be set on the property.
     * 
     */
    public function setProperty( property:String, value:Object ):void
    {
        //Keep unique. Allows overwriting a property
        if ( !_propertyKeys.contains( property ) )
            _propertyKeys.addItem( property );
    	_propertiesMap[ property ] = value;
    }
    
    /**
     * Sets the type of class to be instantiated and its constructor
     * arguments.
     * 
     * @param type The class type. This can be a factory key or a class.
     * @param args A comma separated list of arguments that correspond to 
     * the constructor arguments of the type.
     * 
     */
    public function setType( type:Object, ... args ):void
    {
        _type = type;
        _args = args;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected methods
    //
    //--------------------------------------------------------------------------

    /**
     * The implementation of building an instance of the type. Override 
     * this method to customize building the class instance. Make sure all 
     * variables are cleared at the end of the method and override the 
     * clear method to clear any custom variables as well. 
     * 
     * <p>Typically, you will use the <code>preBuildInstance</code>, 
     * <code>postCreateInstance</code>, and/or <code>postCreateInstance</code>
     * hook methods to customize the builder behavior in subclasses instead
     * of overrideing this method.</p>
     */
    protected function buildInstance():*
    {
    	preBuildInstance();
    	
    	var instance:Object = createInstance();
    	
    	instance = postCreateInstance( instance );
    	
    	//Set properties
    	var key:*;
        for each( key in _propertyKeys )
        {
            updateProperty( instance, key, _propertiesMap[ key ] );
        }
        
        //Decorate the instance
        for each( key in  _decoratorKeys )
        {
            instance = decorateInstance( instance, key, _decoratorsMap[ key ] );
        }
        
        instance = postBuildInstance( instance );
        
        //Clear variables
        clear();
        
        return instance;
    }
    
    /**
     * Creates an instance of the type. 
     * 
     * <p>For most applications this method should not be overridden. 
     * Exceptions are when the type and/or factory functionality is used 
     * to create a separate instance of an object that is set as a property or 
     * child of the instance of the builder, i.e. the builder only creates a 
     * single type of class and uses the other functionality for a variable
     * property in that class. In such a case, the parent type
     * should be instantiated and the subtype property set on it here.</p>
     */
    protected function createInstance():Object
    {
        if ( _type is Class )
        {
            if ( _args.length > 9 )
            {
            	 throw new IllegalOperationError( "Too many arguments "
            		+ "(more than 9) for builder. Override the " 
            	    + qualifiedClassName + " createInstance method "
                    + " to handle more arguments." ); 
                return null;
            } else {
            	
            	//This should be enough.
            	switch ( _args.length )
            	{
            		case 1: 
            		    return new _type( _args[0] );
            		
                    case 2:  
                        return new _type( _args[0], _args[1] );
                    
                    case 3:  
                        return new _type( _args[0], _args[1], _args[2] );
                    
                    case 4:  
                        return new _type( _args[0], _args[1], _args[2], 
                                              _args[3] );
                    case 5:  
                        return new _type( _args[0], _args[1], _args[2], 
                                              _args[3], _args[4] );                                              
                    case 6:  
                        return new _type( _args[0], _args[1], _args[2], 
                                              _args[3], _args[4], _args[5] );                                             
                    case 7:  
                        return new _type( _args[0], _args[1], _args[2], 
                                              _args[3], _args[4], _args[5],
                                              _args[6] );                                            
                    case 8:  
                        return new _type( _args[0], _args[1], _args[2], 
                                              _args[3], _args[4], _args[5],
                                              _args[6], _args[7] );                                            
                    case 9:  
                        return new _type( _args[0], _args[1], _args[2], 
                                              _args[3], _args[4], _args[5],
                                              _args[6], _args[7], _args[8] );
                    default:  
                        return new _type;  
            	}
            	return null;
            }
        } else if ( _factory != null ) {
            return _factory.create( String( _type ), _args );
        } else {
            throw new IllegalOperationError( "Type " + _type.toString() 
                + " cannot be built. Make sure the type is an instantiable" 
                + " class or that it is a valid key in an AFactory subclass "
                + " and that the factory has been set for the builder " 
                + qualifiedClassName );
            return null;
        }
    }
    
    /**
     * Hook into the <code>buildInstance</code> method before the class
     * instance is created.
     * 
     * <p>Override this method to make any modifications to the builder before
     * the instance is created. You can set properties or decorators
     * at this point using the <code>setProperty</code> and 
     * <code>setDecorator</code> methods.</p>
     */
    protected function preBuildInstance():void
    {
    	//Do nothing
    }
    
    /**
     * Hook into the <code>buildInstance</code> method after the class
     * instance is created and properties are set and decorators 
     * are applied.
     * 
     * <p>Override this method to make any last modifications to the instance.
     * before returning it when the create method is called. The method must 
     * return the modified instance. You cannot add properties or decorate the 
     * instance at this point using the <code>setProperty</code> and 
     * <code>setDecorator</code> methods.</p>
     */
    protected function postBuildInstance( instance:Object ):Object
    {
        return instance;
    }
    
    /**
     * Hook into the <code>buildInstance</code> method after the class
     * instance is created but before properties are set and decorators 
     * are applied to the instance.
     * 
     * <p>Override this method to set any other properties or decorators or
     * to directly modify the instance. The method must return the modified
     * instance. You can set properties or decorators at this point using the 
     * <code>setProperty</code> and <code>setDecorator</code> methods.</p>
     */
    protected function postCreateInstance( instance:Object ):Object
    {
        return instance;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function decorateInstance( object:Object, type:Class, 
                                       args:Array = null ):*
    {
        if ( args != null )
        {
            if ( args.length > 0 )
            {
                return new type( object, args );
            } else {
                return new type( object );
            }
        } else {
            return new type( object );
        }
    }
    
    /**
     * @private
     */
    private function updateProperty( object:Object, property:String, 
        value:Object ):void
    {
        if ( object.hasOwnProperty( property ) )
        {
            object[property] = value;
        } else {
            throw new IllegalOperationError( "No " + property + " exists "
                + " for the type in " + qualifiedClassName );
        }
    }
}

}