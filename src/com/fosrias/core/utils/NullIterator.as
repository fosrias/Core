////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils
{
public class NullIterator extends Iterator
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function NullIterator()
	{
		super([]);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	//----------------------------------
    //  value
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    override public function get value():*
    {
    	return null;
    }
    
    /**
     * @inheritDoc
     */
    override public function set value(value:*):void
    {
    	
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */    
    override public function addItem(value:Object):void
    {
    	
    }
    
    /**
     * @inheritDoc
     */    
    override public function addItemAt(value:Object, index:int):void
    {
        
    }
    
    /**
     * @inheritDoc
     */    
    override public function next():*
    {
    	return null;
    }
    
    /**
     * @inheritDoc
     */    
    override public function previous():*
    {
        return null;
    }   
}

}