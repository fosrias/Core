////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils
{
import com.asfusion.mate.core.GlobalDispatcher;
import com.fosrias.core.interfaces.ADispatcher;
import com.fosrias.core.views.components.FileLoaderProgressBar;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.utils.ByteArray;
import flash.utils.clearTimeout;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.controls.SWFLoader;
import mx.core.FlexGlobals;
import mx.managers.PopUpManager;

public class FileLoader extends ADispatcher
{
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static var _instance:FileLoader;
	
	/**
	 * @private
	 */
	private static var _imageTypes:Array = 
		["gif",".jpg", ".png", ".svg", ".swf"];
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function FileLoader(enforcer:SingletonEnforcer)
	{
		super(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _documentTypes:Array = [".doc", ".pdf"];
	
	/**
	 * @private
	 */
	private var _documentMacTypes:Array = [];
	
	/**
	 * @private
	 */
	private var _imageTypes:Array = [".gif",".jpg", ".png", ".svg", ".swf"];
	
	/**
	 * @private
	 */
	private var _imageMacTypes:Array = [];
	
	/**
	 *  @private
	 */
	private var _isLoading:Boolean = false;
	
	/**
	 * @private
	 */
	private var _isLoadingIndex:uint = 0;
	
	/**
	 * @private
	 */
	private var _progressBar:FileLoaderProgressBar;
	
	/**
	 *  @private
	 */
	private var _showingDisplay:Boolean = false;
	
	/**
	 *  @private
	 */
	private var _startTime:int;
	
	/**
	 *  @private
	 */
	private var _swfLoader:SWFLoader;
	
	/**
	 * @private
	 */
	private var _textTypes:Array = [".txt", ".rtf"];
	
	/**
	 * @private
	 */
	private var _textMacTypes:Array = [];
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  fileContent
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the fileContent property.
	 */
	private var _fileContent:ByteArray;
	
	/**
	 * The file content of the loader.
	 */
	public function get fileContent():ByteArray
	{
		return _fileContent;
	}
	
	//----------------------------------
	//  fileReference
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the fileReference property.
	 */
	private var _fileReference:FileReference;
	
	/**
	 * The file reference of the loader.
	 */
	public function get fileReference():FileReference
	{
		return _fileReference;
	}
	
	//----------------------------------
	//  isImage
	//----------------------------------
	
	/**
	 * Whether the loaded file is an image or not.
	 */
	public function get isImage():Boolean
	{
		return checkImageType(_fileReference.type);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Opens the dialogue to load a file.
	 */
	public function browse(typeFilter:Array = null):void
	{
		if (typeFilter == null)
		{
			typeFilter = [ new FileFilter("All (*.*)", "*.*"),
						   buildFilter("Documents", _documentTypes, 
							   _documentMacTypes),
						   buildFilter("Images", _imageTypes, _imageMacTypes),
						   buildFilter("Text", _textTypes, _textMacTypes) ];
		}
		
		if (_fileReference != null)
		{
			_fileReference.removeEventListener(Event.SELECT, selectHandler); 
			_fileReference.removeEventListener(Event.CANCEL, cancelHandler); 
			_fileReference.removeEventListener(IOErrorEvent.IO_ERROR, 
				ioErrorHandler); 
			_fileReference.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler); 
		}
		
		_fileReference = new FileReference(); 
		
		_fileReference.addEventListener(Event.SELECT, selectHandler); 
		_fileReference.addEventListener(Event.CANCEL, cancelHandler); 
		_fileReference.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); 
		_fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
			securityErrorHandler);
		
		if (_isLoading)
		{
			clearTimeout(_isLoadingIndex);
			_isLoadingIndex = setTimeout(browse, 10, typeFilter);
			
		} else {
			
			clearTimeout(_isLoadingIndex);
			
			_fileReference.browse(typeFilter);
		}
	}
	
	/**
	 * Loads a remote file. Optionally it opens the file in browser.
	 */
	public function load(url:String, openInBrowser:Boolean):Boolean
	{
		if (openInBrowser)
		{ 
			navigateToURL( new URLRequest("http://" + url), "_blank");
			
			return false;
			
		} else {
			
			_swfLoader = new SWFLoader;
			
			_swfLoader.addEventListener(ProgressEvent.PROGRESS, 
				progressHandler);
			_swfLoader.addEventListener(Event.COMPLETE, completeHandler);
			_swfLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); 
			_swfLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
				securityErrorHandler);
			
			initialize();
			
			_swfLoader.load(url);
			
			return true;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function buildFilter(name:String, 
								 types:Array, 
								 macTypes:Array):FileFilter
	{
		var description:String = 
			name + " (" + types.join(",").replace(/\./g, "*.") + ")";
			
		var extension:String = types.join(";").replace(/\./g, "*.");
		
		var macType:String = null;
		
		if (macTypes.length > 0)
			macType = macTypes.join(";").replace("\.", "*.");
		
		return new FileFilter(description, extension, macType);
	}
	
	/**
	 * @private
	 */
	private function initialize():void
	{
		_startTime = getTimer();
	}
	
	/**
	 * @private
	 */
	private function selectHandler(event:Event):void 
	{ 
		
		_fileReference.removeEventListener(Event.SELECT, selectHandler); 
		_fileReference.removeEventListener(Event.CANCEL, cancelHandler); 
		
		_fileReference.addEventListener(ProgressEvent.PROGRESS, 
			progressHandler); 
		_fileReference.addEventListener(Event.COMPLETE, completeHandler);  

		initialize();
		
		_fileReference.load(); 
	} 
	
	/**
	 * @private
	 */
	private function progressHandler(event:ProgressEvent):void 
	{ 
		traceDebug("Loaded " + event.bytesLoaded + " of " + event.bytesTotal + 
			" bytes.");
		dispatchEvent(event);
		
		var loaded:uint = event.bytesLoaded;
		var total:uint = event.bytesTotal;
		
		var elapsedTime:int = getTimer() - _startTime;
		
		// Only show the Loading phase if it will appear for awhile.
		if (!_showingDisplay && showDisplayForDownloading(elapsedTime, event))
			show();
	} 
	
	/**
	 * @private
	 */
	private function completeHandler(event:Event):void 
	{ 
		traceDebug("File was successfully loaded.");
		
		if (_showingDisplay)
		{
			PopUpManager.removePopUp(_progressBar);
			_progressBar = null;
		}
		
		if (event.target is FileReference)
		{
			_fileReference.removeEventListener(Event.COMPLETE, completeHandler);  
			_fileReference.removeEventListener(ProgressEvent.PROGRESS, 
				progressHandler);  
			_fileReference.removeEventListener(IOErrorEvent.IO_ERROR, 
				ioErrorHandler); 
			_fileReference.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			_fileContent = _fileReference.data;
			
		} else if (event.target is SWFLoader) {
			
			_swfLoader.removeEventListener(Event.COMPLETE, completeHandler);  
			_swfLoader.removeEventListener(ProgressEvent.PROGRESS, 
				progressHandler); 
			_swfLoader.removeEventListener(IOErrorEvent.IO_ERROR, 
				ioErrorHandler); 
			_swfLoader.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			_fileContent = _swfLoader.content.loaderInfo.bytes;
			
			_swfLoader = null;
		}

		dispatchEvent(event);
	} 
	
	/**
	 * @private
	 */
	private function cancelHandler(event:Event):void 
	{ 
		traceDebug("The browse request was canceled by the user.");
		
		_fileReference.removeEventListener(ProgressEvent.PROGRESS, 
			progressHandler); 
		_fileReference.removeEventListener(Event.COMPLETE, completeHandler);
		
	} 
	
	/**
	 * @private
	 */
	private function ioErrorHandler(event:IOErrorEvent):void 
	{ 
		traceDebug("There was an IO Error.");
		
		if (event.target is FileReference)
		{
			_fileReference.removeEventListener(Event.COMPLETE, completeHandler);  
			_fileReference.removeEventListener(ProgressEvent.PROGRESS, 
				progressHandler);  
			_fileReference.removeEventListener(IOErrorEvent.IO_ERROR, 
				ioErrorHandler); 
			_fileReference.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);

		} else if (event.target is SWFLoader) {
			
			_swfLoader.removeEventListener(Event.COMPLETE, completeHandler);  
			_swfLoader.removeEventListener(ProgressEvent.PROGRESS, 
				progressHandler); 
			_swfLoader.removeEventListener(IOErrorEvent.IO_ERROR, 
				ioErrorHandler); 
			_swfLoader.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
	} 
	
	/**
	 * @private
	 */
	private function securityErrorHandler(event:Event):void 
	{ 
		traceDebug("There was a security error.");
		
		if (event.target is FileReference)
		{
			_fileReference.removeEventListener(Event.COMPLETE, completeHandler);  
			_fileReference.removeEventListener(ProgressEvent.PROGRESS, 
				progressHandler);  
			_fileReference.removeEventListener(IOErrorEvent.IO_ERROR, 
				ioErrorHandler); 
			_fileReference.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
		} else if (event.target is SWFLoader) {
			
			_swfLoader.removeEventListener(Event.COMPLETE, completeHandler);  
			_swfLoader.removeEventListener(ProgressEvent.PROGRESS, 
				progressHandler); 
			_swfLoader.removeEventListener(IOErrorEvent.IO_ERROR, 
				ioErrorHandler); 
			_swfLoader.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
	} 
	
	/**
	 *  @private
	 *  Make the display class visible.
	 */
	private function show():void
	{
		_progressBar = new FileLoaderProgressBar;
		
		if (_swfLoader != null)
		{
			_progressBar.source = _swfLoader;
			
		} else {
			
			_progressBar.source = _fileReference;
		}
		
		PopUpManager.addPopUp(_progressBar, 
			DisplayObject(FlexGlobals.topLevelApplication) );
		PopUpManager.centerPopUp(_progressBar);
		
		_showingDisplay = true;
	}
	
	/**
	 *  Defines the algorithm for determining whether to show
	 *  the download progress bar while in the download phase.
	 *
	 *  @param elapsedTime Number of milliseconds that have elapsed
	 *  since the start of the download phase.
	 *
	 *  @param event The ProgressEvent object that contains
	 *  the <code>bytesLoaded</code> and <code>bytesTotal</code> properties.
	 *
	 *  @return If the return value is <code>true</code>, then show the 
	 *  download progress bar.
	 *  The default behavior is to show the download progress bar 
	 *  if more than 700 milliseconds have elapsed
	 *  and if Flex has downloaded less than half of the bytes of the SWF file.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	private function showDisplayForDownloading(elapsedTime:int,
											   event:ProgressEvent):Boolean
	{
		return elapsedTime > 700 && event.bytesLoaded < event.bytesTotal / 2;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Static methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns a single instance of the file loader.
	 */
	public static function getInstance():FileLoader
	{
		if(FileLoader._instance == null)
		{
			FileLoader._instance = new FileLoader( new SingletonEnforcer() );
			
			//Set dispatcher for error messages
			_instance.dispatcher = IEventDispatcher(
				FlexGlobals.topLevelApplication);
		}
		
		return _instance;
	}
	
	/**
	 * Checks whether a type is corresponds to an image file
	 */
	public static function checkImageType(type:String):Boolean
	{
		return new ArrayCollection(_imageTypes).contains(type);
	}
}
	
}

class SingletonEnforcer {}
