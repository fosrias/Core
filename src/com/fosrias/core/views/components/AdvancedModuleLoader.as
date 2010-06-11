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
import flash.display.DisplayObject;
import flash.events.Event;
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;

import mx.core.UIComponent;
import mx.events.ModuleEvent;
import mx.modules.ModuleLoader;

/**
 * The AdvancedModuleLoader class resizes child components to the size of the
 * loader.
 */
public class AdvancedModuleLoader extends ModuleLoader
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function AdvancedModuleLoader()
    {
        super();
        addEventListener(ModuleEvent.READY, moduleReadyHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  childMinWidth
    //----------------------------------
    
    /**
     * The minimum width of the child
     */
    public function get childMinWidth():Number
    {
        if (child != null && child is UIComponent)
        {
            return UIComponent(child).minWidth;
        } else {
            return NaN;
        }
    }

    /**
     * @private
     */
    public function set childMinWidth(value:Number):void
    {
        if (child != null && child is UIComponent)
        {
            UIComponent(child).minWidth = value;
        } 
    }

    //----------------------------------
    //  childMinHeight
    //----------------------------------
    
    /**
     * The minimum height of the child
     */
    public function get childMinHeight():Number
    {
        if (child != null && child is UIComponent)
        {
            return UIComponent(child).minHeight;
        } else {
            return NaN;
        }
    }
    
    /**
     * @private
     */
    public function set childMinHeight(value:Number):void
    {
        if (child != null && child is UIComponent)
        {
            UIComponent(child).minHeight = value;
        } 
    }
    
    //----------------------------------
    //  childWidth
    //----------------------------------
    
    /**
     * The width of the child
     */
    public function get childWidth():Number
    {
        if (child !== null)
        {
            return child.width;
        } else {
            return NaN;
        }
    }
    
    /**
     * @private
     */
    public function set childWidth(value:Number):void
    {
        if (child != null)
        {
            child.width = value;
        } 
    }
    
    //----------------------------------
    //  childHeight
    //----------------------------------
    
    /**
     * The height of the child
     */
    public function get childHeight():Number
    {
        if (child != null && child is UIComponent)
        {
            return UIComponent(child).minWidth;
        } else {
            return NaN;
        }
    }
    
    /**
     * @private
     */
    public function set childHeight(value:Number):void
    {
        if (child != null)
        {
            child.height = value;
        } 
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override public function loadModule(url:String = null, 
                                        bytes:ByteArray = null):void
    {
        super.loadModule(url, bytes);
        
        if ( hasEventListener(ModuleEvent.READY) )
            removeEventListener(ModuleEvent.READY, moduleReadyHandler);
        
        addEventListener(ModuleEvent.READY, moduleReadyHandler, false, 0, true);
        
        if ( hasEventListener(Event.RESIZE) )
            removeEventListener(Event.RESIZE, resizeHandler);
        
        addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
    }
    
    /**
     * @inheritDoc
     */
    private function moduleReadyHandler(event:ModuleEvent):void
    {
        //Resize the child
        resizeHandler();
    }
    
    /**
     * @inheritDoc
     */
    override public function unloadModule():void
    {
        super.unloadModule();
        removeEventListener(Event.RESIZE, resizeHandler);
        removeEventListener(ModuleEvent.READY, moduleReadyHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * private
     */
    private function resizeHandler(event:Event = null):void
    {
        if (child != null)
        {
            child.width = width;
            child.height = height;
        }
    }
}

}