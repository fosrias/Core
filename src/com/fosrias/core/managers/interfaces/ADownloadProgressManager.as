////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.managers.interfaces
{
import com.asfusion.mate.core.GlobalDispatcher;
import com.fosrias.core.interfaces.ADispatcher;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.FileFilter;
import flash.net.FileReference;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;

public class ADownloadProgressManager extends ADispatcher
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function ADownloadProgressManager(self:ADownloadProgressManager,
											 enforcer:Object)
	{
		super(self);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  initializationSteps
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the initializationSteps property
	 */
	private var _initializationSteps:Number = NaN;
	
	/**
	 * The number of extra initialization steps to be used. Unless specifically 
	 * set, this defaults to <code>NaN</code> and has no effect.
	 */
	public function get initializationSteps():Number
	{
		return _initializationSteps;
	}
	
	//----------------------------------
	//  minimumDisplayTime
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the minimumDisplayTime property
	 */
	private var _minimumDisplayTime:Number = NaN;
	
	/**
	 * The minimum display time to be used. Unless specifically set, this
	 * defaults to <code>NaN</code> and has no effect.
	 */
	public function get minimumDisplayTime():Number
	{
		return _minimumDisplayTime;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Reports the download progress is complete.
	 */
	public function reportComplete():void
	{
		dispatchEvent( new Event(Event.COMPLETE) );
	}
	
	/**
	 * Reports a single initialization progress step.
	 */
	public function reportProgress():void
	{
		dispatchEvent( new FlexEvent(FlexEvent.INIT_PROGRESS) );
	}
	
	//--------------------------------------------------------------------------
	//
	//  Static methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns a single instance of the download progress manager.
	 */
	protected static function createInstance(singleton:Class, 
											 enforcer:Class,
											 instance:ADownloadProgressManager):ADownloadProgressManager
	{
		if(instance == null)
		{
			instance = new singleton( new enforcer() );
			
			//Set dispatcher for error messages
			instance.dispatcher = 
				IEventDispatcher(FlexGlobals.topLevelApplication);
		}
		
		return instance;
	}
}
	
}