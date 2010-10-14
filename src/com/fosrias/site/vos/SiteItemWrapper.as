////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.vos
{
import com.fosrias.site.vos.interfaces.ANestedListItem;

import flashx.textLayout.elements.TextFlow;


public dynamic class SiteItemWrapper extends HierarchicalItemWrapper
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function SiteItemWrapper(value:ANestedListItem)
	{
		super(value);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  content
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the basic property.
	 */
	public function get content():SiteItemContent
	{
		return SiteItem(source).content;
	}
	
	public function set content(value:SiteItemContent):void
	{
		SiteItem(source).content = value;
	}
	
	//----------------------------------
	//  hasLoadedContent
	//----------------------------------
	
	/**
	 * Whether the content for the site item is loaded.
	 */
	public function get hasLoadedContent():Boolean
	{
		return SiteItem(source).hasLoadedContent;
	}
	
	//----------------------------------
	//  hasSubmenus
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item is a menu that should show submenus or not.
	 */
	public function get hasSubmenus():Boolean
	{
		return SiteItem(source).hasSubmenus;
	}
	
	//----------------------------------
	//  isMenu
	//----------------------------------
	
	/**
	 * Whether item is a menu or not.
	 */
	public function get isMenu():Boolean
	{
		return SiteItem(source).isMenu;
	}
	
	//----------------------------------
	//  isLink
	//----------------------------------
	
	/**
	 * Whether item name is a link or not.
	 */
	public function get isLink():Boolean
	{
		return SiteItem(source).isLink;
	}
	
	public function set isLink(value:Boolean):void
	{
		SiteItem(source).isLink = value;
	}
	
	//----------------------------------
	//  isList
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item is a list or not.
	 */
	public function get isList():Boolean
	{
		return SiteItem(source).isList;
	}
	
	//----------------------------------
	//  isMenuItem
	//----------------------------------
	
	/**
	 * Whether item is a menu item or not.
	 */
	public function get isMenuItem():Boolean
	{
		return SiteItem(source).isMenuItem;
	}
	
	public function set isMenuItem(value:Boolean):void
	{
		SiteItem(source).isMenuItem = value;
	}
	
	//----------------------------------
	//  text
	//----------------------------------
	
	/**
	 * The text of the content, if loaded.
	 */
	public function get text():String
	{
		if (hasLoadedContent)
		{
			return SiteItem(source).content.text;
			
		} else {
			
			return null;
		}
	}	
	
	//----------------------------------
	//  textFlow
	//----------------------------------
	
	/**
	 * The text flow of the content, if loaded.
	 */
	public function get textFlow():TextFlow
	{
		if (hasLoadedContent)
		{
			return SiteItem(source).textFlow;
			
		} else {
			
			return null;
		}
	}
}
	
}