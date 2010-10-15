////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.models
{
import com.fosrias.site.vos.SiteItem;
import com.fosrias.site.vos.SiteItemWrapper;

[Bindable]
/**
 * The SiteHierarchicalItemData class is used for managing hierarchial site 
 * items in the content manager.
 */
public class SiteHierarchicalItemData extends HierarchicalItemData
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function SiteHierarchicalItemData(value:Object=null)
	{
		super(value, SiteItemWrapper);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  itemUpEnabled
	//----------------------------------
	
	[Bindable("selectedIndexChange")]
	override public function get itemUpEnabled():Boolean
	{
		if (_selectedParent.type == SiteItem.SITE)
		{
			//Can't move above home page.
			return _selectedListItemChildIndex > 1;
			
		} else {
			return _selectedListItemChildIndex > 0;
		}
		
	}

}
	
}