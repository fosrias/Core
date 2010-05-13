////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.components
{
import mx.controls.Button;
import mx.controls.DateField;
import mx.core.mx_internal;
import mx.events.FlexEvent;

use namespace mx_internal;

public class IconlessDateField extends DateField
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function IconlessDateField()
    {
        super();
    }  
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  clickOpen
    //----------------------------------
    
    /**
     * Whether the popup opens when clicked and the <code>editable</code>
     * property is false.
     * 
     * @default true 
     */
    public var clickOpen:Boolean = true;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        textInput.setActualSize(unscaledWidth, unscaledHeight);
    }
    
    /**
     *  @private
     */
    override protected function downArrowButton_buttonDownHandler(
        event:FlexEvent):void
    {
        if (clickOpen)
            super.downArrowButton_buttonDownHandler(event);
    }
    
    
}

}