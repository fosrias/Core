////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.components
{
import mx.controls.DateField;
/**
 * The FixedDateField class updates the <code>DateField</code> 
 * <code>TextInput</code> immediately after the <code>selectedDate</code>
 * field is set instead of waiting until <code>commitProperties</code> is
 * called.
 */
public class FixedDatefield extends DateField
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function FixedDatefield() {}

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  selectedDate
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    override public function set selectedDate( value:Date ):void
	{
	   super.selectedDate = value;
	
	    dateFiller( selectedDate );
	}

    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function dateFiller( value:Date ):void
    {
        if (labelFunction != null)
            textInput.text = labelFunction( value );
        else
            textInput.text = dateToString(value, formatString);
    }

}

}