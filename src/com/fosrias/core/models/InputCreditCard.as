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
 * The InputCreditCard class is a used in MXML views and 
 * <code>AValidatedViewModel</code> presentation models to implement 
 * validation functionality in the view via its presentation model for
 * numeric fields.
 * 
 * @see com.fosrias.core.models.interfaces.AInputData
 * @see com.fosrias.core.views.interfaces.AValidatedViewModel
 */
public class InputCreditCard extends AInputData
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function InputCreditCard(required:Boolean = false ) 
    {
        super(this, required );
    }
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------- 
    
    //----------------------------------
    //  cardNumber
    //----------------------------------
    
    /**
     * @private
     * Storage for the cardNumber property 
     */
    private var _cardNumber:Number;
    
    /**
     * The credit card number.
     */    
    public function get cardNumber():Number
    {
    	return _cardNumber;
    }
    
    /**
     * @private
     */
    public function set cardNumber(value:Number):void
    {
    	_cardNumber = value;
    }
    
    //----------------------------------
    //  cardType
    //----------------------------------
    
    /**
     * @private
     * Storage for the cardType property 
     */
    private var _cardType:String;

    /**
     * The credit card type.
     */    
    public function get cardType():String
    {
        return _cardType;
    }
    
    /**
     * @private
     */
    public function set cardType( value:String ):void
    {
        if (value != _cardType)
        {
            _cardType = value;
        }
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
    	//Only compare if value is an InputCreditCard
        if( value is InputCreditCard )
        {
            //Compare the properties
            return value.cardNumber == cardNumber &&
                   value.cardType == cardType;;
        }
        return false;
    }
}

}