////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.components
{
import mx.collections.IList;
import mx.controls.ComboBox;

import spark.components.ComboBox;

/**
 * The AdvancedSparkComboBox class is a combo box extended to allow mapping 
 * of selectedItem data fields to fields in the data provider if 
 * the mapping fields are set. Otherwise, it functions as a normal 
 * combo box.
 */
public class AdvancedSparkComboBox extends spark.components.ComboBox
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AdvancedSparkComboBox()
	{
	   super();
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     * @private 
     */
    private var _selectedData:Object;
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  itemField
    //----------------------------------
    
    /**
     * The field in the <code>selectedItem</code> that maps to the 
     * <code>dataProviderField</code> in the <code>dataProvider</code>.
     */
    public var itemField:String = null;
    
    //----------------------------------
    //  dataProviderField
    //----------------------------------
    
    /**
     * The field in the <code>dataProvider</code> items that maps to the 
     * <code>itemField</code> in the <code>selectedItem</code>. If this 
     * field is not set, it defaults to the same value as the label field.
     */
    public var dataProviderField:String = 'label';
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  dataProvider
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    override public function set dataProvider(value:IList):void
    {
    	super.dataProvider = value;
        
        //If data has been set, update based on new dataProvider
        selectedItem = _selectedData; 
    }

    //----------------------------------
    //  selectedItem
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    override public function set selectedItem(value:*):void
    {
    	_selectedData = value;
    	if ( itemField != null && dataProviderField != null 
    	   && dataProvider != null && value != null && 
		   value.hasOwnProperty( itemField ) )
    	{
            for each (var dp:Object in dataProvider) 
            {
                if ( dp[dataProviderField] == value[itemField] ) 
                {
                    super.selectedItem = dp;
                    return;     
                }
               
            }    
            super.selectedItem = null;               
    	} else {
    		super.selectedItem = value;
    	}
    }
}

}