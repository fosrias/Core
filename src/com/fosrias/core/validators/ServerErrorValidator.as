////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009-2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package  com.fosrias.core.validators
{
import mx.validators.Validator;

public class ServerErrorValidator extends Validator 
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function ServerErrorValidator(listener:Object, field:String = null) 
    {
        super();
        
        this.field = field;
        this.listener = listener;
        _serverErrors = null;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  serverErrors
    //----------------------------------
    
    /**
     * The field of the ServerErrors we are interested in.
     */
    public var field:String;
    
    //----------------------------------
    //  serverErrors
    //----------------------------------
    
    /**
     * @private
     * Storage for the serverErrors property. 
     */
    private var _serverErrors:ServerErrors;
    
    /**
     * These are the ServerErrors that apply specifically to
     * this ServerErrorValidator.
     */
    public function get serverErrors():ServerErrors
    {
        return _serverErrors ;
    }
    /**
     * The ServerErrors we are interested in.
     */
    public function set serverErrors( pServerErrors:ServerErrors ):void 
    {
        _serverErrors = pServerErrors;
        validate();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override protected function doValidation( value:Object ):Array 
    {
        if ( _serverErrors != null )
        {
            return _serverErrors.findErrorsForField( field );
        } 
        return [];
    }
}

}