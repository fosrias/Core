////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils.interfaces
{
import com.fosrias.core.interfaces.AFactory;

/**
 * The interface implemented by builder classes.
 */
public interface IBuilder
{
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  factory
    //----------------------------------
    
    /**
     * The factory for the builder. Allows the factory to be changed at
     * runtime.
     * 
     * @param value The factory.
     */
    function get factory():AFactory;
     
    /**
     * @private
     */    
    function set factory( value:AFactory ):void;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Clears the builder. Override this method to clear any custom values
     * set in subclasses.
     */
    function clear():void;
    
    /**
     * Creates and returns an instance of the class type set in the builder.
     */
    function create():*;
    
    /**
     * Sets a decorator to decorate the class.
     * 
     * @param type The class of the decorator.
     * @param args A comma separated list of arguments that correspond to 
     * the constructor arguments of the decorator.
     */
    function setDecorator( type:Class, ... args ):void;
    
    /**
     * Sets a property on the built instance. If the property does not
     * exist an error is thrown when the instance is created.
     * 
     * @param property The name of the property.
     * @param value The value to be set on the property.
     * 
     */
    function setProperty( property:String, value:Object ):void;
    
    /**
     * Sets the type of class to be instantiated and its constructor
     * arguments.
     * 
     * @param type The class type. This can be a factory key or a class.
     * @param args A comma separated list of arguments that correspond to 
     * the constructor arguments of the type.
     * 
     */
    function setType( type:Object, ... args ):void;
}

}