////////////////////////////////////////////////////////////////////////////////
//
//    Copyright (c) 2010        Mark W. Foster        www.fosrias.com
//    All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.vos
{
import com.fosrias.core.namespaces.app_internal;

import mx.collections.ArrayCollection;

use namespace app_internal;

[RemoteClass(alias="com.fosrias.site.components.utility.Defaults")]
[Bindable]
public class SiteDefaults
{    
	//--------------------------------------------------------------------------
    //
    //    Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function SiteDefaults()
    {
    
    }    
    
    //--------------------------------------------------------------------------
    //
    //    Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //    itemTypes
    //----------------------------------
    
    /**
     * The item type selectors.
     */
    public var itemTypes:Array;
    
    //----------------------------------
    //    masterItem
    //----------------------------------
    
    private var _masterItem:SiteItem;

    /**
     * The master item of the site. This item is the parent directly or 
	 * indirectly of all the items in the site.
     */
    public function get masterItem():SiteItem
    {
    	return _masterItem;
    }

    /**
     * @private
     */
    public function set masterItem(value:SiteItem):void
    {
    	_masterItem = value;
        
		//Sets the master item id as a class variable
	    if (_masterItem != null)
		    _masterItem.setAsMaster();
    }
}

}
