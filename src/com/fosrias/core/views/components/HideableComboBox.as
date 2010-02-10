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
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.controls.ComboBox;
import mx.controls.dataGridClasses.DataGridListData;
import mx.core.mx_internal;
import mx.events.DropdownEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;

use namespace mx_internal

/**
 * The HideableComboBox is a combo box whose drop down button is not 
 * visible unless the component has the focus or is being interacted
 * with.
 */
public class HideableComboBox extends ComboBox
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function HideableComboBox()
	{
		super();
		
		addEventListener(FlexEvent.ADD, addHandler, false, 0 , true);	
		addEventListener(FlexEvent.REMOVE, removeHandler, false, 0 , true);
        
        addHandlers();
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     */
    private var _hasMouseOver:Boolean = false;
    
    /**
     * @private 
     */
    private var _hasFocus:Boolean = false;
    
	/**
     * @private 
     */
    private var _internalData:Object;
	
	/**
     * @private 
     */
    private var _isOpen:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  editorData
    //----------------------------------
    
    [Bindable] 
    /**
     * The value of the <code>HideableComboBox</code> when used as an 
     * item editor.
     * 
     *  When using this component as an itemEditor rather than an itemRenderer,
     *  set editorDataField="editorItemField" on the column to ensure 
     *  that changes to the <code>HideableComboBox</code> are propogated.
     */
    public var editorData:Object = '';
    
    //----------------------------------
    //  isGridItemRenderer
    //----------------------------------
    
    /**
     * @private
     * Storage for the isGridItemRenderer property.
     */
    private var _isGridItemRenderer:Boolean = false;
    
    [Inspectable]
    /**
     * Whether the component is being used as an item renederer or not.
     */
    public function get isGridItemRenderer():Boolean
    {
    	return _isGridItemRenderer;
    }
    
    /**
     * @private
     */
    public function set isGridItemRenderer( value:Boolean ):void
    {
    	_isGridItemRenderer = value;
    	
    	if( super.data != null && _isGridItemRenderer ) 
        {                    
            _internalData = super.data;
            setSelected();
        }
    }
    
    //----------------------------------
    //  dataField
    //----------------------------------
    
    /**
     * @private 
     * Storage for the dataField property. 
     */
    private var _dataField:String = "value";
     
    /**
     * The field in the data provider that sets the selected item
     * when used as an item renderer. Set this value to null for 
     * dataProviders containing arrays of values, vs. objects with 
     * properties.
     */
    public function get dataField():String
    {
    	return _dataField;
    }
    
    /**
     * @private
     */
    public function set dataField (value:String) : void 
    {
        _dataField = value;
        setSelected();
    } 
              
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ComboBox
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override protected function focusInHandler(event:FocusEvent):void
    {
    	_hasFocus = true;
    	setButtonVisibility();
    	super.focusInHandler( event );
    }
    
    /**
     * @inheritDoc
     */
    override protected function focusOutHandler(event:FocusEvent):void
    {
    	_hasFocus = false;
        setButtonVisibility();
        super.focusOutHandler( event );
    }
    
    /**
     * @inheritDoc
     */
    override public function get data():Object 
    {
    	if ( _isGridItemRenderer )
    	{
            return _internalData;
        } else {
        	return super.data;
        }
    } 
    
    /**
     * @private
     */
    override public function set data (value:Object):void 
    {
        if( value != null && _isGridItemRenderer ) 
        {                    
            _internalData = value;
            setSelected();
        } else {
        	super.data = value;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    //Handlers
    
    /**
     * @private 
     */
    private function addHandler( event:FlexEvent ):void
    {
        addHandlers();
    }
    
    /**
     * @private 
     */
    private function changeHandler( event:ListEvent ):void
    {
         if ( selectedItem != null && _internalData != null) 
         {                    
            var col:DataGridListData = DataGridListData(listData);
            if ( _dataField != null)
            {       
                _internalData[col.dataField] = selectedItem[_dataField];
                editorData = selectedItem[_dataField];
            } else {
            	_internalData[col.dataField] = selectedItem;
                editorData = selectedItem;
            }
        }
    }
    
    /**
     * @private 
     */
    private function closeHandler( event:DropdownEvent ):void
    {
    	_isOpen = false;
        setButtonVisibility();
    }
    
    /**
     * @private 
     */
    private function dataChangeHandler( event:FlexEvent ):void
    {
        setSelected();
    }

	/**
     * @private 
     */
    private function creationCompleteHandler( event:FlexEvent ):void
    {
        downArrowButton.visible = false;
    } 
    
    /**
     * @private 
     */
    private function mouseOverHandler( event:MouseEvent ):void
	{
		_hasMouseOver = true;
		setButtonVisibility();
	}
	
	/**
     * @private 
     */
    private function mouseOutHandler( event:MouseEvent ):void
	{
		_hasMouseOver = false;
	    setButtonVisibility();
	} 
	
	/**
     * @private 
     */
    private function openHandler( event:DropdownEvent ):void
    {
        _isOpen = true;
        setButtonVisibility();
    }
    
    /**
     * @private 
     */
    private function removeHandler( event:FlexEvent ):void
    {
        removeHandlers();
    }

	/**
     * @private 
     */
    private function setButtonVisibility():void
	{
		downArrowButton.visible =  (_isOpen || _hasMouseOver || _hasFocus ) &&
            enabled;
	}
	
	//Utility methods
	
	/**
     * @private 
     */
    private function addHandlers():void
	{ 
		addEventListener(ListEvent.CHANGE, changeHandler);
	    addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
        addEventListener(FlexEvent.DATA_CHANGE, dataChangeHandler);
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        addEventListener(DropdownEvent.CLOSE, closeHandler);
        addEventListener(DropdownEvent.OPEN, openHandler);
	}
	
	/**
     * @private 
     */
    private function removeHandlers():void
    {
    	removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
        removeEventListener(ListEvent.CHANGE, changeHandler);
        removeEventListener(FlexEvent.DATA_CHANGE, dataChangeHandler);
        removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        removeEventListener(DropdownEvent.CLOSE, closeHandler);
        removeEventListener(DropdownEvent.OPEN, openHandler);
        removeEventListener(FlexEvent.REMOVE, removeHandler);
    }
    
    /**
     * @private 
     */
    private function setSelected():void 
    {
        if ( dataProvider != null && _internalData != null ) 
        {
            var col:DataGridListData = DataGridListData(listData);
            for each (var dp:Object in dataProvider) 
            {
            	if (_dataField != null )
            	{
	                if ( dp[_dataField] == _internalData[col.dataField]) 
	                {
	                    selectedItem = dp;
	                    editorData = _internalData[col.dataField];
	                    return;     
	                }
                } else if ( dp == _internalData[col.dataField])  {
                    selectedItem = dp;
                    editorData = _internalData[col.dataField];
                    return;     
                }
            }                    
        }
        selectedItem = null;
    }
}	
	
}