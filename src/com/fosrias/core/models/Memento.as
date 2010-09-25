////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.models
{
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.models.interfaces.IIsEqual;
import com.fosrias.core.models.interfaces.IMemento;
import com.fosrias.core.models.interfaces.IMementoHost;
import com.fosrias.core.namespaces.memento_internal;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import mx.collections.ArrayCollection;

use namespace memento_internal;
/**
 * The Memento class records a static state memento of an object's properties. 
 * 
 * Classes implementing IMementoRestore must include the following methods
 * using the namespace memento_internal:
 * 
 * Maps the current properties of the object for storage in a memento. 
 * This method should return a static map of the object. For simple objects
 * that do not compose custom classes, return null from this function 
 * and the memento will map itself. Use the namespace memento_internal
 * in the function declaration.
 * 
 * memento_internal function mapProperties():*
 * 
 * 
 * Hook that allows exception handling with default property mapping.
 * If there are no exceptions, this function must return the value
 * argument.Use the namespace memento_internal in the function declaration.
 * 
 * memento_internal function propertyMapExceptions(property:String, 
 *							                       value:Object,
 * 							                       isRestore:Boolean = false):Object
 * 
 * Restores properties using the memento's property map passed to it 
 * from the memento. Return true if the property was remapped. Return 
 * false to use the mementos internal restore for simple classes.Use the 
 * namespace memento_internal in the function declaration.
 * 
 * memento_internal function restoreProperties(propertyMap:Object):Boolean
 * 
 * Used by a memento to determine if its state is equal to an objects
 * state. If you are using the default property mapping, return the value
 * of the mementoIsEqualFunction. Otherwise, return true if the propertyMap 
 * state is equal to the state of the object (this). Use the namespace 
 * memento_internal in the function declaration.
 * 
 * memento_internal function stateIsEqual(propertyMap:Object,
 *						                  mementoIsEqual:Function):Boolean
 */
public class Memento extends AClass 
		             implements IMemento, IIsEqual
{
					 
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function Memento(hostObject:IMementoHost)
    {
        super(this);
		
		_hostClassName = getQualifiedClassName(hostObject);
		_hostClass = getDefinitionByName(_hostClassName) as Class;

		
		_propertyMap = Object(hostObject).mapProperties();
		
		//Do a simple property mapping
		if (_propertyMap == null)
			mapPropertiesOf(hostObject);
    }

    /**
	 * @private 
	 */
	private var _hostClass:Class;
	
	/**
	 * @private 
	 */
	private var _hostClassName:String;
	
	/**
     * @private
     */
    private var _propertyMap:*
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  isEmpty
    //----------------------------------
    
    /**
     * @private
     * Storage for the isEmpty property. 
     */
    protected var _isEmpty:Boolean = false;
    
    /**
     * Whether the memento has been cleared or not.
     */
    public function get isEmpty():Boolean
    {
        return _isEmpty;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
        
    /**
     * Clears the property to value map of the memento. Call this function
     * when discarding a memento so that it is cleared for garbage collection.
	 * This method is automatically called in <code>restoreTo</code> 
	 * unless overridden.
     */
    public function clear():void
    {
        for (var property:* in _propertyMap)
        {
			_propertyMap[property] = null;
            delete _propertyMap[property];
        }
		_isEmpty = true;
    }
	
	/**
	 * Whether the memento state is equal to the state of the reference 
	 * object.
	 */
	public function isEqual(value:Object):Boolean
	{
		if ( value is _hostClass )
		{	
			return value.stateIsEqual(_propertyMap, isEqualImpl);
		}
		return false;
	}
    
    /**
     * Restores the state of an object from the memento. Override this 
     * function to limit the properties the memento records.
     * 
     * @param object The object to restore state to.
	 * @param clearForGC Clears the memento for garbage collection.
     * 
     * @return The restored object.
     */
    public function restore(value:Object, 
							clearForGC:Boolean = true):*
    {
		if (!(value is _hostClass || value is IMementoHost) )
		{
			throw new IllegalOperationError( "Memento Error: Attempting "
				+ "to restore properties from a " + className + "memento. " 
				+ "The memento  is incompatible with a " 
				+ getQualifiedClassName(value) + " class. It expects a "
				+ _hostClassName + " instance.");
		}  
        
		if ( !value.restoreProperties(_propertyMap) )
		{
			restorePropertiesTo(value);
		}

		if (clearForGC)
			clear();
		
        return value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected methods
    //
    //--------------------------------------------------------------------------
    
	/**
	 * Hook to override property mappings types. Default is to handle 
	 * arrays and array collections. 
	 */
	protected function handlePropertyExceptions(value:Object,
												property:String,
												propertyValue:Object,
												isRestore:Boolean = false):*
	{
		if (propertyValue is Array)
		{
			return propertyValue.slice();
			
		} else if (propertyValue is ArrayCollection) {
			
			return new ArrayCollection( propertyValue.slice() );
		} else {
			
			return value.propertyMapExceptions(property, propertyValue, 
				isRestore);
		}
	}

	/**
	 * Hook to override isEqual implementation property restoration.
	 */
	protected function isEqualImpl(value:Object):Boolean
	{
		var isEqual:Boolean = true;
		
		for (var property:* in _propertyMap)
		{
			isEqual &&= value[property] == _propertyMap[property];
			
			if (isEqual)
				continue;
		}
		return isEqual;
	}
		
	/**
	 * Hook to override default property mappings.
	 */
	protected function mapPropertiesOf(value:IMementoHost):void
	{
		_propertyMap = new Dictionary();
		
		for (var property:String in value)
		{
			_propertyMap[property] = handlePropertyExceptions(value, property,
				value[property]);
		}
	}
	
	/**
	 * Hook to override default property restoration.
	 */
	protected function restorePropertiesTo(value:Object):void
	{
		for (var property:* in _propertyMap)
		{
			value[property] = handlePropertyExceptions(value, property,
				_propertyMap[property], true);
		}
	}
}

}