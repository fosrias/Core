////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosware.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils.popups
{
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.utils.popups.interfaces.APopUpLoaderDecorator;
import com.fosrias.core.utils.popups.interfaces.IPopUpLoader;

import mx.core.UIComponent;

use namespace app_internal;
/**
 * The StatefulPopUpLoaderDecorator class is a PopUpLoader Decorator that 
 * modifies setting the state property of a popup from the standard view 
 * state of the component to dispatching a <code>StateEvent.SET_STATE</code> 
 * event. This decorator is used with popups that have a 
 * <code>lt&;LocalEventMapgt&;</code> with its own state manager.
 */
public class StatefulPopUpLoaderDecorator extends APopUpLoaderDecorator
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function StatefulPopUpLoaderDecorator( popUpLoader:IPopUpLoader )
	{
	    super( this, popUpLoader );
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc 
     */
    override public function addPopUp():void
    {
    	super.addPopUp();
    	state =_popUpLoader.state;
    }
    
	/**
     * @inheritDoc
     * 
     * @private
     * Override sets the state for the popup in its associates state manager.
     */
    override public function set state( value:String ):void
    {
        _popUpLoader.state = value;
        if ( value != null && value != "" )
        {
           var parent:UIComponent = _popUpLoader.parent;
           parent.dispatchEvent( new StateEvent( StateEvent.SET_STATE, null,
                value ) );
        }
    }
}

}