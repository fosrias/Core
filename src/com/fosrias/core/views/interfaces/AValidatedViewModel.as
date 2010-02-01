////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009-2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.interfaces
{
import com.fosrias.core.utils.Builder;
import com.fosrias.core.utils.interfaces.IBuilder;
import com.fosrias.core.validators.ModelValidator;
import com.fosrias.core.validators.ServerErrors;

[Bindable]
/**
 * The AValidatedViewModel class is the base class for presentation models that 
 * require validation.
 * 
 * <p>To use this model, inject a dispatcher (typically the view itself, or 
 * alternatively an <code>AManager</code> subclass that has the view as its
 * injected as its dispatcher. By so doing, the presentation model dispatches
 * into the event flow. Further, create validators to monitor properties
 * in the <code>setValidators</code> method.</p>
 * 
 * @see com.fosrias.core.managers.interfaces.AManager
 * @see com.fosrias.core.managers.interfaces.AStatefulManager
 * @see com.fosrias.core.models.inputDate
 * @see com.fosrias.core.models.inputDateRange
 * @see com.fosrias.core.models.inputNumber
 * @see com.fosrias.core.models.inputText
 * @see com.fosrias.core.views.interfaces.AViewModel
 */
public class AValidatedViewModel extends AViewModel
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    //Define any validator source names as static constants here
    
    //Define any view state constants for the view here.
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function AValidatedViewModel( self:AValidatedViewModel )
    {
        super( self );  
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     * All validation is delegated to the model validator.
     */
    private var _modelValidator:ModelValidator = new ModelValidator( 
        AValidatedViewModel( this ) );
    
    /**
     * @private
     *  
     */
    private var _builder:IBuilder = new Builder;
    
    //--------------------------------------------------------------------------
    //
    //  Injected Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  serverErrors
    //----------------------------------
    
    /**
     * The server errors for the model.
     */
    public function set serverErrors( value:ServerErrors ):void
    {
        _modelValidator.setServerErrors( value );
    }
    
    //----------------------------------
    //  validatedFields
    //----------------------------------
    
    /**
     * The array of presentation model property names of 
     * properties that are currently being validated. 
     * 
     * <p>Use this method to activate or de-activate validation on 
     * properties for the current view state of the view.</p>
     * 
     * @param value The array of property names.
     */
    public final function set validatedProperties( 
        value:Array /* Array of String */):void
    {
        _modelValidator.setValidatedSources( value );
    }
    
    //----------------------------------
    //  viewState
    //----------------------------------
    
    /**
     * The view state of the current view. 
     * 
     * <p>Always inject or set the <code>viewState</code> just before 
     * injecting the <code>dispatcher</code> as the last validated presentation 
     * model property, to ensure all other property changes associated with a 
     * view state change are set first.
     */
    override public function set viewState(value:String):void
    {
        super.viewState = value;
        
        //Always validate after view state is injected. This sets 
        //the model validity, but clears any errors since this is
        //typically associated with opening a new view, which if it
        //has required fields are not valid.
        validateModel();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  validationEnabled
    //----------------------------------
    
    /**
     * @private
     * Storage for the validationEnabled property.
     */
    private var _validationEnabled:Boolean = false;
    
    [Bindable(event="modelValidated")]
    /**
     * Whether the presentation model validators are enabled.
     */
    public function get validationEnabled():Boolean
    {
        return _validationEnabled;
    }
    
    /**
     * @private
     */
    public function set validationEnabled( value:Boolean ):void
    {
        _validationEnabled = value;
        
        if( _validationEnabled && dispatcher != null )
        {
            _modelValidator.start();
        } else if ( !_validationEnabled ) {
            _modelValidator.stop();
        }
    }
    
    //----------------------------------
    //  isValidated
    //----------------------------------
    
    [Bindable(event="modelValidated")]
    /**
     * Whether the presentation model is currently validated.
     */
    public function get isValidated():Boolean
    {
        return _modelValidator.isValidated;
    }
    
    //----------------------------------
    //  isValid
    //----------------------------------
    
    [Bindable(event="modelValidated")]
    /**
     * Whether the presentation model is valid or not.
     */
    public function get isValid():Boolean
    {
        return _modelValidator.isValid && 
            !_modelValidator.hasServerErrors;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  isExecuteEnabled
    //----------------------------------
    
    [Bindable(event="modelValidated")]
    /**
     * @inheritDoc
     * 
     * <p>This value is always false if the presentation model is not valid.</p>
     */
    override public function get isExecuteEnabled():Boolean
    {
        return _modelValidator.isValid;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * A utility method that clears the current presentation model validation.
     */
    public function clearValidation():void
    {
        _modelValidator.clearValidation();
    }
    
    /**
     * Destroys all validators. Once this is called there are no validators
     * set on the model and the setValidators method would need to be called
     * to rebuild the validators.
     */
    public function destroyValidators():void
    {
        _modelValidator.destroyValidators();
    }
    
    /**
     * A utility method that restarts validation. 
     */
    public function startValidation():void
    {
        _modelValidator.start();
    }
    
    /**
     * A utility method that stops presentation model validation. The method 
     * <code>startValidation</code> must be called to restart paused validation. 
     */
    public function stopValidation():void
    {
        _modelValidator.stop();
    }
    
    /**
     * A utility method that validates or re-validates the presentation model
     * without clearing the present validation.
     */
    public function validate():void
    {
        _modelValidator.checkValidity();
    }
    
    /**
     * A utility method that clears all validation and validates or 
     * re-validates the presentation model.
     */
    public function validateModel( clearErrors:Boolean = false ):void
    {
        _modelValidator.validateModel( clearErrors );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * A simplified utility method to add a validator when the 
     * basic validator properties are all that are required on the validator.
     * 
     * @param type The class type. This is a constant of the ValidatorFactory
     * class.
     * @param source The presentation model property to validate.
     * @param sourceName The string name of the source property.
     * @param property The property of the source, if any, to validate.
     * @param required Whether the property is required.
     * @param hasServerValidator Whether the object has ServerValidator
     * that validates messages from the server.
     */
    protected function addValidator(type:String, sourceName:String, 
                                    source:Object, property:String, 
                                    required:Boolean = false,
                                    hasServerValidator:Boolean = false):void
    {
        _modelValidator.addValidator( type, sourceName, property, required, 
            hasServerValidator );
    }
    
    /**
     * Creates a validator. This method must be called for a validator
     * to be added to the presentation model validators, unless the validator
     * is created using the <code>addValidator</code> method. This method is the
     * last method to be called in the <code>setValidators</code> method 
     * body after setting validator types, properties, and/or decorators.
     * 
     * @param sourceName The string name of the source. This field
     * supports dot-delimited strings.
     * @param required Whether the property is required.
     * @param hasServerValidator Whether the object has ServerValidator
     * that validates messages from the server.
     */
    protected function setValidator( sourceName:String, 
                                     required:Boolean = false, 
                                     hasServerValidator:Boolean = false ):void
    {
        _modelValidator.buildValidator( _builder, sourceName, 
            hasServerValidator );
    }
    
    /**
     * A utility method to set a decorator on a validator being built.
     *  
     * @param type The class of the decorator.
     * @param args A comma separated list of arguments that correspond to 
     * the constructor arguments of the decorator.
     */
    protected final function setValidatorDecorator( type:Class, 
                                                    ... args ):void
    {
        _builder.setDecorator( type, args );
    }
    
    /**
     * Override this method to set the validators of the presentation model.
     * 
     * <p>Call the <code>addValidator</code> utility method in the body
     * of the method, or for more complicated validators such as 
     * <code>ConfirmationValidator</code> or <code>DateRangeValidator</code>
     * validators, or set more properties than available in the 
     * <code>addValidator</code> method:</p>
     * 
     * <p>For each validated property in the presentation model, 
     *    in the body of the method:
     *     <ol>
     *     <li><p>Call the <code>setTitel</code> 
     *            utility method to set the type of validator.</p></li>
     *     <li><p>Call a separate instance of the <code>setProperty</code> 
     *            utility method for each property to be set on the 
     *            validator.</p></li>
     *     <li><p>Call a separate instance of the  <code>setDecorator</code> 
     *            utility method for each decorator to be applied to the 
     *            validator.</p></li>
     *     <li><p>Call the <code>setValidator</code> utility method to 
     *            add the validator.This method must be after the prior
     *            steps to add the validator.</p></li>
     *     </ol>
     * </p>  
     * 
     */
    protected function setValidators():void
    {
        //Set type
        
        //Set properties
        
        //Set decorators
        
        //Create Validator
        
        //...
    }
    
    /**
     * A utility method to set the type of validator being built.
     *  
     * @param type The class type. This is a constant of the ValidatorFactory
     * class.
     */
    protected final function setValidatorType( type:Object ):void
    {
        _builder.setType( type );
    }
    
    /**
     * A utility method to set the type of validator being built. See the 
     * documentation of the validator type for further information of
     * available properties.
     *  
     * @param property The property to set on the validator.
     * @param value The value of the property.
     */
    protected final function setValidatorProperty( property:String, 
                                                   value:Object):void
    {
        _builder.setProperty( property, value );
    }
    
    /**
     * Updates a validator property corresponding to a particular 
     * <code>sourceName</code> to a new value. Use this in setters to 
     * update validators when a property object instance changes so that 
     * validators continue to function.
     */
    protected function updateValidatorProperty( sourceName:String, 
                                                property:String, 
                                                value:Object ):void
    {
        _modelValidator.updateValidatorProperty( sourceName, property, value );
    }
    
    /**
     * Updates a validator corresponding to a particular <code>sourceName</code> 
     * to a new source. Use this in setters to update validators when 
     * the source object instance changes so that validator listeners 
     * continue to function.
     */
    protected function updateValidatorSources( ... args ):void
    {
        _modelValidator.updateValidatorSources( args );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  The <code>initialize</code> method is a hook called in the 
     * <code>dispatcher</code> setter. Override it to set listeners on 
     * validated properties.
     * 
     * <p>Overriding this method in requires calling super.initialize
     */
    override protected function initialize():void
    {       
        //After other properties are updated.
        setValidators();
        
        if ( _validationEnabled )
        {    
            //Start validation
            startValidation();
            
            //Check if the model is valid
            validateModel( true );
        }
    }
}

}