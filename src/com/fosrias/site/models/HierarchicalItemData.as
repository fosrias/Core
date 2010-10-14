////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.models
{
import com.fosrias.site.vos.HierarchicalItemWrapper;
import com.fosrias.site.vos.interfaces.AHierarchicalItem;
import com.fosrias.site.vos.interfaces.AListItem;
import com.fosrias.site.vos.interfaces.ANestedListItem;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.utils.Dictionary;

import mx.charts.renderers.DiamondItemRenderer;
import mx.collections.ArrayCollection;
import mx.collections.HierarchicalCollectionView;
import mx.collections.HierarchicalData;
import mx.collections.IHierarchicalCollectionView;
import mx.collections.errors.CollectionViewError;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;

[Bindable]
/**
 * The HierarchicalItemData class is hierarchical data that uses a flat
 * nested listed of ANestedList items for its source.
 */
public class HierarchicalItemData extends HierarchicalData
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
	public function HierarchicalItemData(value:Object=null, 
										 wrapper:Class=null)
	{
		if (wrapper == null)
		{
			_wrapperClass = HierarchicalItemWrapper;
		} else {
			_wrapperClass = wrapper;
		}
		super(value);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _isRelocatingItem:Boolean = false;
	
	/**
	 * @private
	 */
	private var _itemMap:Dictionary = new Dictionary;
	
	/**
	 * @private
	 */
	private var _itemIdMap:Dictionary = new Dictionary;
	
	/**
	 * @private
	 */
	private var _selectedHierarchicalItem:AHierarchicalItem;
	
	/**
	 * @private
	 */
	private var _selectedListItem:ANestedListItem;
	
	/**
	 * @private
	 * REFACTOR Using getItem on child array collections
	 */
	private var _selectedListItemChildIndex:int;
	
	/**
	 * @private
	 */
	private var _selectedParent:AHierarchicalItem;
	
	
	/**
	 * @private
	 */
	private var _wrapperClass:Class = HierarchicalItemWrapper;

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  itemDownEnabled
	//----------------------------------
	
	[Bindable("selectedIndexChange")]
	public function get itemDownEnabled():Boolean
	{
		if (_selectedParent == null)
		{
			return false;
		} else {
			return _selectedListItemChildIndex < 
				_selectedParent.childrenLength - 1;
		}
	}

	//----------------------------------
	//  itemIsDeletable
	//----------------------------------
	
	[Bindable("itemChange")]
	public function get itemIsDeletable():Boolean
	{
		if (selectedItem != null)
		{
			return !selectedItem.hasChildren;
		}
		return true;
	}
	
	//----------------------------------
	//  itemUpEnabled
	//----------------------------------
	
	[Bindable("selectedIndexChange")]
	public function get itemUpEnabled():Boolean
	{
		return _selectedListItemChildIndex > 0;
	}
	
	//----------------------------------
	//  rootChildren
	//----------------------------------
	
	/**
	 * The children of the top level node
	 */
	public function get rootChildren():ArrayCollection
	{
		if (source != null && source.length > 0)
		{
			return source[0].children;
		}
		return null;
	}
	
	//----------------------------------
	//  selectedItem
	//----------------------------------
	
	
	private var _selectedItem:Object;
	
	[Bindable("itemChange")]
	/**
	 * The currently selected hierarchical item.
	 */
	public function get selectedItem():Object
	{
		return _selectedItem;
	}

	/**
	 * @private
	 */
	public function set selectedItem(value:Object):void
	{
		_selectedItem = value;
		
		dispatchEvent( new Event("itemChange") );
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  source
	//----------------------------------
	
	/**
	 *  The source collection.
	 *  The collection should implement the IList interface 
	 *  to facilitate operation like the addition and removal of items.
	 *
	 *  @see mx.collections.IList
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function get source():Object
	{
		return super.source;
	}
	
	/**
	 *  @private
	 */
	override public function set source(value:Object):void
	{
		//Clear the prior maps
		for (var key:* in _itemMap)
		{
			_itemMap[key] = null;
			delete _itemMap[key];
		}
		for (key in _itemIdMap)
		{
			_itemIdMap[key] = null;
			delete _itemIdMap[key];
		}
		
		super.source = createHierarchy(value);
		
		//Reset it if it is set.
		updateListItem(_selectedListItem);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns an item source based on its id;
	 */
	public function findItemById(value:int):AListItem
	{
		var item:AHierarchicalItem = AHierarchicalItem( _itemIdMap[value] );
		if (item != null)
			return item;
		
		return null;
	}
	
	/**
	 * Returns an item source based on its id;
	 */
	public function findSourceItemById(value:int):AListItem
	{
		var item:AHierarchicalItem = AHierarchicalItem( _itemIdMap[value] );
		if (item != null)
			return item.source;
			
		return null;
	}
	
	/**
	 * Moves the selected item down in its parent item.
	 */
	public function moveDown():void
	{
		move();
	}
	
	/**
	 *  Moves the selected item up in its parent item.
	 */
	public function moveUp():void
	{
		move(-1);
	}
	
	/**
	 *  Resets the selected item.
	 */
	public function resetSelectedItem():void
	{
		var item:Object = _selectedItem;
		selectedItem = null;
		selectedItem = item;
	}
	
	/**
	 *  Updates the parent item on the selected item.
	 */
	public function updateParentItem(value:AHierarchicalItem, 
									 view:IHierarchicalCollectionView):Object
	{
		//No changes. Don't warn if parent is set to the same item. Just
		//ignore.
		if (_selectedItem.id == value.id || _selectedItem.parentId ==  value.id)
			return null;
		
		//Checks if it is valid (not a child of itself)
		var parentIsChild:Boolean = false;
		var parent:AHierarchicalItem = view.getParentItem(value);
		var parentId:int;
		
		if (parent != null)
			parentId = parent.id;
		
		//Crawl up the tree
		while (parent != null)
		{
			if (_selectedItem.id == parentId)
			{
				parentIsChild = true;
				break;
			}
			parent = view.getParentItem(parent);
			
			if (parent != null)
				parentId = parent.id;
		}
		
		if (parentIsChild)
		{
			Alert.show("The new parent is a child of the item. " +
				"Update cancelled.", "Reparenting Error");
			
		} else {
			
			//sets the new selected parent. Gets moved by the itemChange
			//handler in this class
			var isMovingtoGrandParent:Boolean = 
				value.id == _selectedParent.parentId;
			
			_selectedListItem.parentId = value.id;
			
			var lft:int;
			var nestedRange:int = _selectedListItem.rgt - _selectedListItem.lft;

			if (_selectedParent.childrenLength <= 1)
			{
				//Add after the parent
				lft = _selectedParent.lft + 1;
				
			} else {
				
				//Add after the last child, but since this has added itself
				//as the last child, get the previous last child
				var previousSibling:AHierarchicalItem = AHierarchicalItem(
					_selectedParent.getChildAt(
						_selectedParent.childrenLength - 2) );
				
				lft = previousSibling.rgt + 1;
				
				//Need to check if we moved to be the post sibling of the
				//the previous parent since our previous parent rgt will 
				//decrease since moving out of it
				/*if(isMovingtoGrandParent && previousSibling.id == 
					_selectedListItem.parentId)
				{
					lft -= nestedRange + 1;
				}*/
			}
			
			_selectedListItem.lft = lft;
			
			//Set this last to trigger update in itemChange handler
			_selectedListItem.rgt = lft + nestedRange;
		}
		return _selectedParent;
	}
	
	/**
	 * Updates the selected item of the list and watches for changes to
	 * its parentId properties.
	 */
	public function updateListItem(value:ANestedListItem):void
	{
		if (_selectedListItem != null)
		{
			_selectedListItem.removeEventListener(
				PropertyChangeEvent.PROPERTY_CHANGE, itemChange);
			
			if (_selectedListItem.isNew)
				purgeNewSelectedItem();	
		}
		
		_selectedListItem = value;
		
		if (_selectedListItem != null)
		{
			if (_selectedListItem.isNew)
			{
				injectNewSelectedItem();
				
			} else {
				
				registerSelectedItem();
			}
		
			_selectedListItem.addEventListener(
				PropertyChangeEvent.PROPERTY_CHANGE, itemChange);
		}
		
		dispatchEvent( new Event("itemChange") );
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	private function createHierarchy(value:Object):Object
	{
		var workingSource:Array;
		var source:ArrayCollection = new ArrayCollection;
		
		//Use array for slightly better performance. Use a copy so that
		//original source stays intact.
		if (value is Array)
		{
			workingSource = value.slice();
			
		} else if (value is ArrayCollection) {
			
			workingSource = value.source.slice();
		}
		
		//Process through any remaining items. Does not require a 
		//root item, but handles it if it exists.
		while (workingSource.length > 0)
		{
			source.addItem( buildItem(workingSource.shift(), workingSource) );
		}
		
		return source;
	}
	
	private function buildItem(parentItem:ANestedListItem, 
							   source:Array):AHierarchicalItem
	{
		var parentHierarchicalItem:AHierarchicalItem = 
			new _wrapperClass(parentItem);
		
		//map the source item to the hierarchical item
		_itemMap[parentItem] = parentHierarchicalItem;
		_itemIdMap[parentItem.id] = parentHierarchicalItem;
		
		while (source.length > 0)
		{
			var currentItem:ANestedListItem = source[0];
			
			if (currentItem.lft > parentItem.lft && 
				currentItem.rgt < parentItem.rgt)
			{
				
				parentHierarchicalItem.addChild(
					buildItem(source.shift(), source) );
			} else {
				break;
			}
		}
		return parentHierarchicalItem;
	}
	
	/**
	 *  @private
	 */
	private function injectNewSelectedItem():void
	{
		var newHierarchicalItem:AHierarchicalItem = 
			new _wrapperClass(_selectedListItem);
		
		_selectedParent = _itemIdMap[_selectedListItem.parentId];
		
		if (_selectedParent != null)
		{
			//HACK: Set the selected Item here to prevent collectionViewError
			selectedItem = _selectedParent;
			
			//Add at end of child list location initially.
			//REFACTOR. Not DRY see setLocationByNestedIndex
			
			_isRelocatingItem = true;
			
			//Find the correct position under the parent
			var length:int = _selectedParent.childrenLength;
			for (var i:int = 0; i < length; i++)
			{
				if (_selectedParent.children[i].lft + 1 == 
					_selectedListItem.lft || (_selectedListItem.isNew &&
						_selectedParent.children[i].lft == 
						_selectedListItem.lft) )
				{
					break;
				}
			}
			
			//Add back to correct location
			_selectedListItemChildIndex = i;
			_selectedParent.addChildAt( AHierarchicalItem(newHierarchicalItem),
				_selectedListItemChildIndex);
			
			_isRelocatingItem = false;
		}
		
		//Always add after home page
		selectedItem = newHierarchicalItem;
		
		dispatchEvent(new Event("selectedIndexChange") );
	}
	
	/**
	 *  @private
	 */
	private function itemChange(event:PropertyChangeEvent):void
	{
		//Anything that resest parentId must do it before resetting lft and rgt
		if (event.property == 'parentId')
		{
			//Reparent the item
			
			//Flag to block item change listen
			//_isRelocatingItem = true;
			
			//Remove from the current parent
			_selectedParent.removeChildAt(_selectedListItemChildIndex);
			
			
			//Get the new parent
			_selectedParent = _itemIdMap[event.newValue];
			
			//Always add the child at the end of the parent children initially
			//when reparenting
			_selectedListItemChildIndex = _selectedParent.childrenLength;				
			_selectedParent.addChildAt(AHierarchicalItem(_selectedItem), 
				_selectedListItemChildIndex);
			
			//_isRelocatingItem = false;
			
		} else if (event.property == 'rgt' && !_isRelocatingItem) {
			
			//Should only get here on cancel or undo.
			setLocationByNestedIndex();
		}
		
		dispatchEvent( new CollectionEvent(CollectionEvent.COLLECTION_CHANGE) );
		
		//HACK to reset selected item
		var item:Object = _selectedItem;
		selectedItem = null;
		selectedItem = item;
		
		dispatchEvent(new Event("selectedIndexChange") );
	}
	
	/**
	 *  @private
	 */
	private function move(step:int = 1):void
	{
		var length:int = _selectedParent.childrenLength;
		var item:Object = _selectedItem;
		var nestedRange:int = _selectedListItem.rgt - _selectedListItem.lft;
		var left:int;
		
		_isRelocatingItem = true;
		
		var currentChild:AHierarchicalItem = AHierarchicalItem(
			_selectedParent.getChildAt(_selectedListItemChildIndex + step) );
			
		if (step == 1)
		{
			//Find the rgt value of then next child
			left = currentChild.rgt + 1;
		} else {
			//Find the lft value of then previous child
			left = currentChild.lft;
		}
		
		_selectedParent.removeChildAt(_selectedListItemChildIndex);
		
		_selectedListItemChildIndex += step * 1;
		
		_selectedParent.addChildAt(AHierarchicalItem(selectedItem), 
			_selectedListItemChildIndex);
		
		_selectedListItem.lft = left;
		_selectedListItem.rgt = left + nestedRange;
		
		//Reset
		dispatchEvent(new Event("selectedIndexChange") );
		dispatchEvent(new Event("itemChange") );
		selectedItem = null;
		selectedItem = item;
		
		_isRelocatingItem = false;

	}

	/**
	 *  @private
	 */
	private function purgeNewSelectedItem():void
	{
		_itemMap[_selectedListItem] = null;
		delete _itemMap[_selectedListItem];
		
		if (_selectedParent != null)
		{
			_selectedParent.removeChildAt(_selectedListItemChildIndex);
			_selectedParent = null;
		}
	}
	
	/**
	 *  @private
	 */
	private function registerSelectedItem():void
	{
		_selectedParent = _itemIdMap[_selectedListItem.parentId];
		
		//If a parent exists, process its child location.
		if (_selectedParent != null)
		{
			var length:int = _selectedParent.childrenLength;
			
			for (var i:int=0; i < length; i++)
			{
				if (_selectedParent.children[i].source == _selectedListItem)
				{
					break;
				}
			}
			
			if (i == length)
			{
				//Not found, data corrupted
				throw new IllegalOperationError("Item not found as child of " +
					"parent in hierarchical data.");
			}
			
			_selectedListItemChildIndex = i;
		}
		//Sets the selected item in the tree
		selectedItem = _itemMap[_selectedListItem];
		
		dispatchEvent(new Event("selectedIndexChange") );
	}
	
	private function setLocationByNestedIndex():void
	{
		//Flag to block stack flow loop since this method tr
		
		var parentLeft:int = _selectedParent.lft;
		
		if (_selectedListItem.lft == parentLeft + 1 && 
			_selectedListItemChildIndex != 0)
		{
			//Remove from current location
			_selectedParent.removeChildAt(_selectedListItemChildIndex);
			
			//Add back to the first child under the parent
			_selectedListItemChildIndex = 0;	
			_selectedParent.addChildAt(AHierarchicalItem(_selectedItem),
				_selectedListItemChildIndex);
			
		} else if (_selectedListItem.lft != parentLeft + 1 ) {
			
			//Find the correct position under the parent
			var length:int = _selectedParent.childrenLength;
			
			for (var i:int = 0; i < length; i++)
			{
					
				if (_selectedParent.children[i].lft == 
					_selectedListItem.lft)
				{
					break;
				}
			}
			
			if (_selectedListItemChildIndex != i)
			{
				//Remove from current location
				_selectedParent.removeChildAt(_selectedListItemChildIndex);
			
				//Add back to correct location
				_selectedListItemChildIndex = i;
				_selectedParent.addChildAt( AHierarchicalItem(_selectedItem),
					_selectedListItemChildIndex);
			}
		}
	}
}
	
}