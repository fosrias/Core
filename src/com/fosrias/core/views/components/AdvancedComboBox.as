////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009-2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.components
{
import mx.controls.ComboBox;

/**
 * The AdvancedComboBox class is a combo box extended to allow mapping 
 * of selectedItem data fields to fields in the data provider if 
 * the mapping fields are set. Otherwise, it functions as a normal 
 * combo box. The AdvancedComboBox can be used as an inline itemEditor in 
 * a DataGrid or AdvancedDataGrid as well.
 */
public class AdvancedComboBox extends ComboBox
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AdvancedComboBox()
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
    //  data
    //----------------------------------
    
    /**
     * @private
     */
    override public function set data(value:Object):void 
    {
        selectedItem = value;
        super.data = value;
    }
    
    //----------------------------------
    //  editorData
    //----------------------------------
	
	[Inspectable(category="Data")]
    /**
     * The editorData is the field in the dataProvider specified by the 
     * <code>dataProviderField</code>.
     */
    public function get editorData():*
    {
        if (selectedItem != null)
        {
            return selectedItem[dataProviderField];
        } else {
            return data[itemField];
        }
    }
        
    //----------------------------------
    //  itemField
    //----------------------------------
    
	[Inspectable(category="Data")]
	/**
     * The field in the <code>selectedItem</code> that maps to the 
     * <code>dataProviderField</code> in the <code>dataProvider</code>. If
	 * this value is not set and a dataProvider field is, the selectedItem
	 * is matched to the dateField in the dataProvider.
     */
    public var itemField:String = null;
    
    //----------------------------------
    //  dataProviderField
    //----------------------------------
    
	[Inspectable(category="Data")]
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
    override public function set dataProvider( value:Object ):void
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
    override public function set selectedItem(data:Object):void
    {
    	_selectedData = data;
		var dp:Object;
		
    	if (itemField != null && dataProviderField != null && 
            dataProvider != null && data != null && 
           data.hasOwnProperty( itemField ))
    	{
            for each (dp in dataProvider) 
            {
                if ( dp[dataProviderField] == data[itemField] ) 
                {
                    super.selectedItem = dp;
                    return;     
                }
               
            }   
			
            super.selectedItem = null;  
			
    	} else if (itemField == null && dataProviderField != null && 
			dataProvider != null && data != null ) {
			for each (dp in dataProvider) 
			{
				if ( dp[dataProviderField] == data ) 
				{
					super.selectedItem = dp;
					return;     
				}
				
			}    
			super.selectedItem = null; 
		} else {
    		super.selectedItem = data;
    	}
    }
}

}