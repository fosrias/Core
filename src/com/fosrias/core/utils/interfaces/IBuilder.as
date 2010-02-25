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
     * 
     * @param clear Whether the builder should clear itself after creating
     * the instance. The default is <code>true</code>.
     */
    function create(clear:Boolean = true):*;
    
    /**
     * Clears a decorator set in the builder.
     * 
     * @param type The class of the decorator.
     */
    function clearDecorator(type:Class):void;
    
    /**
     * Clears a property set in the builder.
     * 
     * @param property The name of the property.
     * 
     */
    function clearProperty(property:String):void;
    
    /**
     * Clears a style set in the builder.
     * 
     * @param style The name of the style.
     * 
     */
    function clearStyle(style:String):void;
    
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
     * Sets a style on the built instance.
     * 
     * @param style The name of the style.
     * @param value The value to be set on the property.
     * 
     */
    function setStyle( style:String, value:Object ):void;
    
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