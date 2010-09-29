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
import mx.collections.IList;
import mx.controls.ComboBox;
import mx.controls.listClasses.IListItemRenderer;
import mx.events.FlexEvent;

import spark.components.ComboBox;

/**
 * The AdvancedSparkComboBox class is a combo box extended to allow mapping 
 * of selectedItem data fields to fields in the data provider if 
 * the mapping fields are set. Otherwise, it functions as a normal 
 * combo box. The AdvancedSparkComboBox can be used as an inline itemEditor in 
 * a DataGrid or AdvancedDataGrid as well.
 */
public class AdvancedSparkComboBox extends spark.components.ComboBox
                                   implements IListItemRenderer
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
    //  data
    //----------------------------------
    
    /**
     * @private
     * Storage for the dataProperty 
     */
    private var _data:Object;
    
    [Bindable("dataChange")]
    /**
     * The itemEditor data
     */
    public function get data():Object 
    {
        return _data;
    }
    
    /**
     * @private
     */
    public function set data(value:Object):void 
    {
        _data = value;
        
        selectedItem = _data;
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
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
     * <code>dataProviderField</code> in the <code>dataProvider</code>.
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
    
	//----------------------------------
	//  selectedField
	//----------------------------------
	
	[Inspectable(category="Data")]
	/**
	 * The field in the <code>selectedItem</code> items that maps to the 
	 * <code>dataProviderField</code>.
	 */
	public function get selectedField():*
	{
		if (selectedItem != null)
		{
			return selectedItem[dataProviderField];
		} else {
			return null;
		}
	}
	
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
		var dp:Object;
		
		if (itemField != null && dataProviderField != null && 
			dataProvider != null && value != null && 
			value.hasOwnProperty(itemField) )
		{
			for each (dp in dataProvider) 
			{
				if ( dp[dataProviderField] == value[itemField] ) 
				{
					super.selectedItem = dp;
					return;     
				}
				
			}   
			
			super.selectedItem = null;  
			
		} else if (itemField == null && dataProviderField != null && 
			dataProvider != null && value != null ) {
			for each (dp in dataProvider) 
			{
				if ( dp[dataProviderField] == value ) 
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