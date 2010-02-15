////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.models
{
import com.fosrias.core.models.interfaces.AInputData;
import com.fosrias.core.utils.CoreStringUtils;

import mx.controls.DateField;
import mx.events.PropertyChangeEvent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ResourceBundle("SharedResources")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Specifies the characteristics of the line for the axis.
 *  This style must be an instance of the Stroke class.  
 */
[Style(name="dateFormat", type="core.date", inherit="no")]
	
[Bindable]
/**
 * The InputDate class is a used in MXML views and 
 * <code>AValidatedViewModel</code> presentation models to implement 
 * validation functionality in the view via its presentation model for
 * date fields.
 * 
 * @see com.fosrias.core.models.interfaces.AInputData
 * @see com.fosrias.core.views.interfaces.AValidatedViewModel
 */
public class InputDate extends AInputData
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function InputDate( date:Date = null, text:String = null,
        required:Boolean = false ) 
    {
        super( this, required );
        
        var css:CSSStyleDeclaration = StyleManager.getStyleDeclaration( 
                "InputDate" );
        var format:String = css != null ?
                   css.getStyle( "dateFormat" ) : 
                   null;
        _dateFormat = format != null ?
                   format :
                   this.resourceManager.getString(
                      "SharedResources", "dateFormat");
        this.date = date;
        
        if ( text != null )
            _text = text;  
    }
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //-------------------------------------------------------------------------- 
    
    /**
     * @private 
     */
    private var _dateFormat:String;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------- 
    
    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * A clone of the instance.
     */
    public function get clone():InputDate
    {
    	var clone:InputDate = new InputDate( date, text, required );
    	clone.errorString = errorString;
    	return clone;
    }
     
    //----------------------------------
    //  date
    //----------------------------------
    
    /**
     * @private
     * Storage for the date property 
     */
    private var _date:Date;
    
    /**
     * @inheritDoc
     * 
     * @private
     * Implements IValidatedText.
     */    
    public function get date():Date
    {
    	return _date;
    }
    
    /**
     * @private
     */
    public function set date( value:Date ):void
    {
    	_date = value;
    	
    	if ( _date == null )
    	{
    		_text = null;
    	} else {
    		_text = CoreStringUtils.dateToString( _date, _dateFormat );
    	}
    }
    
    //----------------------------------
    //  text
    //----------------------------------
    
    /**
     * @private
     * Storage for the text property 
     */
    private var _text:String;
    
    /**
     * @inheritDoc
     * 
     * @private
     * Implements IValidatedText.
     */    
    public function get text():String
    {
        return _text;
    }
    
    /**
     * @private
     */
    public function set text( value:String ):void
    {
        _text = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected properties
    //
    //-------------------------------------------------------------------------- 
  
    //----------------------------------
    //  resourceManager
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the resourceManager property.
     */
    private var _resourceManager:IResourceManager 
        = ResourceManager.getInstance();
    
    /**
     *  @private
     *  This metadata suppresses a trace() in PropertyWatcher:
     *  "warning: unable to bind to property 'resourceManager' ..."
     */
    [Bindable("unused")]
    
    /**
     * @copy mx.core.UIComponent#resourceManager
     */
    protected function get resourceManager():IResourceManager
    {
        return _resourceManager;
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
    override public function isEqual( value:Object ):Boolean
    {
    	//Only compare if value is an InputDate
        if( value is InputDate )
        {
          	//Compare the properties
            return value.date.time == date.time;
        }
        return false;
    }
    
    /**
     * Sets the input data state from the state of a <code>DateField</code>.
     * Method must be used if the value is being validated.
     */
    public function setFromDateField( value:DateField ):void
    {
    	date = value.selectedDate;
    	text = value.text;
    	
        //So that binding and validation on PROPERTY_CHANGE work
    	dispatchEventType( PropertyChangeEvent.PROPERTY_CHANGE );
    } 
}

}