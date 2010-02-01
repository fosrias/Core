////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils.popups.interfaces
{
import com.fosrias.core.interfaces.AFactory;
import com.fosrias.core.namespaces.app_internal;

import mx.collections.ArrayCollection;
import mx.core.IUIComponent;

use namespace app_internal;
/**
 * The IPopUpComponent is implemented by UIComponent class that control
 * popups as a function of state.
 * 
 * @see com.fosrias.core.views.PopUpCanvas
 * @see com.fosrias.core.views.PopUpPanel
 * @see com.fosrias.core.views.PopUpTitleWindow
 * @see com.fosrias.core.views.StatefulPopUpCanvas
 * @see com.fosrias.core.views.StatefulPopUpPanel
 * @see com.fosrias.core.views.StatefulPopUpTitleWindow
 */
public interface IPopUpComponent extends IUIComponent
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  popUpFactory
    //----------------------------------
    
    /**
     * A simple factory that creates UIComponents that are opened as popups.
     */
    function get popUpFactory():AFactory;
    
    /**
     * @private
     */
    function set popUpFactory( value: AFactory ):void;
    
    //----------------------------------
    //  openPopUpKeys
    //----------------------------------
    
    /**
     * A collection of open popup keys.
     */
    function get openPopUpKeys():ArrayCollection;
}

}