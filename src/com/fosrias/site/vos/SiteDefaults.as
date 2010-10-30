////////////////////////////////////////////////////////////////////////////////
//
//    Copyright (c) 2010        Mark W. Foster        www.fosrias.com
//    All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.vos
{
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.site.models.SiteHierarchicalItemData;

import flash.events.Event;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.collections.HierarchicalCollectionView;
import mx.collections.HierarchicalData;
import mx.controls.Alert;

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
	//    Variables
	//
	//--------------------------------------------------------------------------
	
	private var _authorSource:Object;
	
	private var _categorySource:Object;
	
	private var _hierarchicalItems:SiteHierarchicalItemData;
	
	private var _linkToItemMap:Dictionary = new Dictionary;
	
	private var _linkToRelatedItemIdMap:Dictionary = new Dictionary;
	
	private var _siteSource:Object;
	
	
	//--------------------------------------------------------------------------
	//
	//    Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    homeItem
	//----------------------------------
	
	/**
	 * The home item.
	 */
	public function get homeItem():Object
	{
		return _hierarchicalItems.findItemById(items[1].id);
	}
	
	//----------------------------------
	//    menuSource
	//----------------------------------
	
	/**
	 * The menu source for the site.
	 */
	public function get menuSource():HierarchicalData
	{
		return new HierarchicalData(_siteSource);
	}
	
	//--------------------------------------------------------------------------
	//
	//    Remote properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    items
	//----------------------------------
	
	/**
	 * The site default items.
	 */
	public var items:Array; /* of SiteItem */
	
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
	
	//--------------------------------------------------------------------------
	//
	//    Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Initializes the defaults.
	 */
	public function initialize():void
	{
		//Create Hierarchical version
		_hierarchicalItems = new SiteHierarchicalItemData(items);
		
		//Extract the groups
		_siteSource     = _hierarchicalItems.source[0];
		_authorSource   = _hierarchicalItems.source[1];
		_categorySource = _hierarchicalItems.source[2];
		
		//Map the links	
		var linksCollection:ArrayCollection = 
			new ArrayCollection( items.slice() );
		
		linksCollection.filterFunction = linksFilter;
		linksCollection.refresh();
		
		var parent:Object;
		
		for each (var item:Object in linksCollection)
		{
			if (item.isLink)
			{
				_linkToItemMap[item.name] = item;
				
			} else if (item.isLinkItem) {
				
				//Links are always directly related to another item.
				_linkToItemMap[item.name] = 
					_hierarchicalItems.findItemById(item.relatedItemId);
				
				_linkToRelatedItemIdMap[item.name] = item.relatedItemId;
			}
		}
	}
	
	/**
	 * Returns the item associated with a link. 
	 * 
	 * @see com.fosrias.views.components.ItemLinkButton;
	 */
	public function findLinkedItem(value:String):Object
	{
		var item:Object = _linkToItemMap[value];
		
		if (item != null)
		{
			return item;
			
		} else {
			
			var id:Number = _linkToRelatedItemIdMap[value];
			
			if ( !isNaN(id) )
			{
				return id;
			} 
		}
		
		Alert.show("We are sorry. The link you clicked " + 
			"appears to be broken.", "Link Error");
		
		//REFACTOR: Add error reporting functionality here.
		return null;
	}
	
	/**
	 * Returns an array of list items.
	 */
	public function findLists():Array
	{
		var listsCollection:ArrayCollection = 
			new ArrayCollection( items.slice() );
		
		var lists:Array = [];
		
		listsCollection.filterFunction = listsFilter;
		listsCollection.refresh();
		
		for each (var item:Object in listsCollection)
		{
			
			lists.push( _hierarchicalItems.findItemById(item.id) );
		}
		
		//Check if a search item is included
		if (_linkToItemMap["Search"] == null)
		{
			//Add system search item.
			var search:SiteItem = new SiteItem(0, _masterItem.id, 0, 
				SiteItem.SEARCH, "Search", "Search List", 0, false, null, 
				"search", "Search","", true, true, false, 0,0, true, true);
			
			//Register it as a link.
			_linkToItemMap[search.name] = search;
			
			lists.push( new SiteItemWrapper(search) );
		}
		
		return lists;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Private methods
	//
	//--------------------------------------------------------------------------
		
	/**
	 * @private
	 */
	private function linksFilter(item:Object):Boolean
	{
		return item.isLink || item.isLinkItem;
	}
	
	/**
	 * @private
	 */
	private function listsFilter(item:Object):Boolean
	{
		return item.isList || item.isListFilter;
	}
}

}
