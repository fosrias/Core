////////////////////////////////////////////////////////////////////////////////
//
//    Copyright (c) 2010        Mark W. Foster        www.fosrias.com
//    All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.vos
{    
import com.fosrias.core.models.Memento;
import com.fosrias.core.models.interfaces.IIsEqual;
import com.fosrias.core.models.interfaces.IMemento;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.namespaces.memento_internal;
import com.fosrias.core.vos.interfaces.ATimestamp;

import flash.display.Bitmap;
import flash.utils.ByteArray;

use namespace app_internal
use namespace memento_internal;

[RemoteClass(alias="CFCore.com.fosrias.site.components.physical.SiteItemContent")]
[Bindable]
/**
 * The SiteItemContent class is content of a corresponding <code>SiteItem</code>
 * instance. This class returns the related <code>SiteItem</code> when loaded 
 * from the server.
 */
public class SiteItemContent extends ATimestamp
						     implements IIsEqual
{   
    //--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function SiteItemContent(id:int = 0,
								    siteItemId:int = 0,
									text:String = null,
								    link:String = null,
									fileLocation:String = null,
								    fileName:String = null,
									fileSize:Number = NaN,
									fileType:String = null,
									fileContent:ByteArray = null,
									revision:int = 0,
									item:SiteItem = null,
									convertRemoteDates:Boolean = false)
    {
		super(convertRemoteDates);
		this.id           = id;
		this.siteItemId   = siteItemId;
		this.text         = text;
		this.link         = link;
		this.fileLocation = fileLocation;
		this.fileName     = fileName;
		this.fileSize     = fileSize;
		this.fileContent  = fileContent;
		this.fileType 	  = fileType;
		this.revision     = revision;
		
		if (item != null)
			this.item = item;
	} 
	
	//--------------------------------------------------------------------------
	//
	// Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  clone
	//----------------------------------
	
	[Transient]
	/**
	 * @inheritDoc
	 */
	public function get clone():SiteItemContent
	{
		var clone:SiteItemContent =  new SiteItemContent(id, siteItemId, text, 
			link, fileLocation, fileName, fileSize, fileType, fileContent, 
			revision);
		
		if (item != null)
			clone.item = SiteItem(item.noContentClone);
		
		return clone;
	}
	
	//----------------------------------
	//  copy
	//----------------------------------
	
	[Transient]
	/**
	 * @inheritDoc
	 */
	public function get copy():SiteItemContent
	{
		//Copies always have zero for id and they always clone the 
		//site item so that when they store, they are linked to it
		//as a new revision.
		
		var copy:SiteItemContent = SiteItemContent(clone);
		copy.id = 0;
		
		return copy;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Internal properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  noItemClone
	//----------------------------------
	
	[Transient]
	/**
	 * This internal method prevents stack overflow on cloning the 
	 * reciprocal content item.
	 */
	app_internal function get noItemClone():SiteItemContent
	{
		return  new SiteItemContent(id, siteItemId, text, link, 
			fileLocation, fileName, fileSize, fileType, fileContent, revision);
	}
	
	//----------------------------------
	//  noItemCopy
	//----------------------------------
	
	[Transient]
	/**
	 * This internal method prevents stack overflow on copying the 
	 * reciprocal item.
	 */
	app_internal function get noItemCopy():SiteItemContent
	{
		//Copies always have zero for id and they always clone the 
		//site item so that when they store, they are linked to it
		//as a new revision.
		
		var copy:SiteItemContent = noItemClone;
		copy.id = 0;
		
		return copy;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Remote properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  id
	//----------------------------------
	
	/**
	 * The id.
	 */
	public var id:int;
	
	//----------------------------------
	//  siteItemId
	//----------------------------------
	
	/**
	 * The related site item id. This field is used on the server to 
	 * keep track of versions related to a particular site item so that
	 * new contents are correctly versioned.
	 */
	public var siteItemId:int;
	
	//----------------------------------
	//  text
	//----------------------------------
	
	/**
	 * The text content.
	 */
	public var text:String;
	
	//----------------------------------
	//  link
	//----------------------------------
	
	/**
	 * The link specified in the content.
	 */
	public var link:String;
	
	//----------------------------------
	//  fileLocation
	//----------------------------------
	
	/**
	 * The location of a file, if stored in a directory on the server.
	 */
	public var fileLocation:String;
	
	//----------------------------------
	//  fileName
	//----------------------------------
	
	/**
	 * The name of a file, if uploaded to the server.
	 */
	public var fileName:String;
	
	//----------------------------------
	//  fileType
	//----------------------------------
	
	/**
	 * The type of a file, if uploaded to the server.
	 */
	public var fileType:String;
	
	//----------------------------------
	//  fileSize
	//----------------------------------
	
	/**
	 * The size of a file, if uploaded to the server.
	 */
	public var fileSize:int;
	
	//----------------------------------
	//  fileContent
	//----------------------------------
	
	/**
	 * The content of a file, if uploaded to the server and stored in
	 * the database.
	 */
	public var fileContent:ByteArray;
	
	//----------------------------------
	//  revision
	//----------------------------------
	
	[Transient]
	/**
	 * The revision number of the content.
	 * 
	 * @private
	 * Transient since this is always updated on a save.
	 * 
	 */
	public var revision:int;
	
	//----------------------------------
	//  item
	//----------------------------------
	
	/**
	 * The item associated with the content. The item is used to return
	 * a new item after content is loaded.
	 */
	private var _item:SiteItem;
	
	[Transient]
	public function get item():SiteItem
	{
		return _item;
	}
	
	public function set item(value:SiteItem):void
	{
		if (value == _item || this.className == 'SiteItemContentOnly')
			return;
		
		_item = value;
		
		//Keep the site item in sync
		if (_item != null && _item != value)
		{
			_item.content = SiteItemContent(this);
			if (_item.id != 0)
				siteItemId = _item.id;
			
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//    Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	public function isEqual(value:Object):Boolean
	{
		if ( isEqualContent(value) )
		{
			if (value.item == null && item == null) 
			{
				return true;
				
			} else if (value.item != null) {
				
				return value.item.isEqualNoContent(item);
				
			} else {
				
				return false;
			}
		}
		return false;
	}
	
	/**
	 * Checks equality of the content, but not its item. Prevents stack
	 * overflow on reciprocal item isEqual call.
	 */
	public function isEqualContent(value:Object):Boolean
	{
		if (value is SiteItemContent)
		{
			var isEqual:Boolean = value.id == id &&
								  value.siteItemId == siteItemId &&
								  value.text == text &&
								  value.fileLocation == fileLocation &&
								  value.fileName == fileName &&
								  value.fileType == fileType &&
								  value.fileSize == fileSize &&
								  value.fileContent == fileContent &&
								  value.revision == revision;
			return isEqual;
		}
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Memento methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Restores properties using the memento's property map passed to it 
	 * from the memento. Return true if the property was remapped. Return 
	 * false to use the mementos internal restore for simple classes.Use the 
	 * namespace memento_internal in the function declaration.
	 */
	memento_internal function restoreProperties(propertyMap:Object):Boolean
	{
		id 	         = propertyMap.id; 
		siteItemId   = propertyMap.siteItemId; 
		text		 = propertyMap.text; 
		link         = propertyMap.link; 
		fileLocation = propertyMap.fileLocation; 
		fileName	 = propertyMap.fileName; 
		fileSize     = propertyMap.fileSize; 
		fileType     = propertyMap.fileType; 
		fileContent  = propertyMap.fileContent
		revision     = propertyMap.revision;

		return true;
	}
}

}
