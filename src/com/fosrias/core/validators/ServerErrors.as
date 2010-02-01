////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009-2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.validators
{
import com.fosrias.core.interfaces.AClass;

import mx.validators.ValidationResult;

/**
 * The ServerErrors class processes server XML messages associated with 
 * remote errors.
 */
public class ServerErrors extends AClass 
{
    
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The default server error. 
     */
    private static const BASE:String = ":base";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
   public function ServerErrors( errorsXML:XML )
   {
       super( this );
       
       _allErrors = {};
       
       for each ( var error:XML in errorsXML.error ) 
       {
           var field:String = error.@field;
           
           if (field == null || field == "") 
           {
               field = BASE;
           }
           if (_allErrors[ field ] == null) 
           {
               _allErrors[ field ] = [ createValidationResult( 
                   error.@message) ];
           } else {
               var fieldErrors:Array = _allErrors[ field ];
               
               fieldErrors.push( createValidationResult( error.@message ) );
           }
       }
   }
    
   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------
   
   /**
     * 
     * @private
     * The errors on specific fields (base errors are on the
     * BASE). The keys are the field Strings; the values are
     * Arrays of errors.
     */
    private var _allErrors:Object;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Return an Array of the errors (just Strings) for the
     * field, an empty Array if none.
     */
    public function findErrorsForField( field:String ):Array        
    {
        if (field == null || field == "") 
        {
            field = BASE;
        }
        return _allErrors[ field ] == null ? [] : _allErrors[ field ];
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function createValidationResult( message:String ):ValidationResult 
    {
        return new ValidationResult( true, "", "SERVER_VALIDATION_ERROR",
            message);
    }
}

}