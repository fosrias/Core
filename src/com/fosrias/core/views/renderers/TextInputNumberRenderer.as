////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.renderers
{
import com.fosrias.core.utils.FormatterUtils;

import mx.controls.TextInput;
import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;
import mx.formatters.NumberFormatter;
import mx.resources.ResourceManager;

[Bindable]  
/**
 * The class is a AdvancedDataGridItemRenderer component with a 
 * <code>editorData</code> property that returns the value of the text 
 * as a number. Use this with formatted data or label functions to 
 * ensure the edited data is returned as a number
 * if that is expected.
 */
public class TextInputNumberRenderer extends TextInput
{
    //--------------------------------------------------------------------------
    //
    //  Constant
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     */
    private static const NUMBER_FORMATTER:NumberFormatter 
        = FormatterUtils.numberFormatter();
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function TextInputNumberRenderer()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  editorData
    //----------------------------------
    
    /**
     * The text converted to a number when used as an item editor.
     */
    public function get editorData():Number
    { 
        return Number(text.replace(NUMBER_FORMATTER.decimalSeparatorTo, '.').
            replace(NUMBER_FORMATTER.thousandsSeparatorTo, ''));
    }
}

}