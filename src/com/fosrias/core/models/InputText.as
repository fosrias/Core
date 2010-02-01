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
 * The InputText class is a used in MXML views and 
 * <code>AValidatedViewModel</code> presentation models to implement 
 * validation functionality in the view via its presentation model for
 * text fields.
 * 
 * @see com.fosrias.core.models.interfaces.AInputData
 * @see com.fosrias.core.views.components.TextInputFormItem.mxml
 * @see com.fosrias.core.views.interfaces.AValidatedViewModel
 */
public class InputText extends AInputData
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function InputText( required:Boolean = false ) 
    {
    	super( this, required );
    }
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------- 
    
    //----------------------------------
    //  text
    //----------------------------------
    
    /**
     * @private
     * Storage for the text property 
     */
    private var _text:String;
    
    /**
     * @inheritDoc
     * 
     * @private
     * Implements IValidatedText.
     */    
    public function get text():String
    {
    	return _text;
    }
    
    /**
     * @private
     */
    public function set text( value:String ):void
    {
    	if (value != _text)
    	{
	    	_text = value;
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
    	//Only compare if value is an InputText
        if( value is InputText )
        {
            //Compare the properties
            return value.text == text;
        }
        return false;
    }
}

}