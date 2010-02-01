////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.models
{
import com.fosrias.core.models.interfaces.AInputData;
	
[Bindable]
/**
 * The InputNumber class is a used in MXML views and 
 * <code>AValidatedViewModel</code> presentation models to implement 
 * validation functionality in the view via its presentation model for
 * numeric fields.
 * 
 * @see com.fosrias.core.models.interfaces.AInputData
 * @see com.fosrias.core.views.interfaces.AValidatedViewModel
 */
public class InputNumber extends AInputData
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function InputNumber(required:Boolean = false ) 
    {
        super(this, required );
    }
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------- 
    
    //----------------------------------
    //  number
    //----------------------------------
    
    /**
     * @private
     * Storage for the number property 
     */
    private var _number:Number;
    
    /**
     * @inheritDoc
     * 
     * @private
     * Implements IValidatedText.
     */    
    public function get number():Number
    {
    	return _number;
    }
    
    /**
     * @private
     */
    public function set number(value:Number):void
    {
    	_number = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //-------------------------------------------------------------------------- 
    
    /**
     * Whether the current object is equal to the value being compared.
     * 
     * @param value The object to compare.
     */
    override public function isEqual( value:Object ):Boolean
    {
    	//Only compare if value is an InputValue
        if( value is InputNumber )
        {
            //Compare the properties
            return value.number == number;
        }
        return false;
    }
}

}