////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.models.interfaces
{
import com.fosrias.core.interfaces.AClass;

import flash.errors.IllegalOperationError;
import flash.events.Event;

import mx.events.ValidationResultEvent;
import mx.validators.IValidatorListener;

[Bindable]
/**
 * The AInputData class is the abstract base class of subclasses that
 * can be used for validating data in <code>AValidatedViewModel</code> 
 * presentation models.
 * 
 * <p>The concrete types are:
 *    <ul>
 *    <li><code>InputCreditCard</code></li>
 *    <li><code>InputDate</code></li>
 *    <li><code>InputDateRange</code></li>
 *    <li><code>InputNumber</code></li>
 *    <li><code>InputText</code></li>
 * </p>
 * 
 * <p>Since each of these implements IValidatorListener, they can be used 
 * as properties in a model or as delegates in a class that is validated in
 * a <code>AValidatedViewModel</code> and their value and error strings can
 * be bound on a component in a view to show the validation.</p>
 * 
 * @see com.fosrias.core.views.interfaces.AValidatedViewModel
 */
public class AInputData extends AClass 
    implements IIsEqual, IValidatorListener
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function AInputData( self:AInputData, required:Boolean = false )
    {
        super( self ); 
        _required = required;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------- 
    
    //----------------------------------
    //  errorString
    //----------------------------------
    
    /**
     * @private 
     * Storage for the errorString property. 
     */    
    protected var _errorString:String = '';
    
    [Bindable(event="errorStringChange")]
    /**
     * @inheritDoc
     * 
     * @private
     * Implements IValidatorListener.
     */    
    public function get errorString():String
    {
        return _errorString;
    }
    
    /**
     * @private
     */
    public function set errorString(value:String):void
    {
        _errorString = value;
        dispatchEvent( new Event( "errorStringChange" ) );
    }
    
    //----------------------------------
    //  required
    //----------------------------------
    
    /**
     * @private 
     * Storage for the required property. 
     */    
    protected var _required:Boolean;
    
    /**
     * @inheritDoc
     * 
     * @private
     * Implements IValidatedData.
     */    
    public function get required():Boolean
    {
        return _required;
    }
    
    //----------------------------------
    //  validationSubField
    //----------------------------------
    
    /**
     * @private 
     * Storage for the validationSubField property. 
     */    
    private var _validationSubField:String
    
    /**
     * @inheritDoc     
     *  
     * @private
     * Implements IValidatorListener.
     */
    public function get validationSubField():String 
    {
        return _validationSubField;
    }
    
    /**
     *  @private
     */
    public function set validationSubField(value:String):void 
    {
        _validationSubField = value;
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
    public function isEqual( value:Object ):Boolean
    {
        return raiseImplementationError("method", "isEqual" );
    }
    
    /**
     * @inheritDoc
     * 
     * @private
     * Implements IValidatorListener.
     */
    public function validationResultHandler( event:ValidationResultEvent ):void
    {
        if ( event.type == ValidationResultEvent.INVALID )
        {
            _errorString = event.message;
        } else {
            _errorString = '';
        }
        
        dispatchEventType( "errorStringChange" );
    }
}

}