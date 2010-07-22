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
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.events.ViewModelEvent;
import com.fosrias.core.interfaces.ADispatcher;
import com.fosrias.core.interfaces.AFactory;
import com.fosrias.core.namespaces.app_internal;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import mx.events.FlexEvent;
import mx.managers.IFocusManagerComponent;

use namespace app_internal;

[Bindable]
/**
 * The AViewModel class is the base class for presentation models that 
 * do not require validation.
 * 
 * <p>To use this model, inject a dispatcher (typically the view itself, or 
 * alternatively an <code>AManager</code> subclass that has the view as its
 * injected as its dispatcher. By so doing, the presentation model dispatches
 * into the event flow.</p>
 * 
 * @see com.fosrias.core.managers.interfaces.AManager
 * @see com.fosrias.core.managers.interfaces.AStatefulManager
 * @see com.fosrias.core.views.interfaces.AValidatedViewModel
 */
public class AViewModel extends ADispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    //Define any view state constants for the view here.
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
	public function AViewModel(self:AViewModel)
	{
	    super( self );
	}

    //--------------------------------------------------------------------------
    //
    //  Injected Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  helpText
    //----------------------------------
    
    /**
     * @private
     * Storage for the helpText property. 
     */    
    private var _helpText:String;
    
    /**
     * The help text associated with the current view.
     */
    public function get helpText():String
    {
        return _helpText;
    }
    
    /**
     * @private 
     */
    public function set helpText( value:String ):void
    {
       _helpText = value;
    }
    
    //----------------------------------
    //  isDirty
    //----------------------------------
    
    /**
     * @private
     * Storage for the isDirty property. 
     */    
    private var _isDirty:Boolean = false;
    
    /**
     * Whether the current view is dirty or not.
     */
    public function get isDirty():Boolean
    {
    	return _isDirty;
    }
    
    /**
     * @private 
     */
    public function set isDirty(value:Boolean):void
    {
       _isDirty = value;
       dispatchEvent(new Event("dirtyChange"));
    }
    
    //----------------------------------
    //  popUpFactory
    //----------------------------------
    
    /**
     * @private 
     * Storage for the popUpFactory property. 
     */
    private var _popUpFactory:AFactory = null;
    
    /**
     * The popUpFactory for the view. 
     * 
     * <p>Use this as an alternative to injecting a <code>popUpFactory</code> 
     * direclty view into <code>PopUpCanvas</code>, <code>PopUpPanel</code>, or 
     * <code>PopUpTitle</code> subclasses and set up a binding in the view
     * to set is <code>popUpFactory</code> property. This different popUp
     * factories to be injected into a view as a function of state.
     * 
     * @param value The concrete <code>AFactory</code> that creates
     * UIComponents for popUps. 
     */
    public function get popUpFactory():AFactory
    {
        return _popUpFactory;
    }
     
    /**
     * @private
     */    
    public function set popUpFactory( value:AFactory ):void
    {
        _popUpFactory = value;
    }
    
    //----------------------------------
    //  viewIndex
    //----------------------------------
    
    /**
     * @private
     * Storage for the viewIndex property. 
     */    
    protected var _viewIndex:int;
    
    /**
     * The view index. This is a default index that can be bound to
     * navigation containers. 
     */
    public function get viewIndex():int
    {
        return _viewIndex;
    }
    
    /**
     * @private 
     */
    public function set viewIndex(value:int):void
    {
        _viewIndex = value;
    }
    
    //----------------------------------
    //  title
    //----------------------------------
    
    /**
     * @private
     * Storage for the title property. 
     */    
    protected var _title:String;
    
    [Bindable(event="titleChange")]
    /**
     * The title of the current view.
     */
    public function get title():String
    {
        return _title;
    }
    
    /**
     * @private 
     */
    public function set title(value:String):void
    {
       _title = value;
       dispatchEvent(new Event("titleChange"));
    }
    
    //----------------------------------
    //  viewState
    //----------------------------------
    
    /**
     * @private
     * Storage for the viewState property. 
     */    
    protected var _viewState:String;
    
    /**
     * The view state of the current view. 
     * 
     * <p>Always inject or set the <code>viewState</code> last to ensure all 
     * other property changes associated with a  view state change are 
     * set first.
     */
    public function get viewState():String
    {
        return _viewState;
    }
    
    /**
     * @private 
     */
    public function set viewState(value:String):void
    {
       _viewState = value;
       dispatchEvent(new Event("viewStateChange"));
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  data
    //----------------------------------
    
    /**
     * The data to be reported when the <code>setDirty</code> method is called.
     * Override this getter to return the data payload sent by that method.
     */
    protected function get data():Object
    {
    	return raiseImplementationError("getter", "data");
    }
    
    //----------------------------------
    //  isClearEnabled
    //----------------------------------
    
    [Bindable(event="dirtyChange")]
    /**
     * Whether the view is enabled to clear. E.g., this property can be 
     * bound to the <code>enabled</code> property of a "clear" button that 
     * calls the <code>clear</method> of the presentation model.
     * 
     * <p>The getter is abstract and must be overridden in view states 
     * utilizing this property</p>.
     */
    public function get isClearEnabled():Boolean
    {
        return _isDirty;
    }
    
    //----------------------------------
    //  isCloseEnabled
    //----------------------------------
    
    [Bindable(event="viewStateChange")]
    /**
     * Whether the view is enabled to close. E.g., this property can be 
     * bound to the <code>enabled</code> property of a "close" button that 
     * calls the <code>close</method> of the presentation model.
     * 
     * <p>The getter is abstract and must be overridden in view states 
     * utilizing this property</p>.
     * 
     * @default true, unless overridden.
     */
    public function get isCloseEnabled():Boolean
    {
        return true;
    }
    
    //----------------------------------
    //  isExecuteEnabled
    //----------------------------------
    
    [Bindable(event="executeEnabledChanged")]
    /**
     * Whether the view is enabled to execute an action. E.g., this property 
     * can be bound to the <code>enabled</code> property of a "ok" or "update" 
     * button that calls the <code>execute</method> of the presentation model.
     * 
     * <p>The getter is abstract and must be overridden in view states 
     * utilizing this property.</p>
     */
    public function get isExecuteEnabled():Boolean
    {
        return true;
    }
    
    //----------------------------------
    //  isBackEnabled
    //----------------------------------
    
    [Bindable(event="viewStateChange")]
    /**
     * Whether the view is enabled to move "back." E.g., this property can be 
     * bound to the <code>enabled</code> property of a "back" button that 
     * calls the <code>back</method> of the presentation model.
     * 
     * <p>The getter is abstract and must be overridden in view states 
     * utilizing this property.</p>
     */
    public function get isBackEnabled():Boolean
    {
    	return raiseImplementationError("getter", "isBackEnabled");
    }
    
    //----------------------------------
    //  isNextEnabled
    //----------------------------------
    
    [Bindable(event="viewstateChange")]
    /**
     * Whether the view is enabled to move "next." E.g., this 
     * property can be bound to the <code>enabled</code> property 
     * of a "next" button that calls the <code>next</method> of the 
     * presentation model.
     * 
     * <p>The getter is abstract and must be overridden in view states 
     * utilizing this property.</p>
     */
    public function get isNextEnabled():Boolean
    {
    	return raiseImplementationError("getter", "isNextEnabled");
    }
    
    //----------------------------------
    //  isOpenEnabled
    //----------------------------------
    
    [Bindable(event="viewStateChange")]
    /**
     * Whether the view is enabled to open. E.g., this property can be 
     * bound to the <code>enabled</code> property of a "open" button that 
     * calls the <code>open</method> of the presentation model.
     * 
     * <p>The getter is abstract and must be overridden in view states 
     * utilizing this property</p>.
     * 
     * @default true, unless overridden.
     */
    public function get isOpenEnabled():Boolean
    {
        return true;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dispatcher
    //----------------------------------
    
    /**
     * @inheritDoc
     * 
     * <p>Inject or set this property last as it initializes 
     * presentation models.</p>
     */
    override public function set dispatcher( value:IEventDispatcher ):void
    {
        super.dispatcher = value;
        initialize();
    }  

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * A utility method that dispatches a <code>ViewModelEvent.BACK</code> 
     * event.
     *  
     * @param args Optional arguments passed to the <code>data</code> property
     * of the <code>ViewModelEvent</code>.
     */
    public function back(  ... args ):void
    {
        dispatchEvent(new ViewModelEvent(ViewModelEvent.BACK));
    }
    
	/**
	 * A utility method that dispatches a <code>ViewModelEvent.CANCEL</code> 
	 * event.
	 *  
	 * @param args Optional arguments passed to the <code>data</code> property
	 * of the <code>ViewModelEvent</code>.
	 */
	public function cancel( ... args ):void
	{
		dispatchEvent( new ViewModelEvent( ViewModelEvent.CANCEL, args ) );
	}
	
	/**
	 * A utility method that dispatches a <code>ViewModelEvent.CLEAR</code> 
	 * event.
	 *  
	 * @param args Optional arguments passed to the <code>data</code> property
	 * of the <code>ViewModelEvent</code>.
	 */
	public function clear( ... args ):void
	{
		dispatchEvent( new ViewModelEvent( ViewModelEvent.CLEAR, args ) );
	}
	
	/**
     * A utility method that dispatches a <code>ViewModelEvent.CLOSE</code> 
     * event.
     *  
     * @param args Optional arguments passed to the <code>data</code> property
     * of the <code>ViewModelEvent</code>.
     */
    public function close( ... args ):void
    {
        dispatchEvent( new ViewModelEvent( ViewModelEvent.CLOSE, args ) );
    }
    
    /**
     * A utility method that dispatches a <code>ViewModelEvent.CLOSE_HELP</code> 
     * event.
     *  
     * @param args Optional arguments passed to the <code>data</code> property
     * of the <code>ViewModelEvent</code>.
     */
    public function closeHelp( ... args ):void
    { 
        dispatchEvent( new ViewModelEvent( ViewModelEvent.CLOSE_HELP, args) );
    }
    
    /**
     * A utility method that dispatches a VALUE_COMMIT event on an object 
     * if the <code>enter</code> key is pressed.
     * 
     * <p>Use this in a <code>KeyboardEvent</code> handler in the view on
     * components tied to validate presentation model properties that
     * you want validated if the enter key is pressed. E.g. a 
     * <code>TextInput</code> box before it is tabbed out of.</p>
     * 
     * @param event The object to commit.
     * 
     * @return Whether the target is selected or not.
     */
    public final function enterKeyCommit( event:KeyboardEvent, 
        object:Object ):void
    {
        if ( hasEnterKeyCode( event ) && object is IEventDispatcher )
        { 
            object.dispatchEvent( new FlexEvent( FlexEvent.VALUE_COMMIT ) );
        }
    }
    
    /**
     * A utility method that can be called in a view to enable navigation to 
     * the focusComponent if the <code>enter</code> key is pressed.
     * 
     * <p>Use this in a <code>KeyboardEvent</code> handler in the view.</p>
     * 
     * @param event The event triggering the navigation.
     * @param focusComponent
     * 
     * @return Whether the target is selected or not.
     */
    public final function enterKeyNavigation( event:KeyboardEvent, 
        focusComponent:IFocusManagerComponent ):Boolean
    {
        if ( hasEnterKeyCode( event ) )
        { 
            focusComponent.setFocus();
            return true;
        }
        return false;
    }
    
    /**
     * A utility method that dispatches a <code>ViewModelEvent.EXECUTE</code> 
     * event.
     *  
     * @param args Optional arguments passed to the <code>data</code> property
     * of the <code>ViewModelEvent</code>.
     */
    public function execute( ... args ):void
    {
    	if ( isExecuteEnabled )
    	{
            dispatchEvent( new ViewModelEvent( ViewModelEvent.EXECUTE, args ) );
        }
    }
    
    /**
     * A utility method that calls the execute method of the presentation model
     * if the <code>enter</code> or <code>F5</code>key is pressed.
     * 
     * <p>Use this in a <code>KeyboardEvent</code> handler in the view.</p>
     * 
     * @param event The triggering event.
     * @param args Optional arguments that are passed to the exectute method.
     */
    public final function keyExecute( event:KeyboardEvent, ... args ):void
    {
        if ( hasEnterKeyCode( event ) || event.keyCode == Keyboard.F5 )
        { 
            execute( args );
        }
    }
    
    /**
     * A utility method that dispatches a <code>ViewModelEvent.NEXT</code> event.
     *  
     * @param args Optional arguments passed to the <code>data</code> property
     * of the <code>ViewModelEvent</code>.
     */
    public function next(  ... args ):void
    {
        dispatchEvent( new ViewModelEvent( ViewModelEvent.NEXT, args ) );
    }
    
    /**
     * A utility method that dispatches a <code>ViewModelEvent.OPEN_HELP</code> 
     * event.
     *  
     * @param args Optional arguments passed to the <code>data</code> property
     * of the <code>ViewModelEvent</code>.
     */
    public function openHelp(  ... args ):void
    { 
        dispatchEvent( new ViewModelEvent( ViewModelEvent.OPEN_HELP, args ) );
    }
    
    /**
     * A utility method that dispatches a <code>ViewModelEvent.OPEN</code> event.
     *  
     * @param args Optional arguments passed to the <code>data</code> property
     * of the <code>ViewModelEvent</code>.
     */
    public function open(  ... args ):void
    { 
        dispatchEvent( new ViewModelEvent( ViewModelEvent.OPEN, args) );
    }
    
    /**
     * A utility method that can be called in a view to enable navigation to 
     * the focusComponent if the <code>enter</code> key is pressed. The
     * selected property of the dispatching component is toggled if the 
     * enter key is selected. 
     * 
     * <p>Use this in a <code>KeyboardEvent</code> handler in the view.</p>
     * 
     * @param event The event triggering the navigation.
     * @param focusComponent
     * 
     * @return Whether the target is selected or not.
     */
    public final function selectedEnterKeyNavigation( event:KeyboardEvent, 
        focusComponent:IFocusManagerComponent ):Boolean
    {
        if ( hasEnterKeyCode( event ) )
        {
           //Allows toggling of selectable UIComponents (checkBox, 
           //radioButton, etc.)
           return enterKeyNavigation( event, focusComponent ) && 
               !event.target.selected;
        }
        return event.target.selected;
    }
    
    /**
     * A utility method that dispatches a 
     * <code>ViewModelEvent.SET_SUBSTATE</code> event. Use this method to 
     * report the selected index of navidation containers in the view.
     * 
     * @param index The index of the navigation container.
     * @param reference A reference that can be used to differentiate different
     * navigation containers, if multiple navigation containers are used in 
     * a view.
     */
    public function setSubstate( index:int, reference:String = null ):void
    {
        dispatchEvent( new StateEvent( StateEvent.SET_SUBSTATE, index, 
            reference ) );
    }
	
	//--------------------------------------------------------------------------
	//
	//  Namespace methods: app_internal
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Dispatches a ViewModelEvent.DIRTY event with the specified payload.
	 */
	app_internal function reportDirty(data:Object, 
									  reference:String = null):void
	{
		reportDirty(data, reference); 
	}
	
	/**
	 * A utility method to set an object's property to a new value and 
	 * report the object as dirty by dispatching a 
	 * <code>ViewModelEvent.DIRTY</code> event with the new update object
	 * as the <code>data</code> property of the event. 
	 * 
	 * <p>Use it in custom presentation model methods or call it directly in 
	 * the view to report changes in a <code>change</code> or <code>click</code> 
	 * handler, for example.</p>
	 * 
	 * @param object The object whose property has changed.
	 * @param value The new value of the property.
	 * @param property The property.
	 * @param reference A reference passed to the <code>reference</code>
	 * property of the event.
	 */
	app_internal function reportDirtyObject(object:Object, 
											value:Object, 
										    property:String, 
											reference:String = null ):void
	{
		reportDirtyObject(object, value, property, reference);
	}
    
    //--------------------------------------------------------------------------
    //
    //  Protected Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  The <code>initialize</code> method is a hook called in the 
     * <code>dispatcher</code> setter. Override it to set listeners on 
     * validated properties.
     */
    protected function initialize():void
    {
    	//Do nothing unless overridden.
    }
    
    /**
     * Dispatches a ViewModelEvent.DIRTY event with the specified payload.
     */
    protected function reportDirty( data:Object, 
                                    reference:String = null ):void
    {
        dispatchEvent( new ViewModelEvent( ViewModelEvent.DIRTY, data, 
            reference ) );
    }
    
    /**
     * A utility method to set an object's property to a new value and 
     * report the object as dirty by dispatching a 
     * <code>ViewModelEvent.DIRTY</code> event with the new update object
     * as the <code>data</code> property of the event. 
     * 
     * <p>Use it in custom presentation model methods or call it directly in 
     * the view to report changes in a <code>change</code> or <code>click</code> 
     * handler, for example.</p>
     * 
     * @param object The object whose property has changed.
     * @param value The new value of the property.
     * @param property The property.
     * @param reference A reference passed to the <code>reference</code>
     * property of the event.
     */
    protected function reportDirtyObject( object:Object, value:Object, 
        property:String, reference:String = null ):void
    {
        dispatchEvent( new ViewModelEvent( ViewModelEvent.DIRTY, 
           updateObject( object, value, property ), reference ) );
    }
    
    /**
     * A utility method that reports the <code>data</code> property of
     * the presentation model as dirty. 
     * 
     * <p>Examples of use would be as an event listener on presentation model 
     * property set in a sublclass constructor or to dispatch a manually created 
     * <code>ViewModelEvent.DIRTY</code> event in a custom presentation model 
     * method.</p>
     * 
     * @param event The triggering or custom event.
     */
    protected function setDirty( event:Event = null ):void
    {
        if ( event != null ) 
        {
           //Rebroadcast if already a dirty event.
           if ( event.type == ViewModelEvent.DIRTY ) 
           {
               dispatchEvent( event );
               return;
           }
        } 
        dispatchEvent( new ViewModelEvent(ViewModelEvent.DIRTY, this.data ) );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     * 
     * @private
     * All events dispatched in the presentation model are dispatched to the
     * model and its dispatcher.
     */
    override public function dispatchEvent(event:Event):Boolean
    {
    	if ( _dispatcher != null )
    	{
    		_dispatcher.dispatchEvent( event );
    	}
    	return super.dispatchEvent( event );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function hasEnterKeyCode( event:KeyboardEvent ):Boolean
    {
        return event.keyCode == Keyboard.ENTER;
    }
    
    /**
     * @private
     * Updates an object's property to a new value.
     */
    private function updateObject(object:Object, 
								  value:Object, 
        						  property:String):Object
    { 
        /*if ( property == null )
        {
            return object;
        } else if ( !object.hasOwnProperty( property ) ) {
            throw new IllegalOperationError("No '" + property + "' property " + 
                "defined for " + object.toString() + " in " +
                qualifiedClassName );
        }
        object[property] = value;
        return object;*/
		var objectName:String;
		
		if (property == null)
		{
			return object;
		} else if (property.indexOf(".") > 0)  {
			//Check dot-delimited properties
			var obj:Object = object;
			
			var parts:Array = property.split(".");
			var tracedProperty:String = '';
			
			var n:int = parts.length - 1;
			for (var i:int = 0; i < n; i++)
			{
				try
				{
					tracedProperty += parts[i];
					obj = obj[parts[i]];
				}
				catch(error:Error)
				{
					if ( ( error is TypeError ) &&
						( error.message.indexOf( "null has no properties" ) 
							!= -1) )
					{
						objectName =  
							object.hasOwnProperty('qualifiedClassName') ?
							object.qualifiedClassName : object.toString();
						throw new IllegalOperationError("No '" + tracedProperty 
							+ "' property defined for " + objectName + " in " 
							+ qualifiedClassName );
					}
					else
					{                    
						throw error;
					}
				}
			}
			
			//Check the property exists on the last property part
			var part:String = parts[i];
			if (!obj.hasOwnProperty(part)) 
			{
				objectName =  obj.hasOwnProperty('qualifiedClassName') ?
					obj.qualifiedClassName : obj.toString();
				throw new IllegalOperationError("No '" + part 
					+ "' property defined for " + objectName + " in " 
					+ qualifiedClassName );
			}
			obj[part] = value;
			
		} else if (property.indexOf(".") != 0) {
			if ( !object.hasOwnProperty(property) ) 
			{
				objectName =  obj.hasOwnProperty('qualifiedClassName') ?
					obj.qualifiedClassName : obj.toString();
				throw new IllegalOperationError("No '" + property 
					+ "' property defined for " + objectName + " in " 
					+ qualifiedClassName );
			}
			object[property] = value;
		} else {
			raiseImplementationError( 'updateObject', "Property '" + property 
				+ "' invalid.");
		}
		return object;
    }
}

}