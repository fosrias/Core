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
import flash.events.Event;

import mx.controls.ComboBox;

/**
 * The EnumComboBox class is a ComboBox that uses an enumerated type for
 * its data provider. The enumerated type must implement the the same
 * functionality as the sample <code>TypeEnum</code> class.
 * 
 * @see com.fosrias.core.enums.TypeEnum;
 */
public class EnumComboBox extends ComboBox
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function EnumComboBox()
    {
        super();
        
        //enumType value property
        this.labelField = "value";
        
        //In case enumType property not set
        this.dataProvider = { value: "enumType required" };
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  enumList
    //----------------------------------
    
    /**
     * @private
     * Storage for the enumList property 
     */
    private var _enumList:String;
    
    [Inspectable]
    /**
     * The list property of the enum type. The default is cList.
     */
    public function get enumList():String
    {
        return _enumList;
    }
     
    /**
     * @private
     */    
    public function set enumList( value:String ):void
    {
        if ( value != null && value != "" && _enumType != null )
        {
            if ( _enumType.hasOwnProperty( value ) )
            {
            	this.dataProvider = _enumType[ value ];
            } 
        } 
        _enumList = value;
    }
    
    //----------------------------------
    //  enumRowCount
    //----------------------------------
    
    [Bindable(event="enumTypeChange")]
    /**
     * The length of the enum type. If the enum type is not set, it returns the 
     * current rowCount.
     */
    public function get enumRowCount():int
    {
    	if ( _enumType != null )
    	{
    		return _enumType.cList.length;
    	} else {
    		return this.rowCount;
    	}
    }
    
    //----------------------------------
    //  enumType
    //----------------------------------
    
    /**
     * @private
     * Storage for the enumType property 
     */
    private var _enumType:Class;
    
    [Bindable]
    /**
     * The enumerated class that is the data provider for the comboBox.
     */
    public function get enumType():Class
    {
        return _enumType;
    }
     
    /**
     * @private
     */    
    public function set enumType( value:Class ):void
    {
        if ( value == null )
        {
            this.dataProvider = { value: "enumType required" };
        } else {
        	if ( _enumList != null && _enumList != "" 
        	   && value.hasOwnProperty( _enumList ) )
        	{
        		this.dataProvider = value[ _enumList ];
        	} else {
                this.dataProvider = value.cList;
            }
                        
            //Set the rowCount
            if ( hasEnumRowCount )
            {
                this.rowCount = value.cList.length;
            }
            
            //Set the selected item if ordinal is not set
            selectedItem = Class(value).selectByOrdinal(_ordinal);
        }
        _enumType = value;
        
        dispatchEvent( new Event( "enumTypeChange" ) );
    }
    
    //----------------------------------
    //  hasEnumRowCount
    //----------------------------------
    
    /**
     * @private
     * Storage for the hasEnumRowCount property 
     */
    private var _hasEnumRowCount:Boolean;
    
    [Inspectable]
    /**
     * Whether the rowCount is set equal to the enumType length. Set this to
     * true to lock the rowCount to the number of items in the dataProvider.
     */
    public function get hasEnumRowCount():Boolean
    {
        return _hasEnumRowCount;
    }
     
    /**
     * @private
     */    
    public function set hasEnumRowCount( value:Boolean ):void
    {
        if ( value && _enumType != null )
        {
            this.rowCount = enumRowCount;
        } 
        _hasEnumRowCount = value;
    }
    
    //----------------------------------
    //  ordinal
    //----------------------------------
    
    private var _ordinal:int;
    
    [Bindable(event="change")]
    [Bindable]
    /**
     * The ordinal of the enum type of the selectedItem.
     */
    public function get ordinal():int
    {
    	if ( _enumType == null || selectedItem == null )
    	{
    		return -1;
    	} else {
    		_ordinal = selectedItem.ordinal;
            return _ordinal;
        }
    }
     
    /**
     * @private
     */    
    public function set ordinal( value:int ):void
    {
        if ( _enumType != null )
        {
            selectedItem = Class(_enumType).selectByOrdinal( value );
        }
        _ordinal = value;
    }
}

}