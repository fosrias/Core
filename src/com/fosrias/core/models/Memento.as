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
import com.fosrias.core.models.interfaces.IMemento;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * The Memento class records a memento of an object's properties.
 */
public class Memento extends AClass implements IMemento
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function Memento( object:Object )
    {
        super( this );
        
        if ( object == null )
        {
            throw new IllegalOperationError(className + " Error: Constructor" +
                "object parameter cannot be null." );
        }
        
        _objectName = getQualifiedClassName( object );
        
        for ( var property:String in object )
        {
            _propertyToValueMap[ property] = object[ property ];
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     */
    private var _objectName:String;
    
    /**
     * @private 
     */
    private var _propertyToValueMap:Dictionary = new Dictionary;
    
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
     */
    public function clear():void
    {
        for ( var property:String in _propertyToValueMap )
        {
            _propertyToValueMap[ property] = null;
            delete _propertyToValueMap[ property];
        }
    }
    
    /**
     * Restores the state of an object from the memento. Override this 
     * function to limit the properties the memento records.
     * 
     * @param object The object to restore state to.
     * 
     * @return The restored object.
     */
    public function restoreTo( object:Object ):*
    {
        checkSameObject( object );
        
        for ( var property:String in object )
        {
            object[ property] = _propertyToValueMap[ property ];
        }
        
        return object;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Checks if an object is the same type of object of the memento.
     */
    protected function checkSameObject( object:Object ):void
    {
        var name:String = getQualifiedClassName( object );
        if ( name !=  _objectName )
        {
            throw new IllegalOperationError( className + " Error: Attempting " 
                + "to restore " + name + " properties from a " + _objectName
                + "memento." );
        }  
    }   
}

}