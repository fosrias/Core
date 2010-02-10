////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos
{
import flash.errors.IllegalOperationError;

/**
 * The CallHash class is a value object that carries attributes and 
 * values for remote calls.
 */
public dynamic class CallHash
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function CallHash( id:Object, type:String, userId:int = -1 )
    {
        this.id = id;
        this.type = type;
        this.userId = userId;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  attributes
    //----------------------------------
    
    /**
     * The specific attributes of the object.
     */
    public var attributes:Object = new Object;
    
    //----------------------------------
    //  id
    //----------------------------------
    
    /**
     * The id of the object
     */
    public var id:Object;
    
    //----------------------------------
    //  type
    //----------------------------------
    
    /**
     * The type of the object.
     */
    public var type:String;
    
    //----------------------------------
    //  userId
    //----------------------------------
    
    /**
     * The user id of the object.
     */
    public var userId:int;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Adds an attribute to the hash attributes.
     */
    public function addAttribute( attribute:String, value:Object ):void
    {
        attributes[ attribute ] = value;
        
       /* //Check for dot-delimited attributes
        if ( attribute.indexOf(".") > 0 )
        {
            addChildAttributesOf( attribute, value );
        } else if  ( attribute.indexOf(".") != 0 ) {
            attributes[ attribute ] = value;
        } else {
            throw new IllegalOperationError("CallHash addAttribute Error: "
                + "Attribute " + attribute + " invalid.");
        }*/
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function addChildAttributesOf( attribute:String,
                                           value:Object ):void
    {
        var obj:Object = attributes;

        var parts:Array = attribute.split(".");
        var tracedAttribute:String = '';
        
        var n:int = parts.length - 1;
        for ( var i:int = 0; i < n; i++ )
        {
            try
            {
                tracedAttribute += parts[i];
                obj = attributes[parts[i]];
            }
            catch(error:Error)
            {
                if ( ( error is TypeError ) &&
                    ( error.message.indexOf( "null has no properties" ) 
                            != -1) )
                {
                    throw new IllegalOperationError( "Attribute " 
                        + tracedAttribute + " not found in base CallHash. " );
                }
                else
                {                    
                    throw error;
                }
            }
        }
        obj[parts[i]] = value;
    }
}

}