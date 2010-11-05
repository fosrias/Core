////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos
{
import com.fosrias.core.models.interfaces.IIsEqual;

[RemoteClass(alias="CFCore.com.fosrias.site.components.physical.UserRole")]
/**
 * The UserRole class is a value object for user roles.
 */
public class UserRole implements IIsEqual
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function UserRole() {}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  authorizableId
	//----------------------------------
	
	/**
	 * The id of the role
	 */
	public var authorizableId:int;
	
	//----------------------------------
	//  authorizableType
	//----------------------------------
	
	/**
	 * The type of the role.
	 */
	public var authorizableType:String;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The name of the role.
	 */
	public var name:String;
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public var description:String;
	
	//----------------------------------
	//  label
	//----------------------------------
	
	/**
	 * The label for the role when used in a list.
	 */
	public function get label():String
	{
		return name;
	}
	
	//----------------------------------
	//  toolTip
	//----------------------------------
	
	/**
	 * The toolTip for the role
	 */
	public function get toolTip():String
	{
		return description;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 * @ private
	 * Implements the IIsEqual interface.
	 */
	public function isEqual(value:Object):Boolean
	{
		if (value is UserRole)
		{
			return value.name == name;
		}
		return false;
	}
}
	
}