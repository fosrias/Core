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
import com.fosrias.core.managers.interfaces.ADownloadProgressManager;

import flash.events.Event;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import mx.events.FlexEvent;
import mx.preloaders.DownloadProgressBar;

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
public class AdvancedMXDownloadProgressBar extends DownloadProgressBar
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function AdvancedMXDownloadProgressBar(manager:ADownloadProgressManager)
	{
		super();
		
		_manager = manager;
		
		if ( !isNaN(_manager.initializationSteps) )
		{
			initProgressTotal += _manager.initializationSteps;
		}
		
		if ( !isNaN(_manager.minimumDisplayTime) )
		{
			MINIMUM_DISPLAY_TIME = _manager.minimumDisplayTime;
		}
		
		_manager.addEventListener(Event.COMPLETE, reportCompleteHandler);
		_manager.addEventListener(FlexEvent.INIT_PROGRESS, 
			initProgressHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	private var _completeIndex:uint = 0;
	
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
	private var _initEvent:Event;
	
	/**
	 *  @private
	 */
	private var _manager:ADownloadProgressManager;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Event listener for the <code>FlexEvent.INIT_PROGRESS</code> event. 
	 * @inheritDoc
	 */
	override protected function initProgressHandler(event:Event):void
	{
		_initProgressCount++;
		
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
			_initEvent = event;
			
		} else {
			_hasCompleteEvent = true;
		}
	} 
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private 
	 */
	private function reportCompleteHandler(event:Event):void
	{
		clearTimeout(_completeIndex);
		
		if (_initEvent)
		{
			super.initCompleteHandler(_initEvent);
			
		} else {
			
			_completeIndex = setTimeout(reportCompleteHandler, 10, event);
		}
	}
}

}