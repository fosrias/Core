////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.namespaces
{

/**
 * The memento_internal namespace is used on all objects that
 * implement IMemento and that modify model objects. These methods should 
 * only be called by memento on their stored objects.
 */
public namespace memento_internal = "http://www.fosrias.com/memento_internal";

}