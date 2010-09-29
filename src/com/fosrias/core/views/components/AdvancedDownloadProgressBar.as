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
import com.fosrias.core.events.DebugEvent;

import flash.events.Event;
import flash.events.ProgressEvent;

import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.preloaders.DownloadProgressBar;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleManager2;
import mx.styles.StyleManager;

/**
 * The AdvancedDownloadProgressBar extends the <code>DownloadProgressBar</code> 
 * class to give functionality that allows the number of initialization steps 
 * to be custom set. The default system value is 6. 
 * 
 * To require extra initialization steps, extend this class and set the 
 * <code>initProgressTotal</code> in the constructor.
 * 
 * Then for each extra initialization step, dispatch a 
 * <code>FlexEvent.INIT_PROGRESS</code> event to the extended instance to
 * increment the download progress. 
 */
public class AdvancedDownloadProgressBar extends DownloadProgressBar
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function AdvancedDownloadProgressBar()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private var _hasCompleteEvent:Boolean = false;
    
    /**
     *  @private
     */
    private var _initProgressCount:uint = 0;
	
	
	/**
	 *  @private
	 */
	private var _timestamp:Date = new Date();
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  basic
    //----------------------------------
    
    /**
     * @private
     * Storage for the basic property.
     */
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     * 
     * @private
     * Called after all the bytes are loaded.
     */
    override protected function completeHandler(event:Event):void
    {
        //Listen on the application for FlexEvent.INIT_PROGRESS events
        //that will complete custom initializations
        FlexGlobals.topLevelApplication.addEventListener(
            FlexEvent.INIT_PROGRESS, initProgressHandler);
		
		//Let the debug console know, if it is active
		var date:Date = new Date();
		
		FlexGlobals.topLevelApplication.dispatchEvent( new DebugEvent(
			DebugEvent.SET_MESSAGE, "Application loaded in " 
				+ ( (date.getTime() - _timestamp.getTime())/1000).toString() 
				+  " s") );
    }
    
    /**
     * Event listener for the <code>FlexEvent.INIT_PROGRESS</code> event. 
     * @inheritDoc
     */
    override protected function initProgressHandler(event:Event):void
    {
        _initProgressCount++;
		
		//Let the debug console know, if it is active
		FlexGlobals.topLevelApplication.dispatchEvent( new DebugEvent(
			DebugEvent.SET_MESSAGE, "Initialization progress: " + 
			_initProgressCount.toString() + " of " 
			+ initProgressTotal.toString() ) );
			
        super.initProgressHandler(event);
        
        if (_initProgressCount > initProgressTotal && _hasCompleteEvent)
        {
            dispatchEvent(new FlexEvent(FlexEvent.INIT_COMPLETE));
        }
    }
    
    /**
     *  Event listener for the <code>FlexEvent.INIT_COMPLETE</code> event. 
     *
     *  @param event The event object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function initCompleteHandler(event:Event):void
    {
        if (_initProgressCount > initProgressTotal)
        {
            super.initCompleteHandler(event);
        } else {
            _hasCompleteEvent = true;
        }
    } 
}

}