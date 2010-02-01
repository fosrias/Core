////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.components
{
import mx.binding.utils.BindingUtils;
import mx.containers.Canvas;

/**
 * The BindingWatcherCanvas is a canvas with utility methods for watching 
 * and unwatching binding in a canvas. Use this for child canvases in 
 * popup components to enable garbage collection.
 */
public class BindingWatcherCanvas extends Canvas
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function BindingWatcherCanvas()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private var _openChangeWatchers:Array /* Array of ChangeWatcher */ = [];
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Clears the bindings.
     */
    public function unwatchBindings():void
    {
        //Clear ChangeWatchers
        while ( _openChangeWatchers.length > 0 )
        {
            _openChangeWatchers.pop().unwatch();
        }
    } 
    
    /**
     * Sets the bindings. Override this and use the <code>bindingSetter</code> 
     * utility method in the body of this method to define bindings.
     */
    public function watchBindings():void
    {
        //Do nothing
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override protected function initializationComplete():void
    {
        watchBindings();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * A utility method to create binding setters in the component. Use
     * this method to create binding setters with strong references as
     * they will be cleared automatically when the component is destroyed
     * if opened with a PopUpLoader for garbage collecion.
     */
    protected function bindSetter( setter:Function, host:Object,
                                   chain:Object,
                                   commitOnly:Boolean = false,
                                   useWeakReference:Boolean = false ):void
    {
        _openChangeWatchers.push( BindingUtils.bindSetter( setter, host, chain, 
            commitOnly, useWeakReference ) );
    }  
}

}