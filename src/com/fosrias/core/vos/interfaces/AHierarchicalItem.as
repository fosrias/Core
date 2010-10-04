////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos.interfaces
{
import com.fosrias.core.utils.ArrayUtils;
import com.fosrias.core.utils.ComparisonUtils;

import mx.collections.ArrayCollection;
import mx.events.PropertyChangeEvent;
	
/**
 * The AHierarchicalItem class is the abstract base class for any list
 * items in a <code>HierarchicalDataItem</code> object. It dynamically
 * adds children as needed.
 */
public class AHierarchicalItem extends ANestedListItem
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
	public function AHierarchicalItem(value:ANestedListItem)
	{
		_source = value;
		
		_source.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, 
			sourceChanged);

		super(value.id, value.parentId, value.sortOrder, value.type, value.name, 
			value.description, value.lft, value.rgt, value.convertRemoteDates);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  children
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the children property
	 */
	private var _children:ArrayCollection;
	
	/**
	 * The children of the item, if any. Override this with a [Transient]
	 * tag if the item is local only.
	 */
	public function get children():ArrayCollection
	{
		return _children;
	}
	
	/**
	 * @private
	 */
	public function set children(value:ArrayCollection):void
	{
		_children = value;
	}
	
	//----------------------------------
	//  childrenLength
	//----------------------------------
	
	[Transient]
	/**
	 * The length of the children collection.
	 */
	public function get childrenLength():int 
	{
		if (children != null)
		{
			return children.length;
		}
		
		return 0;
	}
	
	//----------------------------------
	//  hasBranches
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item has branches for children. Can only be true for
	 * branch item instances.
	 */
	override public function get hasBranches():Boolean 
	{
		var hasBranches:Boolean = isBranch;
		
		if(isBranch && children != null)
		{
			for each (var item:AListItem in children)
		    {
				if(item.isBranch)
					return true;
			}
		}
		return false;
	}
	
	//----------------------------------
	//  hasChildren
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item has any children or not. This will only be true 
	 * for a branch item.
	 */
	public function get hasChildren():Boolean
	{
		return isBranch && childrenLength > 0;
	}
	
	//----------------------------------
	//  hasDisclosureIcon
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item has disclosure item or not in a tree. Override this 
	 * in subclasses to specify this value.
	 */
	override public function get hasDisclosureIcon():Boolean 
	{
		return _source.hasDisclosureIcon && hasBranches;
	}
	
	//----------------------------------
	//  isBranch
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item has any children or not. This will only be true 
	 * for a branch item.
	 */
	override public function get isBranch():Boolean
	{
		return _source.isBranch;
	}
	
	//----------------------------------
	//  label
	//----------------------------------
	
	/**
	 * The label of the item. The default is the source name.
	 */
	public function get label():String
	{
		return _source.name;
	}
	
	//----------------------------------
	//  source
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the source property.
	 */
	private var _source:ANestedListItem;
	
	/**
	 * The source of the item.
	 */
	public function get source():ANestedListItem
	{
		return _source;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  parentId
	//----------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function get parentId():int
	{
		return _source.parentId;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Adds a child item to the item.
	 */
	public function addChild(value:AHierarchicalItem):void
	{
		if (isBranch && children == null)
			children = new ArrayCollection;
		
		children.addItem(value);
	}
	
	/**
	 * Adds a child item to the item at the indicated location.
	 */
	public function addChildAt(value:AHierarchicalItem, index:int):void
	{
		if (isBranch && children == null)
			children = new ArrayCollection;
		
		children.addItemAt(value, index);
	}
	
	/**
	 * The first child, if any.
	 */
	public function firstChild():AHierarchicalItem
	{
		if (isBranch && children != null)
		{
			return AHierarchicalItem( children.getItemAt(0) );
		} else {
			return null;
		}
	}
	
	/**
	 * Adds a child item to the item at the indicated location.
	 */
	public function getChildAt(index:int, prefetch:int = 0):Object
	{
		if (isBranch && children != null)
		{
			return children.getItemAt(index, prefetch);
		} else {
			return null;
		}
	}
	
	/**
	 * The last child, if any.
	 */
	public function lastChild():AHierarchicalItem
	{
		if (isBranch && children != null)
		{
			return AHierarchicalItem( children.getItemAt(childrenLength - 1) );
		} else {
			return null;
		}
	}
	
	/**
	 * Adds a child item to the item at the indicated location.
	 */
	public function removeChildAt(index:int):void
	{
		if (isBranch && children != null)
			children.removeItemAt(index);
	}
	
	/**
	 * Adds a child item to the item at the indicated location.
	 */
	public function setChildAt(value:AHierarchicalItem, index:int):Object
	{
		if (isBranch && children == null)
			children = new ArrayCollection; 
		
		return children.setItemAt(value, index);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function iconFunction(...args):Class
	{
		return _source.iconFunction.apply(null, args);
	}
	
	/**
	 * Whether the item is equal to the test item or not. Implements the 
	 * <code>IIsEqual</code> interface.
	 */
	override public function isEqual(value:Object):Boolean
	{
		if ( value is AHierarchicalItem && super.isEqual(value) )
		{
			if (value.children != null && children != null)
			{
				var isEqual:Boolean = 
					ComparisonUtils.isEqualArrayCollection(value.children, 
						children);
				
				return isEqual;
				
			} else if (value.children == null && children == null) {
				
				return true;
				
			} else {
				
				return false;
			}
		}
		return false;
	}
	
	private function sourceChanged(event:PropertyChangeEvent):void
	{
		//Rebroadcast the change
		if ( hasOwnProperty(event.property) )
		{
			this[event.property] = event.newValue;
		}
	}
}
	
}