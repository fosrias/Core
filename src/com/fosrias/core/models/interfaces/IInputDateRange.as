package com.fosrias.core.models.interfaces
{
import com.fosrias.core.models.InputDate;

import flash.events.IEventDispatcher;

import mx.controls.DateField;
import mx.validators.IValidatorListener;
	
public interface IInputDateRange extends IIsEqual, IValidatorListener, 
    IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * A clone of the instance
     */
    function get clone():IInputDateRange;
    
    //----------------------------------
    //  endInputDate
    //----------------------------------
    
    /**
     * The end <code>InputDate</code>.
     */    
    function get endInputDate():InputDate;
    
    //----------------------------------
    //  startInputDate
    //----------------------------------
    
    /**
     * The start <code>InputDate</code>.
     */    
    function get startInputDate():InputDate;
    
    //----------------------------------
    //  isOrdered
    //----------------------------------
    
    /**
     * Whether the start date must be less than the end date.
     */
    function get isOrdered():Boolean;
    
    //----------------------------------
    //  startDate
    //----------------------------------
    
    /**
     * The start date.
     */    
    function get startDate():Date;
    
    /**
     * @private 
     */
    function set startDate( value:Date ):void;
    
    //----------------------------------
    //  startErrorString
    //----------------------------------
    
    /**
     * The start date error string.
     */    
    function get startErrorString():String;
    
    /**
     * @private 
     */
    function set startErrorString( value:String ):void;
    
    //----------------------------------
    //  startText
    //----------------------------------
    
    /**
     * The start date text.
     */    
    function get startText():String;
    
    /**
     * @private 
     */
    function set startText( value:String ):void;
    
    //----------------------------------
    //  endDate
    //----------------------------------
    
    /**
     * The end date.
     */    
    function get endDate():Date;
    
    /**
     * @private 
     */
    function set endDate( value:Date ):void;
    
    //----------------------------------
    //  endErrorString
    //----------------------------------
    
    /**
     * The end date error string.
     */    
    function get endErrorString():String;
    
    /**
     * @private 
     */
    function set endErrorString( value:String ):void;
    
    //----------------------------------
    //  endText
    //----------------------------------
    
    /**
     * The end date text.
     */    
    function get endText():String;
    
    /**
     * @private 
     */
    function set endText( value:String ):void;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Sets the start date state from the state of a <code>DateField</code>.
     * Method must be used if the value is being validated.
     */
    function setStartFromDateField( value:DateField ):void;
    
    /**
     * Sets the end date state from the state of a <code>DateField</code>.
     * Method must be used if the value is being validated.
     */
    function setEndFromDateField( value:DateField ):void;
}

}