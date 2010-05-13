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
import com.fosrias.core.views.skins.ProgressBarSkin;

import mx.controls.ProgressBar;
import mx.controls.ProgressBarMode;

/**
 * The ManualProgressBar is a ProgressBar extension that only runs in manual
 * mode. The progress is updated by setting the <code>progress</code> property
 * which is relative to the <code>maximum</code> property. If the 
 * <code>maximum</code> the progress should be a decimal between 0 and 1.
 */
public class ManualProgressBar extends ProgressBar
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function ManualProgressBar()
    {
        super();
        setStyle("barSkin", ProgressBarSkin);
        
        mode = ProgressBarMode.MANUAL;
        maximum = 1;
        minimum  = 0;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  value
    //----------------------------------
    
    [Bindable]
    /**
     * The value of the status bar progress. Setting this property updates the
     * progress of the bar relative to the <code>maximum</code> value.
     */
    public function set value(value:Number):void
    {
        //Resets the skin with the new barColor
        setStyle("barSkin", null);
        setStyle("barSkin", ProgressBarSkin);
        setProgress(value, maximum);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override public function get mode():String
    {
        return ProgressBarMode.MANUAL;
    }
}

}