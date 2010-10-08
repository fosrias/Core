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
import com.fosrias.core.models.interfaces.IMementoHost;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.namespaces.memento_internal;
import com.fosrias.site.vos.interfaces.AListItem;
import com.fosrias.site.vos.interfaces.ANestedListItem;

import flash.errors.IllegalOperationError;

import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.elements.TextFlow;

import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
	
use namespace app_internal;
use namespace memento_internal;

[RemoteClass(alias="CMService.com.fosrias.cm.components.physical.SiteItem")]
[Bindable]
/**
 * The SiteItem class ...
 */
public class SiteItem extends ANestedListItem
	                  implements IIsEqual, IMementoHost
{   
	//--------------------------------------------------------------------------
	//
	//    Constants
	//
	//--------------------------------------------------------------------------
			  
	public static const ARCHIVE:String = "ARCHIVE";
	public static const CONTACT:String = "CONTACT";
	public static const CUSTOM:String = "CUSTOM";
	public static const FAQ:String = "FAQ";
	public static const FILE:String = "FILE";
	public static const HOME:String = "HOME";
	public static const LIST:String = "LIST";
	public static const MENU:String = "MENU";
	public static const POST:String = "POST";
	public static const SEARCH:String = "SEARCH";
	public static const SITE:String = "SITE";
	public static const TEXT:String = "TEXT";
	public static const URL_LINK:String = "URL_LINK";
	
	public static const NO_MENU_SEPARATOR:String     = "NONE";
	public static const BEFORE_MENU_SEPARATOR:String = "BEFORE";
	public static const AFTER_MENU_SEPARATOR:String  = "AFTER";
	
	[Embed(source="/assets/images/page.png")]
	private static const PAGE_ICON:Class;
	
	[Embed(source="/assets/images/pageHolder.png")]
	private static const PAGE_HOLDER_ICON:Class;
	
	[Embed(source="/assets/images/site.png")]
	private static const SITE_ICON:Class;
	
	//--------------------------------------------------------------------------
	//
	//    Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected static var _masterSiteItemDomain:String;
	
	/**
	 * @private
	 */
	protected static var _masterSiteItemId:int;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function SiteItem(id:int = 0,
							 parentId:int = 0,
							 sortOrder:int = 0,
							 type:String = null,
							 name:String = "New Item",
							 description:String = "",
							 contentId:int = 0,
							 isMenuItem:Boolean = false,
							 menuSeparator:String = null,
							 urlFragment:String = "",
							 browserTitle:String = "",
							 tags:String = "",
							 isActive:Boolean = false,
							 lft:int = 0,
							 rgt:int = 0,
							 content:SiteItemContent = null)
    {
		//Unless set, the master side id is the parent.
		if (parentId == 0 && type != SITE)
		{   
			parentId = _masterSiteItemId;
		} else if (type != SITE) {
			this.parentId = parentId;
		}
		
		//Set the default type
		if (type == null || type == "")
		{
			if (_masterSiteItemId == 0)
			{
				type = SITE;
				
				//The site is always active
				isActive = true;
			} else {
				type = TEXT;
			}
		}
		
		//Set the default menu separator
		if (menuSeparator == null)
		{
			this.menuSeparator = NO_MENU_SEPARATOR;
		} else {
			this.menuSeparator = menuSeparator;
		}
		
		//Call super now since we had to pre-initialize values
		super(id, parentId, sortOrder, type, name, description, lft, 
			rgt, false);
		
		//ContentId is linked
		if (content == null)
		{
			this.content = new SiteItemContent;
			
		} else {
			
			this.content = content;
		}
		this.contentId = contentId;
		this.isMenuItem = isMenuItem;
		this.urlFragment = urlFragment;
		this.browserTitle = browserTitle;
		this.tags = tags;
		this.isActive = isActive;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  clone
	//----------------------------------
	
	[Transient]
	/**
	 * @inheritDoc
	 */
	public function get cloneContentCopy():AListItem
	{
		var clone:SiteItem = new SiteItem( id, parentId, sortOrder, 
			type, name, description, contentId, isMenuItem, menuSeparator, 
			urlFragment, browserTitle, tags, isActive, lft, rgt);
		
		if (content != null)
			clone.content = content.noItemCopy;
		
		clone.isDeleted = isDeleted;
		
		return clone;
	}
	
	//----------------------------------
	//  hasLoadedContent
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item content is loaded or not.
	 */
	public function get hasLoadedContent():Boolean
	{
		return contentId == content.id;
	}
	
	//----------------------------------
	//  hasSubmenus
	//----------------------------------
	
	[Bindable("typeChange")]
	[Transient]
	/**
	 * Whether the item is a menu that should show submenus or not.
	 */
	public function get hasSubmenus():Boolean
	{
		return type == MENU && isMenuItem;
	}
	
	//----------------------------------
	//  hasURL
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item has a URL to be access by.
	 */
	public function get hasURL():Boolean
	{
		return urlFragment != "" || type == HOME;
	}
	
	//----------------------------------
	//  isHome
	//----------------------------------
	
	[Transient]
	[Bindable("typeChange")]
	/**
	 * Whether the item is the home page or not.
	 */
	public function get isHome():Boolean
	{
		return type == HOME;
	}
	
	//----------------------------------
	//  isMaster
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item is the site master or not.
	 */
	public function get isMaster():Boolean
	{
		return id == _masterSiteItemId;
	}
	
	//----------------------------------
	//  isMenu
	//----------------------------------
	
	[Bindable("typeChange")]
	[Transient]
	/**
	 * Whether the item is a menu or not.
	 */
	public function get isMenu():Boolean
	{
		return type == MENU;
	}
	
	//----------------------------------
	//  isText
	//----------------------------------
	
	[Bindable("typeChange")]
	[Transient]
	/**
	 * Whether the item is a text item or not.
	 */
	public function get isText():Boolean
	{
		return type == TEXT;
	}
	
	//----------------------------------
	//  memento
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item is the site master or not. 
	 * @ private
	 * Implements the IMementoRestore interface.
	 */
	public function get memento():IMemento
	{
		return new Memento(this);
	}
	
	//----------------------------------
	//  textFlow
	//----------------------------------
	
	[Transient]
	/**
	 * The text formated as a text flow for insertion into <code>TextArea</code>
	 * instances.
	 */
	public function get textFlow():TextFlow
	{
		return TextConverter.importToFlow(content.text, 
			TextConverter.TEXT_FIELD_HTML_FORMAT)
	}
	
	//--------------------------------------------------------------------------
	//
	//  Internal properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  noContentClone
	//----------------------------------
	
	[Transient]
	/**
	 * This internal method prevents stack overflow on cloning the 
	 * reciprocal content item.
	 */
	app_internal function get noContentClone():AListItem
	{
		var clone:SiteItem = new SiteItem(id, parentId, sortOrder, 
			type, name, description, contentId, isMenuItem, menuSeparator, 
			urlFragment, browserTitle, tags, isActive, lft, rgt);
		clone.isDeleted = isDeleted;
		
		return clone;
	}
	
	//----------------------------------
	//  itemlessCopy
	//----------------------------------
	
	[Transient]
	/**
	 * This internal method prevents stack overflow on copying the 
	 * reciprocal conent item.
	 */
	app_internal function get noContentCopy():AListItem
	{
		//Copies always have zero for id and false for isActive and isDeleted
		//is always false
		return new SiteItem( 0, parentId, sortOrder, type, name, 
			description, contentId, isMenuItem, menuSeparator, urlFragment,
			browserTitle, tags, false, 0, 0);
	}
	
	//--------------------------------------------------------------------------
	//
	//    Overridden properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  clone
	//----------------------------------
	
	[Transient]
	/**
	 * @inheritDoc
	 */
	override public function get clone():AListItem
	{
		var clone:SiteItem = new SiteItem( id, parentId, sortOrder, 
			type, name, description, contentId, isMenuItem, menuSeparator, 
			urlFragment, browserTitle, tags, isActive,lft, rgt);
		
		if (content != null)
			clone.content = content.noItemClone;
		
		clone.isDeleted = isDeleted;
		
		return clone;
	}
	
	//----------------------------------
	//  copy
	//----------------------------------
	
	[Transient]
	/**
	 * @inheritDoc
	 */
	override public function get copy():AListItem
	{
		//Copies always have zero for id and false for isActive and isDeleted
		//is always false and lft and rgt are zero indicate new
		var copy:SiteItem =  new SiteItem( 0, parentId, sortOrder, type, name, 
			description, contentId, isMenuItem, menuSeparator, urlFragment,
			browserTitle, tags, false, 0, 0, content.noItemCopy);
		
		if (content != null)
			copy.content = content.noItemClone;
		
		return copy;
	}
	
	//----------------------------------
	//  hasDisclosureIcon
	//----------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function get hasDisclosureIcon():Boolean
	{
		return !isMaster;
	}
	
	//----------------------------------
	//  id
	//----------------------------------
	
	/**
	 * @private
	 */
	override public function set id(value:int):void
	{
		super.id = value;
		
		if (type == SITE && id != 0)
		{
			setAsMaster();
			dispatchEventType("typeChange");
		}
	}

	//----------------------------------
	//  isBranch
	//----------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function get isBranch():Boolean
	{
		return true;
	}
	
	//----------------------------------
	//  parentId
	//----------------------------------
	
	[Bindable("typeChange")]
	/**
	 * The parent id of a child list item.
	 * @private
	 * The home item always has the site as the parent item and 
	 * the site item never has a parent id.
	 */
	override public function get parentId():int
	{
		return !isHome ? super.parentId : _masterSiteItemId;
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @private 
	 */
	override public function set type(value:String):void
	{
		super.type = value;
		
		//Home page is always a child of the site
		if (type == HOME)
		{
			urlFragment = "";
			browserTitle = "";
		}
		
		//Site always has no parent
		if (value == SITE)
		{
			parentId = 0;
			if (id != 0)
				setAsMaster();
		}
		
		dispatchEventType("typeChange");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Remote properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  contentId
	//----------------------------------
	
	/**
	 * @private 
	 */
	public var contentId:int;
	
	//----------------------------------
	//  menuSeparator
	//----------------------------------
	
	/**
	 * The menu separator code.
	 */
	public var menuSeparator:String;
	
	//----------------------------------
	//  isActive
	//----------------------------------
	
	/**
	 * The menu separator code.
	 */
	public var isActive:Boolean;
	
	//----------------------------------
	//  isMenuItem
	//----------------------------------
	
	/**
	 * Whether the the item is show in the menu bar.
	 */
	public var isMenuItem:Boolean;
	
	//----------------------------------
	//  urlFragment
	//----------------------------------
	
	/**
	 * The end fragment of the url associated with the item. Setting this
	 * value makes the item accessible from the browser url regardless of 
	 * whether it is in the menu or not.
	 */
	public var urlFragment:String;
	
	//----------------------------------
	//  browserTitle
	//----------------------------------
	
	/**
	 * The title that will show up on the browser.
	 */
	public var browserTitle:String;
	
	//----------------------------------
	//  tags
	//----------------------------------
	
	/**
	 * The tags for wrapper injection.
	 */
	public var tags:String;
	
	//----------------------------------
	//  content
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the content property
	 */
	private var _content:SiteItemContent;
	
	/**
	 * The current content.
	 */
	public function get content():SiteItemContent
	{
		return _content;
	}

	/**
	 * @private
	 */
	public function set content(value:SiteItemContent):void
	{
		if (_content == value || value == null)
			return;
		
		_content = value;
		
		//Maintains reciprocal relationship
		if (_content != null)
		{
			_content.item = this;
			
			if (_content.id != 0 && _content.id != contentId)
			{
				//TESTING Commented out for debugging
				//throw new IllegalOperationError("Site Item Error: Content id is" +
				//	"out of sync with the item.");
			}
		}
	}
	
	//----------------------------------
	//  isDeleted
	//----------------------------------
	
	/**
	 * Whether the item has been deleted from the site. 
	 * @private
	 * This content is not removed from the database, but only flagged 
	 * not to load.
	 */
	public var isDeleted:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//    Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 * @ private
	 * Implements the IMementoRestore interface.
	 */
	public function restore(memento:IMemento):*
	{
		memento.restore(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMementoRestore methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Maps the current properties of the object for storage in a memento. 
	 * This method should return a static map of the object. For simple objects
	 * that do not compose custom classes, return null from this function 
	 * and the memento will map itself. Use the namespace memento_internal
	 * in the function declaration.
	 */
	memento_internal function mapProperties():*
	{
		//We use a clone as the map since it is easier.
		return clone;
	}
		
	/**
	 * Hook that allows exception handling with default property mapping.
	 * If there are no exceptions, this function must return the value
	 * argument.Use the namespace memento_internal in the function declaration.
	 */
	memento_internal function propertyMapExceptions(property:String, 
										  value:Object,
										  isRestore:Boolean = false):Object
	{
		//Not using default.
		return value;
	}
		
	/**
	 * Restores properties using the memento's property map passed to it 
	 * from the memento. Return true if the property was remapped. Return 
	 * false to use the mementos internal restore for simple classes.Use the 
	 * namespace memento_internal in the function declaration.
	 */
	memento_internal function restoreProperties(propertyMap:Object):Boolean
	{
		id			  = propertyMap.id;
		contentId     = propertyMap.contentId;
		name          = propertyMap.name;
		description   = propertyMap.description;
		menuSeparator = propertyMap.menuSeparator;
		isActive      = propertyMap.isActive;
		isMenuItem    = propertyMap.isMenuItem;
		urlFragment   = propertyMap.urlFragment;
		browserTitle  = propertyMap.browserTitle;
		tags          = propertyMap.tags;
		parentId      = propertyMap.parentId; //Must be before lft and rgt
		type          = propertyMap.type;
		sortOrder     = propertyMap.sortOrder;
		lft           = propertyMap.lft;
		rgt           = propertyMap.rgt; //Must be after lft
		createdAt     = propertyMap.createdAt;
		updatedAt     = propertyMap.updatedAt;
		
		return content.restoreProperties(propertyMap.content);
	}
	
	/**
	 * Used by a memento to determine if its state is equal to an objects
	 * state. If you are using the default property mapping, return the value
	 * of the mementoIsEqualFunction. Otherwise, return true if the propertyMap 
	 * state is equal to the state of the object (this). Use the namespace 
	 * memento_internal in the function declaration.
	 */
	memento_internal function stateIsEqual(propertyMap:Object,
						  				   mementoIsEqual:Function):Boolean
	{
		return isEqual(propertyMap);
	}

	//--------------------------------------------------------------------------
	//
	//    Internal methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Checks equality of the item, but not its contents. Prevents stack
	 * overflow on reciprocal content isEqual call.
	 */
	app_internal function isEqualNoContent(value:Object):Boolean
	{
		if ( value is SiteItem && super.isEqual(value) )
		{
			var isEqual:Boolean = value.contentId == contentId &&
							      value.isMenuItem == isMenuItem &&
								  value.menuSeparator == menuSeparator &&
								  value.urlFragment == urlFragment &&
								  value.browserTitle == browserTitle &&
								  value.tags == tags &&
								  value.isActive == isActive;
			return isEqual;
		}
		return false;
	}
	
	/**
	 * @private
	 * Sets the master site domain and id class variables so that constructor 
	 * defaults to it as the parentId.
	 */
	app_internal function setAsMaster():void
	{
		if (id != 0)
		{
			_masterSiteItemDomain = urlFragment;
			_masterSiteItemId = id;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//    Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 * @ private
	 * Implements the IIsEqual interface.
	 */
	override public function isEqual(value:Object):Boolean
	{
		if ( isEqualNoContent(value) )
		{
			if (value.content == null && content == null)
			{
				return true;
				
			} else if (value.content != null) {
				
				return value.content.isEqualContent(content);
				
			} else {
				
				return false;
			}
			return isEqual;
		}
		return false;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function iconFunction(...args):Class
	{
		switch (type)
		{
			case SITE:
			{
				return SITE_ICON;
			}
			default:
				return PAGE_ICON;
		}
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Static methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Utility method to create the default Home Page Item
	 */
	public static function createHomePage():SiteItem
	{
		var item:SiteItem = new SiteItem(0, _masterSiteItemId, 1, SiteItem.HOME,
    		"Home", "[The home page does not have a Item URL or a Browser " + 
			" Title as they default to the site settings. Replace all this " +
			"text.]", 0, true, null, "", "", "", true, 2, 3);
		item.content.text = "Home Page";
		return item;
	}
	
	/**
	 * Utility method to create the a new Text Page Item
	 */
	public static function createPage(parentId:int, parentlft:int):SiteItem
	{
		var item:SiteItem = new SiteItem(0, parentId, 1, SiteItem.TEXT,
			"New Item", "", 0, true, null, "", "", "", true, parentlft + 1, 
			parentlft + 2);
		return item;
	}
	
	/**
	 * Filter for parent lists.
	 */
	public static function parentItemFilter(item:SiteItem):Boolean
	{
		return item.hasURL;
	}
	
	/**
	 * Filter for parent lists.
	 */
	public static function parentItemLabelFunction(item:SiteItem):String
	{
		return item.name + ": " + item.urlFragment;
	}
	
	/**
	 * Filter for parent lists.
	 */
	public static function gridLabelFunction(item:SiteItem,
											 column:DataGridColumn):String
	{
		return item.urlFragment + ": " + item.name;
	}
}

}
