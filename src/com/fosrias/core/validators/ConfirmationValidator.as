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
import flash.errors.IllegalOperationError;

import mx.validators.ValidationResult;
import mx.validators.Validator;
/**
 * The class is a validator used to compare two sources. E.g. use it 
 * for password or email confirmation.
 */
public class ConfirmationValidator extends Validator 
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ConfirmationValidator() 
	{
	    super();
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  confirmName
    //----------------------------------
    
    /**
     * The name of the source being compared to the confirmation. This 
     * value is the name used in the errorString message of the validator.
     */
    public var confirmName:String = "name";
    
    //----------------------------------
    //  confirmProperty
    //----------------------------------
    
    /**
     * The property to be validated. The default is the some property as 
     * the primary source. 
     */
    public var confirmProperty:String = null;
    
    //----------------------------------
    //  confirmSource
    //----------------------------------
    
    /**
     * The source object to be compared with the primary source object
     */
    public var confirmSource:Object = null;

	//--------------------------------------------------------------------------
    //
    //  Overridden methods.
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override protected function doValidation( value:Object):Array
	{
	    var results:Array = [];
	    
	    //Get the value to be confirmed
	    if ( confirmSource != null )
	    {
	    	var confirmValue:Object;
	    	
	    	if ( confirmProperty == null )
	    	{
	    		if ( property == null )
	    		{
	    			confirmValue = confirmSource;
	    		} else {
	    			confirmValue = confirmSource[ property ]
	    		}
	    	} else {
	    		confirmValue = confirmSource[ confirmProperty ];
	    	}
	    	
	    	//Compare the values
	        if ( confirmValue != value ) {
	            results.push( new ValidationResult( true, confirmName,
                    confirmName.toLowerCase() + "DoesNotMatchConfirmation",
                    confirmName + " does not match the confirmation."));
	        }     
	    } else {
            throw new IllegalOperationError("The confirmSource property " + 
                    "must be set in a ConfirmationValidator.");
        }
	    return results;
	}
}

}