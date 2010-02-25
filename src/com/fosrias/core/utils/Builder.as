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
    
    /**
     * @private 
     */
    private var _stylesMap:Dictionary = new Dictionary;
    
    /**
     * @private 
     */
    private var _styleKeys:ArrayCollection = new ArrayCollection;
    
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
        
        //Clear styles
        while ( _styleKeys.length > 0 )
        {
            key = _styleKeys.removeItemAt( 0 );
            _stylesMap[ key ] = null;
            delete _stylesMap[ key ];
        }
        
        
        
         //Clear variables
        _args = [];
        _type = null;
    }
    
    /**
     * Creates and returns an instance of the class type set in the builder.
     * Override this method to customize building the class instance. Make 
     * sure all variables are cleared at the end of the overridden method and 
     * override the clear method to clear any custom variables as well. 
     * 
     * <p>Typically, you will override the <code>clear</code>,
     * <code>preInstantiate</code>,  <code>postInstantiate</code>, 
     * and/or <code>postInstantiate</code> hook methods to customize the 
     * builder behavior in subclasses instead
     * of overrideing this method.</p>
     * 
     * @param clear Whether the builder should clear itself after creating
     * the instance. The default is <code>true</code>.
     */
    public function create(clear:Boolean = true):*
    {
        preInstantiate();
        
        var instance:Object = createInstance(_type, _args);
        
        instance = postInstantiate( instance );
        
        var key:*;
        var parts:Array;
        var obj:Object;
        var i:int;
        var n:int;
        
        //Set properties
        for each( key in _propertyKeys )
        {
            parts = String(key).split(".");
            obj = instance;
            n = parts.length;
            for (i = 0; i < n; i++)
            {
                if ( obj.hasOwnProperty( parts[i] ) )
                {
                    if ( i < n - 1 )
                    {
                        obj = obj[parts[i]];
                    } else {
                        obj[parts[i]] = _propertiesMap[key];
                    }
                } else {
                    throw new IllegalOperationError("No " + String(key) 
                        + " property exists for the type in " 
                        + qualifiedClassName);
                }
            }
        }
        
        //Decorate the instance
        for each( key in  _decoratorKeys )
        {
            instance = createInstance( key, 
                [instance].concat(_decoratorsMap[ key ]) );
        }
        
        //Set the styles
        for each( key in  _styleKeys )
        {
            parts = String(key).split(".");
            if ( parts.length == 1)
            {
                instance.setStyle(key, _stylesMap[ key ]);
            } else {
                
                obj = instance.getStyle(parts.shift());
                
                if ( obj == null ) {
                    throw new IllegalOperationError("No " + String(key) 
                        + " style property exists for the type in " 
                        + qualifiedClassName); 
                }
                
                //Not dry for performance reasons
                n = parts.length;
                for (i = 0; i < n; i++)
                {
                    if ( obj.hasOwnProperty(parts[i]))
                    {
                        if ( i < n - 1 )
                        {
                            obj = obj[parts[i]];
                        } else {
                            obj[parts[i]] = _propertiesMap[key];
                        }
                    } else {
                        throw new IllegalOperationError("No " + String(key) 
                            + " style exists for the type in " 
                            + qualifiedClassName);
                    }
                }
            }
        }
        
        instance = postBuild( instance );
        
        //Clear the builder
        if( clear)
            this.clear();
        
        return instance;
    }
    
    /**
     * Clears a decorator set in the builder.
     * 
     * @param type The class of the decorator.
     */
    public function clearDecorator(type:Class):void
    {
        if ( _decoratorKeys.contains( type ) )
        {
            _decoratorKeys.removeItemAt(_decoratorKeys.getItemIndex(type));
            _decoratorsMap[ type ] = null;
            delete _decoratorsMap[ type ];
        }
    }
    
    /**
     * Clears a property set in the builder.
     * 
     * @param property The name of the property.
     * 
     */
    public function clearProperty(property:String):void
    {
        if ( _propertyKeys.contains(property) )
        {
            _propertyKeys.removeItemAt(_propertyKeys.getItemIndex(property));
            _propertiesMap[property] = null;
            delete _propertiesMap[property];
        }
    }
    
    /**
     * Clears a style set in the builder.
     * 
     * @param style The name of the style.
     * 
     */
    public function clearStyle(style:String):void
    {
        if ( _styleKeys.contains(style) )
        {
            _styleKeys.removeItemAt(_styleKeys.getItemIndex(style));
            _stylesMap[style] = null;
            delete _stylesMap[style];
        }
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
     * @param property The name of the property. Can be a dot-delimited
     * string to access the properties of the main property.
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
     * Sets a style on the built instance.
     * 
     * @param style The name of the style.Can be a dot-delimited
     * string to access the properties of the style.
     * @param value The value to be set on the property.
     * 
     */
    public function setStyle( style:String, value:Object ):void
    {
        //Keep unique. Allows overwriting a property
        if ( !_styleKeys.contains( style ) )
            _styleKeys.addItem( style );
        _stylesMap[ style ] = value;
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
    protected function createInstance(type:Object, args:Array):Object
    {
        if ( type is Class )
        {
            if ( args.length > 9 )
            {
            	 throw new IllegalOperationError( "Too many arguments "
            		+ "(more than 9) for builder. Override the " 
            	    + qualifiedClassName + " createInstance method "
                    + " to handle more arguments." ); 
                return null;
            } else {
            	
            	//This should be enough.
            	switch ( args.length )
            	{
            		case 1: 
            		    return new type( args[0] );
            		
                    case 2:  
                        return new type( args[0], args[1] );
                    
                    case 3:  
                        return new type( args[0], args[1], args[2] );
                    
                    case 4:  
                        return new type( args[0], args[1], args[2], 
                                              args[3] );
                    case 5:  
                        return new type( args[0], args[1], args[2], 
                                              args[3], args[4] );                                              
                    case 6:  
                        return new type( args[0], args[1], args[2], 
                                              args[3], args[4], args[5] );                                             
                    case 7:  
                        return new type( args[0], args[1], args[2], 
                                              args[3], args[4], args[5],
                                              args[6] );                                            
                    case 8:  
                        return new type( args[0], args[1], args[2], 
                                              args[3], args[4], args[5],
                                              args[6], args[7] );                                            
                    case 9:  
                        return new type( args[0], args[1], args[2], 
                                              args[3], args[4], args[5],
                                              args[6], args[7], args[8] );
                    default:  
                        return new type;  
            	}
            	return null;
            }
        } else if ( _factory != null ) {
            return _factory.create( String( type ), args );
        } else {
            throw new IllegalOperationError( "Type " + type.toString() 
                + " cannot be built. Make sure the type is an instantiable" 
                + " class or that it is a valid key in an AFactory subclass "
                + " and that the factory has been set for the builder " 
                + qualifiedClassName );
            return null;
        }
    }
    
    /**
     * Hook into the <code>create</code> method before the class
     * instance is created.
     * 
     * <p>Override this method to make any modifications to the builder before
     * the instance is created. You can set properties or decorators
     * at this point using the <code>setProperty</code> and 
     * <code>setDecorator</code> methods.</p>
     */
    protected function preInstantiate():void
    {
    	//Do nothing
    }
    
    /**
     * Hook into the <code>create</code> method after the class
     * instance is created and properties are set and decorators 
     * are applied.
     * 
     * <p>Override this method to make any last modifications to the instance.
     * before returning it when the create method is called. The method must 
     * return the modified instance. You cannot add properties or decorate the 
     * instance at this point using the <code>setProperty</code> and 
     * <code>setDecorator</code> methods.</p>
     */
    protected function postBuild( instance:Object ):Object
    {
        return instance;
    }
    
    /**
     * Hook into the <code>create</code> method after the class
     * instance is created but before properties are set and decorators 
     * are applied to the instance.
     * 
     * <p>Override this method to set any other properties or decorators or
     * to directly modify the instance. The method must return the modified
     * instance. You can set properties or decorators at this point using the 
     * <code>setProperty</code> and <code>setDecorator</code> methods.</p>
     */
    protected function postInstantiate( instance:Object ):Object
    {
        return instance;
    }
}

}