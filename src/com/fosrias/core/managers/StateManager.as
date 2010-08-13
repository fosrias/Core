////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.managers
{
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.managers.interfaces.AManager;
import com.fosrias.core.managers.interfaces.AState;
import com.fosrias.core.managers.interfaces.AStatefulManager;
import com.fosrias.core.namespaces.app_internal;

import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.utils.UIDUtil;

use namespace app_internal;


public class StateManager extends AManager
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function StateManager()
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
    private var _stateTypeToManagerMap:Dictionary = new Dictionary;
    
    /**
     * @private
     */
    private var _watchedStateTypeToManagerMap:Dictionary = new Dictionary;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Registers the manager and maps its states to itself.
     * 
     * @param event The event with the manager as its data.
     * 
     */
    public function register(event:StateEvent):void
    {
        var manager:AManager = AManager(event.data);
        var isMapped:Boolean = false;
        var mappedManagers:ArrayCollection;
        var type:*;
        
        //Only monitor initial registrations
        if (event.reference != AManager.INITIAL_REGISTRATION)
            return;
        
        //Register managers mapped states 
        if (manager is AStatefulManager)
        {
            for (type in AStatefulManager(manager).stateMap)
            {
                mappedManagers = ArrayCollection(_stateTypeToManagerMap[type]);
                
                if (mappedManagers == null)
                {
                    _stateTypeToManagerMap[type] = 
                        new ArrayCollection([manager]);
                } else {
                    
                    //Check if the manager has already been mapped
                    for each (var mappedManager:AManager in mappedManagers)
                    {
                        if (UIDUtil.getUID(manager) == 
                            UIDUtil.getUID(mappedManager))
                        {
                            isMapped = true;
                            break;
                        }
                    }
                    
                    //If not mapped, map it. This allows multiple manager
                    //instances to listen for the event if not globally 
                    //cached.
                    if (!isMapped)
                    {
                        mappedManagers.addItem(manager);
                    }
                }
            }
        }
        
        //Register managers watched states, if any
        isMapped = false;
        if (manager.watchedStates != null)
        {
            for (type in manager.watchedStates)
            {
                mappedManagers = 
                    ArrayCollection(_watchedStateTypeToManagerMap[type]);
                
                if (mappedManagers == null)
                {
                    _watchedStateTypeToManagerMap[type] = 
                        new ArrayCollection([manager]);
                } else {
                    for each (mappedManager in mappedManagers)
                    {
                        if (UIDUtil.getUID(manager) == 
                            UIDUtil.getUID(mappedManager))
                        {
                            isMapped = true;
                            break;
                        }
                    }
                    
                    if (!isMapped)
                    {
                        mappedManagers.addItem(manager);
                    }
                }
            }
        }
    }
    
    /**
     * 
     * @param type
     * @param parameters
     * @return 
     * 
     */    
    public function setState(type:Object, 
                             parameters:Object = null):Boolean
    {
        var event:StateEvent; 
        var stateType:String;
            
        //Get the correct type
        if (type is StateEvent)
        {
            stateType = type.reference;
        } else {
            stateType = String(type);
        }
        
        var mappedManagers:ArrayCollection = _stateTypeToManagerMap[stateType];
        if (mappedManagers != null)
        {
            //Call the manager's setState method it the state is mapped to
            //managers.
            for each (var manager:AStatefulManager in mappedManagers)
            {
                if (manager.setState(type, parameters))
                {
                    var mappedWatchingManagers:ArrayCollection = 
                        _watchedStateTypeToManagerMap[stateType];
                    
                    if (mappedWatchingManagers != null)
                    {
                        var state:AState = manager.state;
                        
                        //Call the stateSet method if the managers watch
                        //for the state.
                        for each (var watchingManager:AManager in 
                            mappedWatchingManagers)
                        {
                            watchingManager.stateSet(new StateEvent(
                                StateEvent.STATE_SET, state, stateType));
                        }
                    }
                }
                traceDebug("State set: " + stateType, type.toString());
            } 
            return true;
        } else {
            return false;
        } 
    }
    
    /**
     * Calls the stateSet method on any managers mapped to watch the 
     * state being set.
     */
    override public function stateSet(event:StateEvent):void
    {
        var state:AState = AState(event.data);
        var mappedManagers:ArrayCollection = 
            _watchedStateTypeToManagerMap[state.type];
        
        
        if (mappedManagers != null)
        {
            //Call the manager's stateSet method if the managers watch
            //for the state.
            for each (var manager:AManager in mappedManagers)
            {
                manager.stateSet(event);
            }
        }
    }
}

}