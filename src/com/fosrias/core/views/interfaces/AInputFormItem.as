////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.interfaces
{
import com.fosrias.core.models.interfaces.AInputData;

import flash.events.Event;
import flash.events.FocusEvent;

import mx.containers.FormItem;
import mx.containers.FormItemDirection;
import mx.containers.utilityClasses.ConstraintColumn;
import mx.containers.utilityClasses.ConstraintRow;
import mx.containers.utilityClasses.CanvasLayout;
import mx.containers.utilityClasses.IConstraintLayout;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ValidationResultEvent;
import mx.managers.IFocusManagerComponent;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 * Dispatched after a user editing operation is complete. 
 */
[Event(name="change", type="flash.events.Event")]

/**
 * Dispatched after the <code>TextInput</code> loses focus. Since
 * the FormItem base class excludes <code>FocusEvent.FocusOut</code>,
 * this event is added for tracking the focus.
 */
[Event(name="focusLost", type="flash.events.FocusEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Specifies the skin to use for the invalid field indicator. 
 *
 *  @default mx.containers.FormItem.Required
 */
[Style(name="inputStyleName", inherit="no")]

/**
 *  Specifies the skin to use for the invalid field indicator. 
 *
 *  @default mx.containers.FormItem.Required
 */
[Style(name="invalidSkin", type="Class", inherit="no")]


/**
 * The class is the base class for InputFormItems.
 */
public class AInputFormItem extends FormItem
    implements IFocusManagerComponent, IConstraintLayout
{    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AInputFormItem()
    {
       super();
       
       addEventListener( FlexEvent.CREATION_COMPLETE, onComplete );
       
       direction = FormItemDirection.HORIZONTAL;
       
       layoutObject.target = this;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     */
    private var _currentIndicatorSkin:Class = null;

    /**
     * @private 
     */
    protected var inputData:AInputData;
    
    /**
     * @private 
     */
    protected var inputUIComponent:UIComponent;
    
    /**
     * @private 
     */
    private var _indicatorRequired:Boolean = false;
     
    /**
     * @private 
     */
    private var _internalIndicatorSkin:Class = null;
    
    /**
     * @private 
     */
    private var _internalInvalidSkin:Class = null;
    
    /**
     *  @private
     */
    private var layoutObject:CanvasLayout = new CanvasLayout();
    
    /**
     * @private 
     */
    private var _resettingSkin:Boolean = false;
    
    /**
     * @private 
     */
    private var _inputType:Class;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  direction
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    override public function get direction():String
    {   
        return FormItemDirection.HORIZONTAL;
    }
    
    //----------------------------------
    //  errorString
    //----------------------------------
    
    [Bindable (event="errorStringChange")]
    /**
     * @inheritDoc
     */
    override public function get errorString():String
    {   
        return inputData.errorString;
    }
    
    /**
     * @private
     */
    override public function set errorString( value:String ):void
    {
        inputData.errorString = value;
        inputUIComponent.errorString = inputData.errorString;
        
        dispatchEvent( new Event( "requiredChanged" ) );
        dispatchEvent( new Event( "errorStringChange" ) );
    }
    
    //---------------------------------
    //  horizontalScrollPolicy
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    override public function get horizontalScrollPolicy():String
    {
        return "off";
    }
    
    //---------------------------------
    //  required
    //----------------------------------

    /**
     * @private
     * Storage for the required property. 
     */
    private var _required:Boolean = false;
    
    [Bindable (event="errorStringChange")]
    /**
     * @inheritDoc
     */    
    override public function get required():Boolean
    {   
    	return _required;
    }
    
    /**
     *  @private
     */
    override public function set required( value:Boolean ):void
    {
        if ( value != _indicatorRequired )
        {
            _indicatorRequired = value;
            invalidateDisplayList();
            
            dispatchEvent( new Event( "requiredChanged" ) );
        }
    }
    
    //----------------------------------
    //  usePadding
    //----------------------------------
    
    /**
     *  @private
     */
/*    override mx_internal function get usePadding():Boolean
    {
        // We never use padding.
        return false;
    }*/
    
    //---------------------------------
    //  verticalScrollPolicy
    //----------------------------------
    
    /**
     * @inheritDoc
     */
    override public function get verticalScrollPolicy():String
    {
        return "off";
    } 
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  constraintColumns
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the constraintColumns property.
     */
    private var _constraintColumns:Array = [];
    
    [ArrayElementType("mx.containers.utilityClasses.ConstraintColumn")]
    [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintColumn")]
    
    /**
     *  @copy mx.containers.utilityClasses.IConstraintLayout#constraintColumns
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get constraintColumns():Array
    {
        return _constraintColumns;
    }
    
    /**
     *  @private
     */
    public function set constraintColumns(value:Array):void
    {
        if (value != _constraintColumns)
        {
            var n:int = value.length;
            for (var i:int = 0; i < n; i++)
            {
                ConstraintColumn(value[i]).container = this;
            }
            _constraintColumns = value;
            
            invalidateSize();
            invalidateDisplayList();
        }
    }
    
    //----------------------------------
    //  constraintRows
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the constraintRows property.
     */
    private var _constraintRows:Array = [];
    
    [ArrayElementType("mx.containers.utilityClasses.ConstraintRow")]
    [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintRow")]
    
    /**
     *  @copy mx.containers.utilityClasses.IConstraintLayout#constraintRows
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get constraintRows():Array
    {
        return _constraintRows;
    }
    
    /**
     *  @private
     */
    public function set constraintRows(value:Array):void
    {
        if (value != _constraintRows)
        {
            var n:int = value.length;
            for (var i:int = 0; i < n; i++)
            {
                ConstraintRow(value[i]).container = this;
            }
            _constraintRows = value;
            
            invalidateSize();
            invalidateDisplayList();
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function onComplete( event:Event ):void
    {
        inputUIComponent.styleName = getStyle( "inputStyleName" );
        
        inputUIComponent.height = height;
        height += 2;
        
        //Hook to set other properties
        initializeInputComponent();

        inputUIComponent.tabIndex = tabIndex;
        setIndicatorSkin( getStyle( "indicatorSkin" ) );
        setInvalidSkin( getStyle("invalidSkin") );
        
        //The TextInput component as a child
        addChild( inputUIComponent );
        
        //Clear the event listener
        removeEventListener( FlexEvent.CREATION_COMPLETE, onComplete );
    }
    
    /**
     * @private
     */
    private function setIndicator():void
    {
        if ( !_indicatorRequired )
        {
            if ( errorString != '' && _internalInvalidSkin != null )
            {
                setCurrentIndicatorSkin ( _internalInvalidSkin );
            } 
        } else {
            if ( errorString != '' && _internalInvalidSkin != null )
            {
                setCurrentIndicatorSkin( _internalInvalidSkin );
            } else if ( _internalIndicatorSkin != null ) {
                setCurrentIndicatorSkin( _internalIndicatorSkin );
            }
        }  
    }
    
    /**
     * @private
     */
    private function setIndicatorSkin( value:Class ):void
    {
        _internalIndicatorSkin = value;
        invalidateDisplayList();
    }
    
    /**
     * @private
     */
    private function setInvalidSkin( value:Class ):void
    {
        _internalInvalidSkin = value;
        invalidateDisplayList();
    }
    
    /**
     * @private
     */
    private function setUIComponentPosition():void
    {
        inputUIComponent.left = itemLabel.width 
            + Number( getStyle( "paddingLeft" ) )
            + Number( getStyle( "indicatorGap" ) );
            
        //Make room for border
        if ( inputUIComponent.left == 0 )
            inputUIComponent.left = 1
        
        inputUIComponent.right = Number( getStyle( "paddingRight" ) ) + 1;
    }

    /**
     * @private 
     */
    private function valueCommitHandler( event:Event ):void
    {
        inputData.dispatchEvent( event );
    }

    //--------------------------------------------------------------------------
    //
    //  Protected methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Adds listeners to the input data.
     */
    protected function addInputDataListeners():void
    {
        //Update before adding event listeners for future changes.       
        dispatchEvent( new Event( PropertyChangeEvent.PROPERTY_CHANGE ) );
        dispatchEvent( new Event( "errorStringChange" ) );
        
        //Use weak references since cannot control class destruction
        inputData.addEventListener( "errorStringChange", onEvent, false, 
            0, true );
        inputData.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE,
            onEvent, false, 0, true );
    }
    
    /**
     * A handler for the input UIComponent change event. Override this 
     * function to set inputData values. Call super.changeEvent 
     * after setting any values in the overridden handler.
     */
    protected function changeEventHandler( event:Event ):void
    {
        dispatchEvent( event );
    }
    
    /**
     * Initialiailzes the UIComponent. In the body of this function
     * set any initial properties and style overrides for the input UIComponent.
     */
    protected function initializeInputComponent():void
    {
        //Do nothing
    }
    
    /**
     * @private
     * Rebroadcasts an event internally.
     */
    protected function onEvent( event:Event ):void
    {
        dispatchEvent( event );
        
        if ( event.type == "errorStringChange" )
        {
            inputUIComponent.errorString = errorString;
            invalidateDisplayList();
        }
    }
    
    /**
     * Adds listeners to the input data.
     */
    protected function removeInputDataListeners():void
    {
        inputData.removeEventListener( "errorStringChange", onEvent );
        inputData.removeEventListener( PropertyChangeEvent.PROPERTY_CHANGE,
            onEvent );
    }
    
    /**
     * Sets the current indicator skin for the displayIndicator
     * 
     * @param value The class to be set as the indicator
     */
    protected function setCurrentIndicatorSkin( value:Class ):void
    {
        if ( _currentIndicatorSkin != value )
        {	
            _resettingSkin = true;
            
            _currentIndicatorSkin = value;
            
            //Set the indicator skin property
            setStyle( "indicatorSkin", value );
        }
    }
    
    /**
     * Sets the input UIComponent Type
     */
    protected function setUIComponentType( value:Class ):void
    {
        _inputType = value;
        inputUIComponent = new value;
        
        //Listen for change
        inputUIComponent.addEventListener( Event.CHANGE, changeEventHandler, 
            false, 0, true );
        
        //Listen for value commit
        inputUIComponent.addEventListener( FlexEvent.VALUE_COMMIT,
            valueCommitHandler, false, 0, true );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override protected function focusOutHandler( event:FocusEvent ):void
    {
        super.focusOutHandler( event );
        if ( focusManager.getFocus() != inputUIComponent )
        {
            dispatchEvent( new FocusEvent( 'focusLost', event.bubbles, 
                event.cancelable, event.relatedObject ) );
        }
    }
    
    /**
     * @inheritDoc
     */
    override protected function measure():void
    {
        super.measure();
        
        layoutObject.measure();
    }
    
    /**
     * @inheritDoc
     */
    override public function setFocus():void
    {
        if ( stage != null )
        {
            stage.focus = inputUIComponent;
        }
    }
    
    /**
     * @inheritDoc
     * 
     * Overriding must call super.styleChanged.
     */
    override public function styleChanged( styleProp:String ):void
    { 
        super.styleChanged( styleProp );
        
        //Reset internal variables for the following styles.
        switch ( styleProp )
        {
            case "indicatorSkin":
            {
            	if ( !_resettingSkin )
            	{
                    _internalIndicatorSkin = getStyle( "indicatorSkin" )
                         as Class;
                }
                break;
            }
            case "invalidSkin":
            {
                _internalInvalidSkin = getStyle( "invalidSkin" ) as Class;
                break;
            }
        }
        
        if ( styleProp == "styleName" )
        {
            inputUIComponent.styleName = getStyle( "inputStyleName" );
            setIndicatorSkin( getStyle( "indicatorSkin" ) );
            setInvalidSkin( getStyle("invalidSkin") );
        }
    }
    
    /**
     * @inheritDoc
     */
    override protected function updateDisplayList( unscaledWidth:Number, 
        unscaledHeight:Number ):void
    {
         setIndicator();
		if ( _resettingSkin )
		{
		    _required = false;
		} else {
			if ( errorString == null || errorString == "" || 
			     _internalInvalidSkin == null )
			{
			    _required = _indicatorRequired;
			} else {
				_required = true;
			}
		}
        
		super.updateDisplayList( unscaledWidth, unscaledHeight );
        
		if ( _resettingSkin )
		{
			_required = true;
            super.updateDisplayList( unscaledWidth, unscaledHeight );
            _required = _indicatorRequired;
            _resettingSkin = false;
		}
        
        setUIComponentPosition();
        
        layoutObject.updateDisplayList(unscaledWidth, unscaledHeight);
    }
    
    /**
     * @inheritDoc
     * 
     * Implements IValidatorListener.
     */
    override public function validationResultHandler(
        event:ValidationResultEvent):void
    {
        if ( event.type == ValidationResultEvent.INVALID )
        {
           errorString = event.message;
        } else {
            errorString = '';
        }
        dispatchEvent( new Event( "errorStringChange" ) );
    }
}

}