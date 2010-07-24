////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos
{
import com.fosrias.core.utils.ArrayUtils;

import flash.events.Event;

import mx.controls.menuClasses.MenuBarItem;

/**
 * 
 * @author mfoster
 * 
 */
public dynamic class MenuBarItem
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    public static const CHECK:String = "check";
    
    public static const NORMAL:String = "normal";
    
    public static const RADIO:String = "radio";
    
    public static const SEPARATOR:String = "separator";
    
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function MenuBarItem(label:String, 
                                event:Event = null, 
                                type:String = "normal",
                                groupType:String = null)
    {
        _label = label;
        _event = event
        
        //REFACTOR: Add type checking
        _type = type;
        _groupType = groupType;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  children
    //----------------------------------
    
    /**
     * The children property is dynamically added if child menu items
     * are added to the class.
     */        
    
    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * A clone of the instance.
     */
    public function get clone():MenuBarItem
    {
        var eventClone:Event = null;
        
        if (_event != null)
            eventClone = _event.clone();
        
        var clone:MenuBarItem = 
            new MenuBarItem(_label, eventClone, _type, _groupType);
        
        clone.enabled = enabled;
        clone.toggled = toggled;
        
        if (hasOwnProperty("children"))
            clone["children"] = ArrayUtils.clone(this.children);
        return clone;
    }
    
    //----------------------------------
    //  enabled
    //----------------------------------
    
    /**
     * Whether the menu item is enabled or not. 
     */
    public var enabled:Boolean = true;
    
    //----------------------------------
    //  event
    //----------------------------------
    
    /**
     * @private
     * Storage for the event property.
     */
    private var _event:Event;
    
    /**
     * The event to be dispatched when the menu item is selected.
     */
    public function get event():Event
    {
        return _event;
    }
    
    //----------------------------------
    //  groupType
    //----------------------------------
    
    /**
     * @private
     * Storage for the groupType property.
     */
    private var _groupType:String;
    
    /**
     * The group type used to group labels in the toolbar.
     */
    public function get groupType():String
    {
        return _groupType;
    }
    
    //----------------------------------
    //  hasEvent
    //----------------------------------
    
    /**
     * Whether the item has an event associated with it or not.
     */
    public function get hasEvent():Boolean
    {
        return _event != null;
    }
    
    //----------------------------------
    //  label
    //----------------------------------

    /**
     * @private
     * Storage for the label property.
     */
    private var _label:String

    /**
     * The label.
     */
    public function get label():String
    {
        return _label;
    }
    
    //----------------------------------
    //  toggled
    //----------------------------------
    
    /**
     * Whether the menu item is toggled or not. 
     */
    public var toggled:Boolean = false;
    
    //----------------------------------
    //  type
    //----------------------------------
    
    /**
     * @private
     * Storage for the type property.
     */
    private var _type:String;
    
    /**
     * The type of item.
     */
    public function get type():String
    {
        return _type;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Adds a child to the menu bar item.
     */
    public function addChild(value:MenuBarItem):void
    {
        if (!hasOwnProperty("children"))
        {
            this["children"] = [];
        }
        this.children.push(value);
    }
}

}