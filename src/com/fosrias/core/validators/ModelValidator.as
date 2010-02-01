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
import com.fosrias.core.interfaces.AFactory;
import com.fosrias.core.utils.interfaces.IBuilder;
import com.fosrias.core.views.interfaces.AValidatedViewModel;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.events.PropertyChangeEvent;
import mx.events.ValidationResultEvent;
import mx.validators.Validator;

[Bindable]
/**
 * The ModelValidator class is a delegate class used in the AValidatedViewModel
 * class to validate presentation models.
 * 
 * @see com.fosrias.core.views.interfaces.AValidatedViewModel
 */
public class ModelValidator extends EventDispatcher
{
	//--------------------------------------------------------------------------
    //
    //  Class Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     */
    protected static var validatorFactory:AFactory = new ValidatorFactory;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ModelValidator( model:AValidatedViewModel )
    {
        _model = model;   
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private var _activeSourceNameCache:ArrayCollection = new ArrayCollection;
    
    /**
     * @private
     */
    private var _isStopped:Boolean = true;
    
    /**
     * @private
     */
    private var _isValidMap:Dictionary = new Dictionary( true );
    
    /**
     * @private
     */
    private var _model:AValidatedViewModel;
    
    /**
     * @private 
     */
    private var _serverErrors:ServerErrors = null;
        
    /**
     * @private
     */
    private var _serverValidatorCache:Array /* Array of ServerValidator */ = [];
    
    /**
     * @private
     */
    private var _sourceNameToValidatorMap:Dictionary = new Dictionary( true );
    
    /**
     * @private
     */
    private var _validatorToSourceNameMap:Dictionary = new Dictionary( true );

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  hasServerErrors
    //----------------------------------
    
    /**
     * Whether there are server errors or not.
     */
    public function get hasServerErrors():Boolean
    {
    	return _serverErrors != null;
    }
    
    //----------------------------------
    //  isValid
    //----------------------------------
    
    /**
     * @private 
     * Storage for the isValid property. 
     */
    private var _isValid:Boolean = false;
        
    /**
     * Whether the validators are all valid or not.
     */
    [Bindable(event="validChanged")]
    public function get isValid():Boolean
    {
        return _isValid;
    }
    
    //----------------------------------
    //  isValidated
    //----------------------------------
    
    /**
     * @private 
     * Storage for the isValidated property. 
     */
    private var _isValidated:Boolean = false;
        
    /**
     * Whether the validators have been validated or not.
     */
    [Bindable(event="validChanged")]
    public function get isValidated():Boolean
    {
        return _isValidated;
    }
     
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
        
    /**
     * Add a validator.
     *  
     * @param type The class type. This is a constant of the ValidatorFactory
     * class.
     * @param source The presentation model property to validate.
     * @param sourceName The string name of the source property. This field
     * supports dot-delimited strings.
     * @param property The property of the source, if any, to validate.
     * @param required Whether the property is required.
     * @param hasServerValidator Whether the object has ServerValidator
     * that validates messages from the server.
     */
    public function addValidator( type:String, sourceName:String, 
        property:String, required:Boolean = false, 
        hasServerValidator:Boolean = false):void
    {   
    	var validator:Validator = validatorFactory.create( type );
    	
    	validator.property = property;
    	validator.required = required;
    	
    	processAddedValidator( validator, sourceName, hasServerValidator );
    }
    
    /**
     * Build a validator from an <code>IBuilder</code> instance.
     *  
     * @param builder The builder.
     * @param sourceName The string name of the source property. This field
     * supports dot-delimited strings.
     * @param property The property of the source, if any, to validate.
     * @param hasServerValidator Whether the object has ServerValidator
     * that validates messages from the server.
     */
    public function buildValidator( builder:IBuilder, sourceName:String,
        hasServerValidator:Boolean ):void
    {
    	 builder.factory = validatorFactory;
    	 processAddedValidator( builder.create(), sourceName, 
    	     hasServerValidator );
    }
    
    /**
     * Checks the whether the current validators are valid or not without
     * re-validating the validators.
     * 
     * @private
     * Updates the isValid property.
     */
    public function checkValidity():void
    {
        _isValid = true;
        
       //Check validity of all validators.
       for ( var validator:* in _validatorToSourceNameMap )
        {
            if ( validator.enabled )
            {
               _isValid &&= _isValidMap[ validator ];
            }
        }
        _isValidated = true;
        dispatchModelValidationEvent();
    }
    
    /**
     * Clears all validation and error strings and sets the model in an
     * un-validated state.
     */
    public function clearValidation():void
    {
    	//Clear server errors
        _serverErrors = null;
        
        //Set model is valid as false
        _isValid = false;
        
        //Set the model as not being validated
        _isValidated = false;
        
        clearValidationErrors();
    }
    
    /**
     * Clears all validation and error strings and sets the model in an
     * un-validated state.
     */
    public function clearValidationErrors():void
    {
        //Clear all the validators and reset their initial validity
        for ( var validator:* in _validatorToSourceNameMap )
        {
            //Clear the error strings on the source
            validator.source.errorString = '';
            
            if ( !_isValidMap[ validator ] )
            {
                _isValidMap[ validator ] = !validator.required;
            }
        }
        
        dispatchModelValidationEvent();
    }
    
    /**
     * Destroys all validators. Once this is called there are no validators
     * set on the model and the setValidators method would need to be called
     * to rebuild the validators.
     */
    public function destroyValidators():void
    {
        //Remove all the standard validators
        for ( var validator:* in _validatorToSourceNameMap )
        {
            //Clear the source and its listeners
            Validator( validator ).source = null;
                
            var sourceName:String = _validatorToSourceNameMap[ validator ];
            
            //Clear maps
            _validatorToSourceNameMap[ validator ] = null;
            delete _validatorToSourceNameMap[ validator ];
            
            _sourceNameToValidatorMap[ sourceName ] = null;
            delete _sourceNameToValidatorMap[ sourceName ];
            
            _isValidMap[ validator ] = null;
            delete _isValidMap[ validator ];
            
            
           
        } 
        
        //Remove all the server error validators
        while ( _serverValidatorCache.length > 0 )
        {
            _serverValidatorCache.pop().listener = null;
           
        }
        
        //Reset arrays
        _activeSourceNameCache = new ArrayCollection;
        
        //Reset variables
        _serverErrors = null;
        
        //Set model is valid as false
        _isValid = false;
        
        //Set the model as not being validated
        _isValidated = false;
        
        //Validation is stopped
        _isStopped == true;
    }
    
    /**
     * Sets the current server errors.
     */
    public function setServerErrors( value:ServerErrors ):void
    {
        _serverErrors = value;
        
        for each ( var validator:ServerErrorValidator in _serverValidatorCache )
        {
            validator.serverErrors = _serverErrors;
        }

        dispatchModelValidationEvent();
    }
    
    /**
     * 
     * @param value An array of sourceNames for sources whose validators
     * are active.
     */
    public function setValidatedSources( value:Array /* Array of String */):void
    {
    	//Cache the active sources. Ensures validators are correctly
    	//enabled when start is called.
    	_activeSourceNameCache = new ArrayCollection( value );
    	
    	//Set the enabled validators
        if ( !_isStopped )
    	    start();   
    }
    
    /**
     * Restarts all validation.
     */
    public function start():void
    {
        for ( var validator:* in _validatorToSourceNameMap )
        {
            if ( _activeSourceNameCache.contains( 
                 _validatorToSourceNameMap[ validator ] ) )
            {
                validator.enabled = true;
            } else {
                validator.enabled = false;
            }
        } 
        
        _isStopped = false;
    }
    
    /**
     * Stops all validation.
     */
    public function stop():void
    {
        for ( var validator:* in _validatorToSourceNameMap )
        {
            validator.enabled = false;
        }
        
        _isStopped = true;
    }
    
    /**
     * Updates a validator property corresponding to a particular 
     * <code>sourceName</code> to a new value. Use this in setters to 
     * update validators when a property object instance changes so that 
     * validators continue to function.
     */
    public function updateValidatorProperty( sourceName:String, property:String, 
        value:Object ):void
    {
    	var  validator:Validator = _sourceNameToValidatorMap[ sourceName ];
        
        if ( validator.hasOwnProperty( property ) )
        {
        	validator[ property ] = value;
        } else {
        	throw new IllegalOperationError("No property " + property 
        	    + " found for " + sourceName + " validator." );
        }
        
        checkValidation( validator, true );
    }
    
    /**
     * Updates a validator corresponding to a particular <code>sourceName</code> 
     * to a new source. Use this in setters to update validators when 
     * the source object instance changes so that validator listeners 
     * continue to function.
     */
    public function updateValidatorSources( ... args ):void
    {
    	for each ( var sourceName:String in args[0] )
    	{
            var  validator:Validator = _sourceNameToValidatorMap[ sourceName ];
            
            if ( validator == null )
                continue;
            
    	    var oldSource:Object = validator.source;
    	
    	    //Update the source
    	    validator.source = findSource( sourceName );
    	
    	    checkValidation( validator );
    	}
    	
    	//Recheck validity in case updated source is not valid after
    	//all sources updated.
    	checkValidity();
    }
    
    /**
     * Completely re-validates all active validators and clears
     * any errors keeping the validity of the model.
     */
    public function validateModel( clearErrors:Boolean = false ):void
    {
        clearValidation();
        for ( var validator:* in _validatorToSourceNameMap )
        {
            checkValidation( validator );
        }
        
        //Clear all error messages.
        if ( clearErrors )
            clearValidationErrors();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function checkValidation( validator:Validator, 
        hasValidityCheck:Boolean = false ):void
    {
	    //Run the validator
        if ( validator.enabled )
        {
            validator.validate();
        }
        
        //Check validity of all validators
        if ( hasValidityCheck )
        {
        	checkValidity();
        }
    }
    
    /**
     * @private
     */
    private function dispatchModelValidationEvent():void
    {
    	dispatchEvent( new Event( "validChanged" ) );  
    	_model.dispatchEvent( new Event( "modelValidated" ) );
    }
    
    /**
     * @private
     */
    private function findSource( sourceName:String ):Object
    {
    	var obj:Object = _model;
    	
    	if ( sourceName == "this" )
    	{
    		return obj;
    	}
    	
        var parts:Array = sourceName.split(".");

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
                    ( error.message.indexOf( "null has no properties" ) != -1))
                {
                    throw new IllegalOperationError( "Field not found: " 
                        + sourceName + " in the model." );
                }
                else
                {                    
                    throw error;
                }
            }
        }
        return obj;
    }
    
    /**
     * @private
     */
    private function processAddedValidator( validator:Validator, 
        sourceName:String, hasServerValidator:Boolean ):void
    {  
    	//Set Validator listeners to update model validity
        validator.addEventListener( ValidationResultEvent.INVALID, 
            setInvalid, false, 0, true);
            
        validator.addEventListener( ValidationResultEvent.VALID, 
            setValid, false, 0, true );
            
        //Get the source from the presentation model
        validator.source = findSource( sourceName );
        
        //Set trigger event to property change since not validating
        //Form controls
        validator.triggerEvent = PropertyChangeEvent.PROPERTY_CHANGE;
        
        //Map the validity of the validator
        _isValidMap[ validator ] = !validator.required;
        
        //Map the source name to the validator. Used to enable 
        //and disable the validator.
        _sourceNameToValidatorMap[ sourceName ] = validator;
        
        //Map the source name to the validator. Used to enable 
        //and disable the validator.
        _validatorToSourceNameMap[ validator ] = sourceName;
        
        //Add the validator the to the active sources
        _activeSourceNameCache.addItem( sourceName );
        
        //Create a server validator for the source
        if ( hasServerValidator )
        {
            _serverValidatorCache.push( new ServerErrorValidator( 
                validator.source, sourceName ) );
        }
    }
    
    /**
     * @private
     * Handler for ValidationResultEvent.INVALID events on validator sources.
     */
    private function setInvalid( event:ValidationResultEvent ):void
    {
        //If the validator was valid, force the errorString to update.
        if ( _isValidMap[ event.target ] != null )
        {
            var validator:Validator = Validator( event.target );
            validator.source.errorString = event.message;
        }
        
        //Map the validator as invalid
        _isValidMap[ event.target ] = false;
        
        //Set the model as invalid
        _isValid = false;
        
        //Set the model as validated
        _isValidated = true;
        
        dispatchModelValidationEvent();
    }
    
    /**
     * @private
     * Handler for ValidationResultEvent.VALID events on validator sources.
     */
    private function setValid( event:ValidationResultEvent ):void
    {
    	//Map the validator as valid
        _isValidMap[ event.target ] = true;
        
        //Check the validity of the validators. This validator is valid
        //but others may not be.
        checkValidity();
    }
}

}