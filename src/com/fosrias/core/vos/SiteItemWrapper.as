////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos
{
import com.fosrias.core.vos.interfaces.ANestedListItem;


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
}
	
}