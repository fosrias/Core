package com.fosrias.core.managers
{
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.events.WebBrowserEvent;
import com.fosrias.core.managers.interfaces.AManager;
import com.fosrias.core.managers.interfaces.AState;
import com.fosrias.core.managers.interfaces.AStatefulManager;
import com.fosrias.core.namespaces.app_internal;

import flash.events.Event;
import flash.utils.Dictionary;

import mx.core.Application;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
	
use namespace app_internal;

/**
 * The DebugManager class implements event handlers that convert event
 * results into debug messages.
 */
public class DebugManager extends AManager
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function DebugManager()
	{
		super( this );
		FlexGlobals.topLevelApplication.addEventListener( 
			FlexEvent.APPLICATION_COMPLETE, onApplicationComplete);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	private var _isComplete:Boolean = false;
	private var _pendingEvents:Dictionary = new Dictionary;
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
	public function watchBrowserURLChange(event:WebBrowserEvent):void
    {
    	if (!isComplete(event, showWebrowserEvent))
    	{
    		return;
    	}
    	showWebrowserEvent(event);
    }
    
    public function watchSetState(event:StateEvent):void
    {
    	if (!isComplete(event, showStateEvent))
        {
            return;
        }
        showStateEvent(event);
    }
    
    public function watchStateSet(event:StateEvent):void
    {
    	if (!isComplete(event, showStateEvent))
        {
            return;
        }
        showStateEvent(event);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    private function showStateEvent(event:StateEvent):void
    {
    	var message:String;
    	var type:String = event.type.replace("com.fosrias.core.events.","");
        if (event.data is AState)
    	{
	    	var state:AState = AState(event.data);
	        var manager:AStatefulManager = state.manager;
	        var path:String = state.fragmentSegment;
	        if (path != null)
	        {
	        	path.replace("/","")
	        }
	        message = type + (path != null ? " [Path " + path + "]" 
	             : "") + " " + manager.toString() + " " + state.toString();
        } else {
        	message = type + " " + "[State " + event.reference +"]";
        }
        message += " [Target " + event.target.name + "]";
        traceDebug(message);
    }
    
    private function showWebrowserEvent(event:WebBrowserEvent):void
    {
        var type:String = event.type.replace("com.fosrias.core.events.","");
        var message:String = " " + type + " [Fragment " + event.reference + "]";
        message += " [Target " + event.target.name + "]";
        traceDebug(message);
    }
    
    private function isComplete(event:Event, messageFunction:Function):Boolean
    {
    	if (!_isComplete)
    	{
    		_pendingEvents[event] = messageFunction;
    	}
    	return _isComplete;
    }
    
    private function onApplicationComplete(event:FlexEvent):void
    {
		FlexGlobals.topLevelApplication.removeEventListener(
    	    FlexEvent.APPLICATION_COMPLETE, onApplicationComplete);
        _isComplete = true;
        var messageFunction:Function;
        for (var pendingEvent:* in _pendingEvents)
        {
        	//Create the message
        	messageFunction = _pendingEvents[pendingEvent];
        	messageFunction(pendingEvent);
        	
        	//Clear record
        	_pendingEvents[pendingEvent] = null;
        	delete _pendingEvents[pendingEvent];
        }
        _pendingEvents = null;
    }
}

}