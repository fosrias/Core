////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.components
{
import com.fosrias.core.models.InputText;
import com.fosrias.core.views.interfaces.AInputFormItem;

import flash.events.Event;

import mx.controls.TextInput;

/**
 * The InputTextFormItem class is a TextInput component in a FormItem 
 * that updates via an InputText instance. This component is used
 * with <code>AValidatedViewModel</code> presentation models for user
 * interaction in validating data.
 * 
 * <p>By setting an invalid skin for the component, an optional invalid
 * symbol can be used to represent errors in the FormItem</p>.
 */
public class InputTextFormItem extends AInputFormItem
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function InputTextFormItem()
    {
        super();
        
        //Define the UIComponent class
        setUIComponentType( TextInput );
        
        //Set the input data and its listeners
        inputData = new InputText;
        
        addInputDataListeners();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  displayAsPassword
    //----------------------------------
    
    /**
     * @private 
     * Storage for the displayAsPassword property. 
     */
    private var _displayAsPassword:Boolean = false;
    
    [Bindable]
    [Inspectable(defaultValue=false, type="Boolean")]
    /**
     * Whether text based implementations should display as a password.
     */
    public function get displayAsPassword():Boolean
    {
        return _displayAsPassword;
    }
    
    /**
     * @private
     */
    public function set displayAsPassword( value:Boolean ):void
    {
        _displayAsPassword = value;
        if( inputUIComponent != null )
            TextInput( inputUIComponent ).displayAsPassword = value;
    }
    
    //----------------------------------
    //  inputText
    //----------------------------------
    
    /**
     * The InputText of the form item.
     */
    public function get inputText():InputText
    {
        return InputText( inputData );
    }
    
    /**
     * @private
     */
    public function set inputText( value:InputText ):void
    {   
        var isChange:Boolean = inputData != value;
        if ( isChange )
            removeInputDataListeners();
        
        inputData = value;
        TextInput( inputUIComponent ).text = InputText( inputData ).text;
        
        if ( isChange )
            addInputDataListeners();
    }
    
    //----------------------------------
    //  text
    //----------------------------------
    
    /**
     * The text.
     */
    public function get text():String
    {
        return InputText( inputData ).text;
    } 
    
    /**
     * @private
     */
    public function set text(value:String):void
    {
        InputText( inputData ).text = value;
        TextInput( inputUIComponent ).text = inputText.text;
    } 
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * inheritDoc
     */
    override protected function changeEventHandler( event:Event ):void
    {
        InputText( inputData ).text = TextInput( inputUIComponent ).text;
        
        super.changeEventHandler( event );
    }
    
    /**
     * inheritDoc
     */
    override protected function initializeInputComponent():void
    {
        TextInput( inputUIComponent ).displayAsPassword = displayAsPassword;
    }   
}

}