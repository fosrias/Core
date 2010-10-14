////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.vos.interfaces
{

[Bindable]
public class ANestedListItem extends AListItem
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function ANestedListItem(id:int=0, 
									parentId:int=0, 
									type:String=null, 
									name:String=null, 
									description:String=null,
									lft:int = 0,
									rgt:int = 0,
									isLocked:Boolean = false,
									isSystem:Boolean = false,
									convertRemoteDates:Boolean=false)
	{
		super(id, type, name, description, isLocked, isSystem, 
			convertRemoteDates);
		this.parentId = parentId;
		this.lft = lft;
		this.rgt = rgt;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  lft
	//----------------------------------
	
	/**
	 * The left nested list value.
	 */
	public var lft:int;
	
	//----------------------------------
	//  rgt
	//----------------------------------
	
	/**
	 * The right nested list value.
	 */
	public var rgt:int;
	
	//----------------------------------
	//  parentId
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the parentId property
	 */
	private var _parentId:int;
	
	/**
	 * The parent id of a child list item.
	 */
	public function get parentId():int
	{
		return _parentId;
	}
	
	/**
	 * @private
	 */
	public function set parentId(value:int):void
	{
		_parentId = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Whether the item is equal to the test item or not. Implements the 
	 * <code>IIsEqual</code> interface.
	 */
	override public function isEqual(value:Object):Boolean
	{
		if ( value is ANestedListItem && super.isEqual(value) )
		{
			var isEqual:Boolean = value.parentId == parentId &&
								  value.lft == lft &&
								  value.rgt == rgt;
			return isEqual;
		}
		return false;
	}
}
	
}