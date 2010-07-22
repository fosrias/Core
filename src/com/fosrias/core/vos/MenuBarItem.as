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
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function MenuBarItem(label:String, groupType:String = null,
        state:Object = null, substate:Object = null)
    {
        _label = label;
        _groupType = groupType;
        _state = state;
        _substate = substate;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  children
    //----------------------------------
    
//    /**
//     * @private
//     * Storage for the children property.
//     */
//    private var _children:Array = [];
//    
//    /**
//     * The children of the item.
//     */
//    public function get children():Array
//    {
//        return _children;
//    }
    
    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * A clone of the instance.
     */
    public function get clone():MenuBarItem
    {
        var clone:MenuBarItem = 
            new MenuBarItem(_label, _groupType, _state, _substate);
        
        if (hasOwnProperty("children"))
            clone["children"] = ArrayUtils.clone(this.children);
        return clone;
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
    //  hasState
    //----------------------------------
    
    /**
     * Whether the item has a state or not.
     */
    public function get hasState():Boolean
    {
        return _state != null;
    }
    
    //----------------------------------
    //  hasSubstate
    //----------------------------------
    
    /**
     * Whether the item has a substate or not.
     */
    public function get hasSubstate():Boolean
    {
        return _substate != null;
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
    //  state
    //----------------------------------
    
    /**
     * @private
     * Storage for the state property.
     */
    private var _state:Object;

    /**
     * The state associated with the menu.
     */
    public function get state():Object
    {
        return _state;
    }
    
    //----------------------------------
    //  substate
    //----------------------------------
    
    /**
     * @private
     * Storage for the substate property.
     */
    private var _substate:Object;

    /**
     * The substate associated with the menu
     */
    public function get substate():Object
    {
        return _substate;
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