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
    public function CallHash( id:int, type:String, userId:int = -1 )
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
    public var id:int;
    
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
    }
}

}