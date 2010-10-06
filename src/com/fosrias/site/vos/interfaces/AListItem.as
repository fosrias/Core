////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.vos.interfaces
{
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.utils.DateUtils;

import mx.collections.ArrayCollection;

import org.osmf.layout.AbsoluteLayoutFacet;
import com.fosrias.core.vos.interfaces.ATimestamp;

/**
 * The AListItem class is the abstract base class for all list item classes.
 * Set the <code>convertRemoteDates</code> parameter to <code>true</code> if
 * the remote service is a Ruby on Rails application so that the dates are
 * correct.
 */
[Bindable]
public class AListItem extends ATimestamp
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
	 */
	public function AListItem(id:int = 0,
							  sortOrder:int = 0,
							  type:String = null,
					          name:String = null,
							  description:String = null,
							  convertRemoteDates:Boolean = false)
    {
        super(convertRemoteDates);
		
        this.id = id;
        this.sortOrder = sortOrder;
		this.type = type;
		this.name = name;
		this.description = description;
		_convertRemoteDates = convertRemoteDates;
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
     * A clone of the instance. Clones include the id.
     */
    public function get clone():AListItem
    {
        return raiseImplementationError("getter", "clone");
    }
    
    //----------------------------------
    //  copy
    //----------------------------------
    
    [Transient]
    /**
     * A copy of the instance. Copies do not include the id so that when
	 * persisted, they are a new record.
     */
    public function get copy():AListItem
    {
        return raiseImplementationError("getter", "copy");
    }
    
    //----------------------------------
    //  hasBranches
    //----------------------------------
    
    [Transient]
    /**
     * Whether the item has branches for children. Can only be true for
     * branch item instances.
     */
    public function get hasBranches():Boolean 
    {
        return false;
    }
    
    //----------------------------------
    //  hasDisclosureIcon
    //----------------------------------
    
    [Transient]
    /**
     * Whether the item has disclosure item or not in a tree. Override this 
	 * in subclasses to specify this value.
     */
    public function get hasDisclosureIcon():Boolean 
    {
        return false;
    }
    
    //----------------------------------
    //  isBranch
    //----------------------------------
    
    [Transient]
    /**
     * Whether the item is a branch item or not. Override this in subclasses
	 * to specify this value.
     */
    public function get isBranch():Boolean
    {
        return false;
    }
    
	//----------------------------------
	//  isNew
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item is new or not.
	 */
	public function get isNew():Boolean 
	{
		return id == 0;
	}
	
	//----------------------------------
    //  toolTip
    //----------------------------------
    
    [Transient]
    /**
     * The tool tip for the item. Overriding this must maintain the [Transient]
	 * tag. Override this in subclasses to change from the default value of
	 * description.
     */
    public function get toolTip():String
    {
        return description;
    }
    
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @private 
	 */
	private var _type:String;
	
	/**
	 * The type of item.
	 * @private
	 * REFACTOR: This field will conflict in menu items where you might want use
	 * a checkbox or radio button since they use the type field.
	 */
	public function get type():String
	{
		return _type;
	}
	
	/**
	 * @private 
	 */
	public function set type(value:String):void
	{
		_type = value;
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
	 * @private
	 * Storage for the id property
	 */
	private var _id:int;

	/**
	 * The id of the list item.
	 */
	public function get id():int
	{
		return _id;
	}

	/**
	 * @private
	 */
	public function set id(value:int):void
	{
		_id = value;
	}

    
    //----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * The name for the list item.
	 */
	public var description:String;

    
    //----------------------------------
    //  name
    //----------------------------------
    
    /**
     * The name for the list item.
     */
    public var name:String;
    
	//----------------------------------
	//  sortOrder
	//----------------------------------
	
	/**
	 * The sort order of the list item.
	 */
	public var sortOrder:int;
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * The icon function associated with the list item.
     */
    public function iconFunction(...args):Class
    {
        return null;
    }
	
	/**
	 * Whether the item is equal to the test item or not. Implements the 
	 * <code>IIsEqual</code> interface.
	 */
	public function isEqual(value:Object):Boolean
	{
		if (value is AListItem)
		{
			var isEqual:Boolean = value.id == id &&
								  value.sortOrder == sortOrder &&
								  value.type == _type &&
								  value.name == name &&
								  value.description == description;
			return isEqual;
		}
		return false;
	}
}

}