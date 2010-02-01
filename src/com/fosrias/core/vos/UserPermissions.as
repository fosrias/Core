////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.vos
{

[RemoteClass(alias="com.fosrias.vos.UserPermissions")]	
/**
 * The UserPermissions class is a value object that references 
 * user permissions for users.
 */
public class UserPermissions
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function UserPermissions()
	{
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  code
    //----------------------------------
    
    /**
     * The code of the message. 
     */
    public var code:String;
}

}