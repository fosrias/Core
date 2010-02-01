////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.models
{
import com.fosrias.core.models.interfaces.AInputData;
import com.fosrias.core.models.interfaces.IInputDateRange;
import com.fosrias.core.namespaces.app_internal;

import flash.events.Event;

import mx.controls.DateField;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ValidationResultEvent;
import mx.utils.ObjectUtil;
import mx.validators.ValidationResult;

use namespace app_internal;

[Bindable]
/**
 * The InputDateRange class represents a single date range and can
 * be validated using a DateComparisonValidator.
 * 
 * The start and end dates can be forced to proper orientation by setting 
 * the isSwitchable parameter to true in the constructor.
 * 
 * @see com.fosrias.core.models.interfaces.AInputData
 * 
 */
public class InputDateRange extends AInputData 
    implements IInputDateRange
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function InputDateRange( startDate:Date = null, endDate:Date = null,
	    startRequired:Boolean = false, endRequired:Boolean = false,
	    isOrdered:Boolean = true, isSwitchable:Boolean = false )
	{
		super( this);
		
		_startInputDate = new InputDate( startDate, null, startRequired );
		_endInputDate = new InputDate( endDate, null, endRequired );
		
		_isOrdered = isOrdered;
		_isSwitchable = isSwitchable;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     * @private 
     */
    private var _isSwitchable:Boolean;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * A clone of the instance.
     */
    public function get clone():IInputDateRange
	{
		var clone:InputDateRange = new InputDateRange( startDate, endDate, 
		    startInputDate.required, endInputDate.required, isOrdered, 
		    _isSwitchable );
		clone.endErrorString = endErrorString;
		clone.startErrorString = startErrorString;
		clone.endText = endText;
        clone.startText = startText;
		clone.errorString = errorString;
		return clone;
	}
	
	//----------------------------------
    //  endDate
    //----------------------------------
    
    /**
     * The end date.
     */    
    public function get endDate():Date
    {
        return endInputDate.date;
    }
    
    /**
     * @private 
     */
    public function set endDate( value:Date ):void
    {
        endInputDate.date = value;
        switchDates();
    }
    
    //----------------------------------
    //  endErrorString
    //----------------------------------
    
    [Bindable(event="errorStringChange")]
    /**
     * The end date error string.
     */    
    public function get endErrorString():String
    {
        return endInputDate.errorString;
    }
    
    /**
     * @private 
     */
    public function set endErrorString( value:String ):void
    {
        endInputDate.errorString = value;
    }
    
    //----------------------------------
    //  endInputDate
    //----------------------------------
    
    /**
     * @private 
     */
    private var _endInputDate:InputDate;
    
    /**
     * The end <code>InputDate</code>.
     */    
    public function get endInputDate():InputDate
    {
        return _endInputDate;
    }
    
    //----------------------------------
    //  endText
    //----------------------------------
    
    /**
     * The end date text.
     */    
    public function get endText():String
    {
        return endInputDate.text;
    }
    
    /**
     * @private 
     */
    public function set endText( value:String ):void
    {
        endInputDate.text = value;
    }
    
    //----------------------------------
    //  isOrdered
    //----------------------------------
    
    /**
     * @private 
     */
    private var _isOrdered:Boolean;
    
    /**
     * Whether the start date must be less than the end date.
     */
    public function get isOrdered():Boolean
    {
        return _isOrdered;
    }
	
	//----------------------------------
    //  startDate
    //----------------------------------
    
    /**
     * The start date.
     */    
    public function get startDate():Date
	{
		return startInputDate.date;
	}
	
	/**
     * @private 
     */
    public function set startDate( value:Date ):void
    {
        startInputDate.date = value;
        switchDates();
    }
    
    //----------------------------------
    //  startErrorString
    //----------------------------------
    
    [Bindable(event="errorStringChange")]
    /**
     * The start date error string.
     */    
    public function get startErrorString():String
    {
        return startInputDate.errorString;
    }
    
    /**
     * @private 
     */
    public function set startErrorString( value:String ):void
    {
        startInputDate.errorString = value;
    }
    
    //----------------------------------
    //  startInputDate
    //----------------------------------
    
    /**
     * @private 
     */
    private var _startInputDate:InputDate;
    
    /**
     * The start <code>InputDate</code>.
     */    
    public function get startInputDate():InputDate
    {
        return _startInputDate;
    }
    
    //----------------------------------
    //  startText
    //----------------------------------
    
    /**
     * The start date text.
     */    
    public function get startText():String
    {
        return startInputDate.text;
    }
    
    /**
     * @private 
     */
    public function set startText( value:String ):void
    {
        startInputDate.text = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Whether the current object is equal to the value being compared.
     * 
     * @param value The object to compare.
     */
    override public function isEqual( value:Object ):Boolean
    {
    	//Only compare if value is an InputDateRange
        if( value is InputDateRange )
        {
            //Compare the properties
            return value.startInputDate.isEqual( startInputDate ) && 
                   value.endInputDate.isEqual( endInputDate );
        }
        return false;
    }

	/**
     * Sets the start date state from the state of a <code>DateField</code>.
     * Method must be used if the value is being validated.
     */
    public function setStartFromDateField( value:DateField ):void
    {
        startInputDate.setFromDateField( value );
        
        //So that binding and validation on PROPERTY_CHANGE work
        dispatchEventType( PropertyChangeEvent.PROPERTY_CHANGE );
    }
    
    /**
     * Sets the end date state from the state of a <code>DateField</code>.
     * Method must be used if the value is being validated.
     */
    public function setEndFromDateField( value:DateField ):void
    {
        endInputDate.setFromDateField( value );
        
        //So that binding and validation on PROPERTY_CHANGE work
        dispatchEventType( PropertyChangeEvent.PROPERTY_CHANGE );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
      
    /**
     * @inheritDoc
     * 
     * @private
     * Most of the functionality here is related to the DateComparisonValidator
     * validation results on an InputDateRange source.
     */
    override public function validationResultHandler( 
        event:ValidationResultEvent):void
    {
    	var hasEndError:Boolean = false;
        var hasStartError:Boolean = false;
        var endError:String = '';
        var startError:String = '';
            
        var validationResult:ValidationResult
    	if ( event.type == ValidationResultEvent.INVALID )
        {
        	//Iterate through the results and process errors by
        	//the value of error code.
        	for each ( validationResult in event.results )
        	{
        		if ( !hasEndError && validationResult.isError && 
        		    validationResult.errorCode.indexOf("End") >= 0 )
        		{
        			//Take the first end error and then stop checking
        			hasEndError = true;
        			endError = validationResult.errorMessage;
        		}
        		if ( !hasStartError && validationResult.isError && 
                    validationResult.errorCode.indexOf("Start") >= 0 )
                {
                    //Take the first start error and then stop checking
                    hasStartError = true;
                    startError = validationResult.errorMessage;
                }
        	}
            startInputDate.errorString = startError;
            endInputDate.errorString = endError;
            _errorString = event.message;
        } else {
            _errorString = '';
            endInputDate.errorString = '';
            startInputDate.errorString = '';
        }
        dispatchEventType( "errorStringChange" );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
      
    /**
     *  @private
     *  This method scrubs out time values from incoming date objects
     */ 
    private function scrubTimeValue( value:Date):Date
    {
        return new Date(value.getFullYear(), value.getMonth(), value.getDate());
    }
    
    /**
     * @private
     */
    private function switchDates():void
    {
    	if ( !_isSwitchable )
    	   return;
    	   
        if ( ObjectUtil.dateCompare( scrubTimeValue( startDate ), 
            scrubTimeValue( endDate ) ) > 0 && startDate != null )
        {
            var oldStartDate:Date = startDate;
            startDate = endDate;
            endDate = oldStartDate;
        }
    }
}

}