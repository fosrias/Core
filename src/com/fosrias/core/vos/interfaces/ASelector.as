////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos.interfaces
{
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.models.interfaces.IIsEqual;
import com.fosrias.core.vos.CallHash;
	
/**
 * The ASelector class is the base class for concrete selector classes.
 */	
public class ASelector extends AClass implements IIsEqual
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ASelector(code:String = null, label:String = null, 
                              position:int = 0) 
	{
		super( this );
        this.code = code;
		this.label = label;
		this.position = position;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    public var code:String;
    public var label:String;
    public var position:int;
    
    //----------------------------------
    //  callHash
    //----------------------------------
    
    /**
     * A hash of attributes used remotely to create, update or delete the 
     * object.
     */
    public function get callHash():CallHash
    {
        var callHash:CallHash = new CallHash( 0, className  );
        
        callHash.id = code;
        callHash.addAttribute( "code", code); 
        callHash.addAttribute( "label", label); 
        callHash.addAttribute( "position", position); 
        
        return callHash;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    public function isEqual( value:Object ): Boolean
    {
    	if ( value is ASelector )
    	{
    		var isEqual:Boolean;
            
            isEqual = value.code == code &&
                      value.label == label &&
                      value.position == position && 
                      value.qualifiedClassName == qualifiedClassName;
            
            return isEqual;
    	}
    	return false;
    	
    }
}

}