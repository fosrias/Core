////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.validators
{
import com.fosrias.core.models.InputDate;
import com.fosrias.core.models.InputDateRange;

import flash.errors.IllegalOperationError;

import mx.utils.ObjectUtil;
import mx.validators.DateValidator;
import mx.validators.ValidationResult;

/**
 * The DateComparisonValidatorclass is a DateValidator that also compares a 
 * first date to a last date to ensure the dates are related according to the 
 * comparison operator in addition to the standard <code>DateValidator</code> 
 * functionality.
 * 
 * <p>The format of the comparison is <code>firstDate</code> 
 * <code>comparisionOperator</code> <code>lastDate</code> with the default 
 * error message  "The <code>firstDateName</code> must be 
 * <code>comparisionOperator</code> the <code>endDateName</code> with 
 * the <code>firstDateName</code>, <code>endDateName</code> and  
 * <code>comparisionOperator</code> defaults being "start date", 
 * "end date" and <=, respectively.</p>
 * 
 * <p>Comparison functionality will only validate if both the 
 * <code>firstDate</code> and <code>lastDate</code> properties are defined
 * with non-null values.</p>
 */
public class DateComparisonValidator extends DateValidator
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function DateComparisonValidator()
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
    private var _oldStartInputDate:InputDate;
    
    /**
     * @private
     */
    private var _oldEndInputDate:InputDate;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  comparisonErrorString
    //----------------------------------
    
    /**
     * The comparsion error string. Setting this property replaces the 
     * default comparison error string.
     * 
     * @default null
     */
    public var comparisonErrorString:String = null;
    
    //----------------------------------
    //  comparisonOperator
    //----------------------------------
    
    /**
     * The operator used to compare  the source and comparsion date. E.g.
     * source <= comparison source on the specified property.
     * 
     * @default <=
     */
    public var comparisonOperator:String = "<=";
    
    //----------------------------------
    //  firstDate
    //----------------------------------
    
    /**
     *  Specifies the source property associated with the first date.
     *  Supports dot-delimited property strings.
     *  
     *  @default null
     */
    public var firstDate:String;

    //----------------------------------
    //  firstDateName
    //----------------------------------
    
    /**
     * A string specifying the name of the <code>firstDate</code> to 
     * be used in the default comparison error message.
     *  
     * @default "start Date"
     */
    public var firstDateName:String = "start date";
    
    //----------------------------------
    //  lastDate
    //----------------------------------
    
    /**
     * Specifies the source property associated with the last date. 
     * Supports dot-delimited property strings.
     *  
     * @default null
     */
    public var lastDate:String;
    
    //----------------------------------
    //  lastDateName
    //----------------------------------
    
    /**
     * A string specifying the name of the <code>lastDate</code> to 
     * be used in the default comparison error message.
     *  
     * @default "end Date"
     */
    public var lastDateName:String = "end date";
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  source
    //----------------------------------
    
    /**
     * @inheritDoc
     * 
     * <p>If the source is an <code>InputDateRange</code>, then the property
     * specified applies to the start and end <code>InputDate</code> properties
     * of the range and setting the <code>firstDate</code> and 
     * <code>lastDate</code> properties have no effect. Further, the 
     * comparison operator also applies to the start and end dates of the
     * <code>InputDateRange</code>.
     */
    override public function get source():Object
    {
    	return super.source;
    }
    
    /**
     * @inheritDoc
     */
    override public function set source( value:Object ):void
    {
    	super.source = value;
    	
    	//Set start and end date to 
    	if ( _oldStartInputDate == null && _oldEndInputDate == null && 
    	     value is InputDateRange)
    	{
    		_oldStartInputDate = InputDateRange( value ).startInputDate.clone;
    		_oldEndInputDate   = InputDateRange( value ).endInputDate.clone;
    	}
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */    
    override protected function doValidation( value:Object ):Array 
    {
        // Clear results Array.
        var results:Array = [];

        // Call base class doValidation().
        var startChanged:Boolean = false;
        var endChanged:Boolean = false;
        var dateRange:InputDateRange;
        
        if ( value is InputDateRange )
        {
        	dateRange = InputDateRange( value );
        	var validationResult:ValidationResult; 
        	var rangeValue:Object; 
        	var endResults:Array = [];
      
        	if ( !dateRange.startInputDate.isEqual( _oldStartInputDate ) && 
        	     _oldStartInputDate != null )
        	{   
        		rangeValue = findPropertyOf( dateRange.startInputDate, 
        		    property );
        		results = super.doValidation( rangeValue );
        		startChanged = true;
        		
        		for each( validationResult in results )
        		{
        			validationResult.errorCode = "Start "
        			    + validationResult.errorCode;
        		}
        	} 
        	
            if ( !dateRange.endInputDate.isEqual( _oldEndInputDate )  && 
        	            _oldStartInputDate!= null ) {
        		
        		rangeValue = findPropertyOf( dateRange.endInputDate, property );
        		endResults = super.doValidation( rangeValue );
        		endChanged = true;
        		
        		for each( validationResult in endResults )
                {
                    validationResult.errorCode = "End " 
                        + validationResult.errorCode;
                        
                    results.push( validationResult );
                }
        	}
        } else {
        	results = super.doValidation( value );
        }
        
        // Return if there are errors or no comparison source is specified.
        if ( results.length > 0 )
            return results;
            
        var isValid:Boolean;
        if ( value is InputDateRange )
        {
        	dateRange = InputDateRange( value );
        	isValid = isValidDateRange( dateRange.startDate, 
        	    dateRange.endDate );
        } else {
        	
        	//Check if date range is valid
        	var firstDateValue:Date = findDate( firstDate );
        	var lastDateValue:Date = findDate( lastDate );
            isValid = !required;
            if ( firstDate != null && lastDate != null )
            {
                isValid = isValidDateRange(  firstDateValue, lastDateValue );
            }
        }
        
        // If input value is not a number, or contains no value, 
        // issue a validation error.
        if ( !isValid || !value )
        {
        	var message:String = comparisonErrorString;
        	
        	var errorCode:String = "Not " +  comparisonOperator;
        	
        	//Check for start or non-InputDateRange errors
            if ( (!startChanged && !endChanged ) || startChanged  )
    		{
    			if ( message == null )
                {
	    		    message = "The " + firstDateName + " must be " 
	    		        + comparisonOperator + " the " + lastDateName + "."
                }
    		    if ( startChanged )
    		    {
    		    	errorCode = "Start not " + comparisonOperator;
    		    	
    		    }
    		    results.push( new ValidationResult( true, null, errorCode, 
                message ) );
    		    
    		} 
    		
    		//Check for end errors
    		message = comparisonErrorString;
            if ( endChanged ) 
            {
            	if ( message == null )
                {
                    message = "The " + lastDateName + " must be " 
                        + findOppositeOperator() + " the " 
                        + firstDateName + "."
                    errorCode = "End not " + findOppositeOperator();
                }

        	results.push( new ValidationResult( true, null, errorCode, 
        	    message ) );
        	}
        }  
        
        //Use a clone so that changes don't pass through
        //Only update when valid
        if ( results.length == 0 && value is InputDateRange )
        {
            _oldStartInputDate = dateRange.startInputDate.clone;
            _oldEndInputDate = dateRange.endInputDate.clone;
        }          
        return results;
    }
    
    /**
     *  Returns the Object to validate. Subclasses, such as the 
     *  CreditCardValidator and DateValidator classes, 
     *  override this method because they need
     *  to access the values from multiple subfields. 
     *
     *  @return The Object to validate.
     */
    override protected function getValueFromSource():Object
    {
        var message:String;

        if (  source && property )
        {
        	if ( source is InputDateRange )
        	{
        		return source;
        	} else {
                return source[ property ];
            }
        }

        else if (!source && property)
        {
            message = resourceManager.getString(
                "validators", "SAttributeMissing");
            throw new Error(message);
        }

        else if ( source && !property )
        {
            message = resourceManager.getString(
                "validators", "PAttributeMissing");
            throw new Error(message);
        }
        
        return null;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function findDate( property:String ):Date
    {
    	if ( property == null )
    	{
    		if ( source is Date )
    		{
    			return source as Date;
    		} else {
    			return null;
    		}
    	}
    	var obj:Object = findPropertyOf( source, property );
    	
    	if ( obj is Date )
    	{
    		return obj as Date;
    	} else {
    		throw new IllegalOperationError("No date is associated with " + 
    				"the property " + property + ".");
    	}
    }
    
    /**
     * @private
     */
    private function findPropertyOf( value:Object, property:String ):Object
    {
        var obj:Object = value;
        
        if ( property != null )
        {
	        var parts:Array = property.split(".");
	
	        var n:int = parts.length;
	        for (var i:int = 0; i < n; i++)
	        {
	            try
	            {
	                obj = obj[parts[i]];
	            }
	            catch(error:Error)
	            {
	                if ( ( error is TypeError ) &&
	                    ( error.message.indexOf( "null has no properties" ) 
                        != -1) )
	                {
	                    throw new IllegalOperationError( "Property " + property 
	                       + "not in DateComparisonValidator source. " );
	                }
	                else
	                {                    
	                    throw error;
	                }
	            }
	        }
        }
        
        return obj;
    }
    
    /**
     * @private
     */
    private function findOppositeOperator():String
    {
    	switch ( comparisonOperator )
        {
            case "<":
                return ">";
            
            case "<=":
                return ">=";
            
            case ">":
                return "<";
            
            case ">=":
                return "<";
            
            case "<>", "!=":
                return "<>";
            default:  // "="
                return "=";
        }
    }
    
    /**
     * @private
     */
    private function isValidDateRange( firstDate:Date, lastDate:Date):Boolean
    {
    	if ( this.comparisonOperator == null )
    	{
    		throw new IllegalOperationError("DateComparisonValidator Error:"  
                    +   " The comparisonOperator cannot be null." );
    	}
    	
    	var dateComparison:int = ObjectUtil.dateCompare( firstDate, lastDate );

    	switch ( comparisonOperator )
    	{
    		case "<":
                return dateComparison < 0;
            
            case "<=":
                return dateComparison <= 0;
            
            case ">":
                return dateComparison > 0;
            
            case ">=":
                return dateComparison >= 0;
            
            case "<>", "!=":
                return dateComparison != 0;
            default: // "="
                return dateComparison == 0;
    	}
    }
    
    
}

}