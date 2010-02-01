////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.namespaces
{

/**
 * The app_internal namespace is used on all methods and that modify model
 * objects. These methods should only be called by "friends", 
 * for example managers and their states.
 */
public namespace app_internal = "http://www.fosrias.com/internal";

}