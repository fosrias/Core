////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos.interfaces
{
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.utils.DateUtils;

[Bindable]
/**
 * The ATimestamp class is the base class for all remote classes the include
 * timestamps.
 */
public class ATimestamp extends AClass
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
	public function ATimestamp(convertRemoteDates:Boolean = false)
	{
		super(this);
		_convertRemoteDates = convertRemoteDates;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  convertRemoteDates
	//----------------------------------
	
	/**
	 * @private 
	 */
	protected var _convertRemoteDates:Boolean;
	
	[Transient]
	/**
	 * Whether the dates are converted to remote dates or not.
	 */
	public function get convertRemoteDates():Boolean
	{
		return _convertRemoteDates;
	}
	
	//----------------------------------
	//  createdAt
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the createdAt property.
	 */
	private var _createdAt:Date;
	
	/**
	 * The date the list item was created. 
	 */
	public function get createdAt():Date
	{
		return _createdAt;
	}
	
	/**
	 * @private
	 */
	public function set createdAt(value:Date):void
	{
		if (_convertRemoteDates)
		{
			_createdAt = DateUtils.adjustFromRemoteTimeZone(value);
		} else {
			_createdAt = value;
		}
	}
	
	//----------------------------------
	//  updatedAt
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the updatedAt property.
	 */
	private var _updatedAt:Date;
	
	/**
	 * The date the list item was last modified. 
	 */
	public function get updatedAt():Date
	{
		return _updatedAt;
	}
	
	/**
	 * @private
	 */
	public function set updatedAt(value:Date):void
	{
		if (_convertRemoteDates)
		{
			_updatedAt = DateUtils.adjustFromRemoteTimeZone(value);
		} else {
			_updatedAt = value;
		}
	}	
}
	
}