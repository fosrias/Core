////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009-2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils.popups
{
import com.fosrias.core.events.PopUpLoaderEvent;
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.utils.EffectPlayer;
import com.fosrias.core.utils.popups.interfaces.IPopUpLoader;

import flash.display.DisplayObject;
import flash.geom.Point;

import mx.core.Container;
import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.effects.EffectManager;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.events.MoveEvent;
import mx.events.ResizeEvent;
import mx.managers.PopUpManager;

use namespace app_internal;
use namespace mx_internal;

[Bindable]
/**
 * The PopUpLoader is a delegate class that opens a popup and positions 
 * it relative to a parent <code>UIComponent</code> and maintains its position 
 * on the stage. If not parent is specified, it positions the popup relative
 * to the main application.
 */
public class PopUpLoader extends AClass implements IPopUpLoader
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function PopUpLoader( popUp:UIComponent, type:Object )
    {
    	super( this );
    	
    	_popUp = popUp;
    	_type = type;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private var _isResettingPosition:Boolean = false;
    
    /**
     * @private
     */
    private var _oldApplicationWidth:int;
    
    /**
     * @private
     */
    private var _popUp:UIComponent;
    
    /**
     * @private
     */
    private var _popUpRelativeOrigin:Point;
    
    /**
     * @private 
     */
    private var _type:Object;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  closeTrigger
    //----------------------------------
    
    /**
     * @private
     * Storage for the closeTrigger property. 
     */
    private var _closeTrigger:String = Event.CLOSE;
    
    
    /**
     * The close trigger event type the loader listens for on the popup to 
     * initiate closing the popup.
     * 
     * @default <code>Event.CLOSE</code>
     */
    public function get closeTrigger():String
    {
    	return _closeTrigger;
    }
    /**
     * @private
     */
    public function set closeTrigger( value:String ):void
    {
        _closeTrigger = value;
    }
    
    //----------------------------------
    //  closeHandler
    //----------------------------------
    
    /**
     * @private
     * Storage for the closeHandler property. 
     */
    private var _closeHandler:Function;
    
    /**
     * The close event handler the loader calls when a close event occurs
     * on the popup.
     * 
     * @default <code>Event.CLOSE</code>
     */
    public function get closeHandler():Function
    {
        return _closeHandler;
    }
    /**
     * @private
     */
    public function set closeHandler( value:Function ):void
    {
        _closeHandler = value;
    }
    
    //----------------------------------
    //  hasPositionLock
    //----------------------------------
    
    /**
     * @private
     * Storage for the hasPositionLock property. 
     */
    private var _hasPositionLock:Boolean = true;
    
    /**
     * Whether the popup locks its position relative to the application.
     * If true and the application window is resized, it maintains its
     * position.
     */
    public function get hasPositionLock():Boolean
    {
        return _hasPositionLock; 
    }
    
    /**
     * @private
     */
    public function set hasPositionLock( value:Boolean ):void
    {
    	_hasPositionLock = value;
    }
    
    //----------------------------------
    //  hideEvent
    //----------------------------------
    
    /**
     * @private
     * Storage for the hideEvent property. 
     */
    private var _hideEvent:String = FlexEvent.HIDE;
    
    /**
     * The hide event the class listens for to hide the popup. Use 
     * the <code>PopUpEvent.HIDE</code> for popups that need to hide
     * separately than the default. Setting this property has no effect if 
     * the popup is open.
     * 
     * @default <code>FlexEvent.PopUpLoaderEvent</code>
     */
    public function get hideEvent():String
    {
        return _hideEvent;
    }
    
    /**
     * @private
     */
    public function set hideEvent(value:String):void
    {
    	if ( !isOpen )
            _hideEvent = value;
    }
    
    //----------------------------------
    //  isOpen
    //----------------------------------
    
    /**
     * @private
     * Storage for the isOpen property. 
     */
    private var _isOpen:Boolean = false;
    
    /**
     * Whether the popup is open or not.
     */
    public function get isOpen():Boolean
    {
        return _isOpen;
    }
    
    //----------------------------------
    //  key
    //----------------------------------
    
    /**
     * @private
     * Storage for the key property. 
     */
    private var _key:String = null;
    
    /**
     * Unless specifically set, it is a key concatenating the loader parent 
     * <code>className</code> and the popup <code>className</code>. It is 
     * used by <code>PopUpLoaderManager</code> to store position and 
     * size mementos persistently. Set this values for non-unique combinations
     * of parent and popup classes to store the mementos.
     */
    public function get key():String
    {
    	if ( _key == null || _key == '' )
    	{
    	   return _parent.className + _popUp.className;
    	} else {
    		return _key;
    	}
    }
    
    /**
     * @private
     */
    public function set key( value:String ):void
    {
    	_key = value;
    }
    
    //----------------------------------
    //  modal
    //----------------------------------
    
    /**
     * @private
     * Storage for the modal property. 
     */
    private var _modal:Boolean = false;
    
    /**
     * Whether the popup opens in a modal state or note. Setting this value
     * after the <code>open</code> method is called has no effect unless the
     * popup is re-loaded.
     */
    public function get modal():Boolean
    {
        return _modal; 
    }
    
    /**
     * @private
     */
    public function set modal( value:Boolean ):void
    {
        if ( !isOpen )
            _modal = value;
    }
    
    //----------------------------------
    //  parent
    //----------------------------------
    
    /**
     * @private
     * Storage for the parent property. 
     */
    private var _parent:UIComponent;
    
     /**
      * The parent the popup is opened relative to. Setting this property
      * after the popup is open has no effect.
      */
     public function get parent():UIComponent
    {
        return _parent;
    }
    
    /**
     * @private
     */
    public function set parent( value:UIComponent ):void
    {
    	if ( !isOpen )
            _parent = value;
    }
    
    //----------------------------------
    //  popUp
    //----------------------------------
    
    /**
     * The popup instance.
     */
    public function  get popUp():UIComponent
    {
        return _popUp;
    } 
    
    //----------------------------------
    //  position
    //----------------------------------
    
    /**
     * @private
     * Storage for the position property. 
     */
    private var _position:PopUpPosition = new PopUpPosition;
    
    /**
     * The position of the popup. This value only affects the
     * position of the popup when it is initially opened. If the
     * position is abolute. The position point is the global position
     * of the popup.
     */
    public function get position():PopUpPosition
    {
    	if ( _position.isAbsolute )
    	{
    		_position.point = _popUp.localToGlobal( new Point );
    	}
        return _position;
    }
    
    /**
     * @private
     */
    public function set position( value:PopUpPosition ):void
    {
        _position = value;
    }
    
    //----------------------------------
    //  positionMementoKey
    //----------------------------------
    
    /**
     * @private
     * Storage for the positionMementoKey property. 
     */
    private var _positionMementoKey:Object = null;
    
    /**
     * The key used to store a memento of a popup's position. The key
     * should not be instance dependent otherwise, the memento will not
     * be retrieved.
     */
    public function get positionMementoKey():Object
    {
        return _positionMementoKey;
    }
    
    /**
     * @private
     */
    public function set positionMementoKey( value:Object ):void
    {
        _positionMementoKey = value;
    }

    //----------------------------------
    //  showEvent
    //----------------------------------
    
    /**
     * @private
     * Storage for the showEvent property. 
     */
    private var _showEvent:String = FlexEvent.SHOW;
    
    /**
     * The show event the class listens for to hide the popup. Use 
     * the <code>PopUpLoaderEvent.SHOW</code> for popups that need to hide
     * separately than the default. Setting this property has no effect if 
     * the popup is open.
     * 
     * @default <code>FlexEvent.SHOW</code>
     */
    public function get showEvent():String
    {
        return _showEvent;
    }
    
    /**
     * @private
     */
    public function set showEvent(value:String):void
    {
    	if ( !isOpen)
            _showEvent = value;
    }
    
    //----------------------------------
    //  size
    //----------------------------------
    
    /**
     * @private 
     * Storage for the size property 
     */
    private var _size:PopUpSize =null;
    
    /**
     * The size of the loader popup
     */
    public function get size():PopUpSize
    {
    	if( isOpen )
    	{
    		return new PopUpSize( _popUp.width, _popUp.height);
    	}
        return _size;
    }
    
    /**
     * @private
     */
    public function set size( value:PopUpSize ):void
    {
    	_size = value;
    	if( !isOpen)
    	{
            _popUp.width = value.width;
            _popUp.height = value.height;
        }  
    }
    
    //----------------------------------
    //  sizeMementoKey
    //----------------------------------
    
    /**
     * @private
     * Storage for the sizeMementoKey property. 
     */
    private var _sizeMementoKey:Object = null;
    
    /**
     * The key used to store a memento of a popup's size. The key
     * should not be instance dependent otherwise, the memento will not
     * be retrieved.
     */
    public function get sizeMementoKey():Object
    {
        return _sizeMementoKey;
    }
    
    /**
     * @private
     */
    public function set sizeMementoKey( value:Object ):void
    {
        _sizeMementoKey = value;
    }
    
    //----------------------------------
    //  state
    //----------------------------------
    
    /**
     * @private 
     * Storage for the state property 
     */
    private var _state:String = '';
    
    /**
     * The view state of the popup that has been set by the loader. If
     * the popup state is changed by user interaction, it is not necessarily
     * reflected here.
     */
    public function get state():String
    {
        return _state;
    }
    
        /**
     * @private
     */
    public function set state( value:String ):void
    {
        _state = value;
        
        //Do not set before the popup is open
        if ( value != _state && isOpen )
            setPopUpState( _state );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Adds the popUp to the stage. 
     * 
     * @private
     * This is a beast to optimize performance
     */   
    public function addPopUp():void
    {
        //Determine the type of positioning and add the popup
        var parentOrigin:Point;
        if ( _position.hasPoint )
        {
            //Add by position
            //Opens a popup view at the origin specified. If a parent is 
            //specified, the origin is relative to the parent. Otherwise, 
            //it is relative to the stage.
            PopUpManager.addPopUp( _popUp, DisplayObject( 
                FlexGlobals.topLevelApplication ), 
                _modal );
            var origin:Point = _position.point;
            if ( _parent == null || _position.isAbsolute )
            {
                _popUp.move( origin.x, origin.y ); 
            } else {
                parentOrigin = _parent.localToGlobal( new Point );
                _popUp.move( parentOrigin.x + origin.x, parentOrigin.y + 
                    origin.y ); 
            }
        } else {
            
            //Add by alignment
            //Positions a popup window relative to a parent object.
            //If no parent object is specified, it positions the window 
            //relative to the application child <code>MainUI</code> with 
            //an id of mainUI. If no application child <code>MainUI</code> 
            //is so defined, it uses the application itself. If a parent is 
            //specified and the position is null, the popup is centered on 
            //the parent. Otherwise, the popup is aligned relative to 
            //the parent per the position specifications.</p>
            
            var application:UIComponent = UIComponent( 
                FlexGlobals.topLevelApplication );
            
            //If no parent is specified, use the application child mainUI
            //as the parent.
            if ( _parent == null )
            {
                _parent = UIComponent( UIComponent( 
                    application ).getChildByName( "mainUI" ) );
                
                //If no child MainUI is defined, use the application as 
                //the parent
                if ( _parent == null )
                {
                    _parent = UIComponent( application );
                }
            }
            
            //Make sure the application is current before calculating origin
            application.validateNow();
            
            parentOrigin = _parent.localToGlobal(new Point);
            var x:int = 0;
            var y:int = 0;
            var stageWidth:int = application.stage.width;
            var stageHeight:int = application.stage.height;
            
            //Determine the x position of the popUp origin
            switch ( _position.horizontalAlign )
            {
                case PopUpPosition.OUTSIDE_LEFT:
                {
                    x = - _popUp.width - _position.paddingRight;
                    break;
                }
                case PopUpPosition.LEFT:
                {
                    x = _position.paddingLeft;
                    break;
                }
                case PopUpPosition.CENTER:
                {
                    x = ( _parent.width - _popUp.width )/2;
                    break;
                }
                case PopUpPosition.RIGHT:
                {
                    x = + ( _parent.width - _popUp.width ) - 
                        _position.paddingRight;
                    break;
                }
                case PopUpPosition.OUTSIDE_RIGHT:
                {
                    x = + _parent.width + _position.paddingLeft;
                    break;
                }
                default:
                {
                    x = - ( _parent.width - _popUp.width )/2;
                }
            }
            
            //Determine the y stage position
            switch ( _position.verticalAlign )
            {
                case PopUpPosition.ABOVE:
                {
                    y = - _popUp.height - _position.paddingBottom;
                    break;
                }
                case PopUpPosition.TOP:
                {
                    y = _position.paddingTop;
                    break;
                }
                case PopUpPosition.CENTER:
                {
                    y = ( _parent.height - _popUp.height )/2;
                    break;
                }
                case PopUpPosition.BOTTOM:
                {
                    y = + ( _parent.height - _popUp.height ) 
                        - _position.paddingBottom;
                    break;
                }
                case PopUpPosition.BELOW:
                {
                    y = + _parent.height + _position.paddingTop;
                    break;
                }
            }
            
            //Set the relative position of the popup in the stage 
            //coordiate system
            x += parentOrigin.x;
            y += parentOrigin.y;
            
            //Make sure to position on the visible portion of the stage.
            if ( x < 0 )
            {
                x = _position.paddingLeft;
            }
            if ( x > stageWidth )
            {
                x = stageWidth - _popUp.width - _position.paddingRight;
            }
            if ( y < 0 )
            {
                y = _position.paddingTop;
            }
            if ( y > stageHeight )
            {
                y = stageHeight - _popUp.measuredHeight - 
                    _position.paddingBottom;
            }
            
            //Add the popup to the stage
            PopUpManager.addPopUp( _popUp, DisplayObject( 
                FlexGlobals.topLevelApplication ), 
                _modal );
            
            //Set the popup's position
            _popUp.move(x, y);   
        }
        
        //Store the application width if the parent is the application
        if ( _parent == FlexGlobals.topLevelApplication )
        {
            _oldApplicationWidth = _parent.width;
        }
        
        //Hook that sets the state in function that can be overriden for other
        //state setting functions, like dispatching events. It is set here,
        //after the popup is opened so that if it relies on an event map,
        //the map will be instantiated.
        setPopUpState( _state );
        
        //Records the origin of the popup relative to the parent.
        setRelativeOrigin();
        
        //Set close handler
        if ( _closeTrigger != null && _closeHandler != null )
            _popUp.addEventListener( _closeTrigger, _closeHandler, 
                false, 0, true );
        
        //Set application resize handler
        if ( _hasPositionLock )
            FlexGlobals.topLevelApplication.addEventListener( 
                ResizeEvent.RESIZE, resetPosition, false, 0 , true );
        
        //Tracks the location of the popup on the screen
        _popUp.addEventListener( MoveEvent.MOVE, updatePosition, 
            false, 0, true ) ;
        
        //Event listeners hide or show the popup if the parent view is 
        //shown or hidden. This can be used with a parent view in a viewstack
        //to show or hide the popup when the parent view is child of a viewstack 
        //container by having the parent view dispatch a show or hide event
        //in the viewstack's respective show and hide eventhandlers.
        //If the parent view is a viewstack container, this is handled 
        //automatically.
        _parent.addEventListener( _hideEvent, hidePopUp, false, 0, true );
        _parent.addEventListener( _showEvent, showPopUp, false, 0, true );
        
        //Flag the popup as open
        _isOpen = true;
    }
    
    /**
     * Compares whether the types match. 
     *  
     * @param type The type to be compared to the loader's type.
     */
    public function isSameType( type:Object ):Boolean
    {
        return _type == type;
    }
    
    /**
     * Compares a view state string with the loader's state.
     *  
     * @param type The type to be compared.
     * @return Whether the types match. True is returned if they match. 
     * 
     */
    public function isSameState( value:String ):Boolean
    {
        return _state == value;
    }
    
    /**
     * @copy mx.core.UIComponent#localToGlobal
     */
    public function localToGlobal( point:Point ):Point
    {
    	return _popUp.localToGlobal( point );
    }
    
    /**
     * Moves the popup to the new location.
     * 
     * @param x The x location.
     * @param y The y location.
     * 
     */
    public function move( x:Number, y:Number ):void
    {
    	_popUp.move( x, y ); 
    }
    
    /**
     * Removes the popup from the stage.
     */
    public function removePopUp():void
    {   
        //Remove listeners 
		FlexGlobals.topLevelApplication.removeEventListener( ResizeEvent.RESIZE, 
            resetPosition );
            
        _popUp.removeEventListener( MoveEvent.MOVE, updatePosition );

        if ( _closeTrigger != null && _closeHandler != null )
            _popUp.removeEventListener( _closeTrigger, _closeHandler );
        
        _parent.removeEventListener( _hideEvent, hidePopUp );
        _parent.removeEventListener( _showEvent, showPopUp );
        
        //Remove the popup
        closePopUp();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Removes the popup from the stage.  
	 */
	private function closePopUp():void
	{		
		//Hack. In order to prevent a PopUp that has a removedEffect 
		//from flickering because the PopUp is removed and then re-added 
		//to run that type of effect, we play the removedEffect here using the
		//EffectPlayer utility class.
		if ( EffectPlayer.play( _popUp, "removedEffect",
		      destroyPopUp ) == null ) 
        {
            destroyPopUp( null, true );
		}
	}
	
	/**
	 * @private
	 */
	private function destroyPopUp( event:EffectEvent = null, 
	    isVisible:Boolean = false ):void
	{
		//Hide it to prevent any flicker when removed.
		if ( !isVisible )
		    _popUp.visible = false;
		
	    //Remove the event listener
	    if ( event != null )
		    IEventDispatcher( event.target ).removeEventListener( 
		        EffectEvent.EFFECT_END,  destroyPopUp );
		
		//Suspend event handling for effects so you don't replay the 
        //removedEffect when the popUp is removed.
        EffectManager.suspendEventHandling();
        
        //In case popup up is IPopUpComponent, let it know it is being 
        //destroyed
        dispatchDestroy( _popUp );
        
        //Remove the popup
        PopUpManager.removePopUp( _popUp );
        
        //Dispatch removed once more for garbage collection bug
        _popUp.dispatchEvent( new Event( Event.REMOVED ) );
        
        //Restore event handling for effects
        EffectManager.resumeEventHandling();
        
        //Clear the variables
        _popUp = null;
        
        //Flag the popup as closed
        _isOpen = false;
	}
    
    /**
     * @private
     * Dispatchs destroy event in case a child is an IPopUpContainer.
     */
    private function dispatchDestroy( component:UIComponent ):void
    {
        component.dispatchEvent( new PopUpLoaderEvent( 
            PopUpLoaderEvent.DESTROY ) );
        
        if ( component is Container )
        {
            var children:Array = Container( component ).getChildren();
            for each ( var child:Object in children )
            {
                if ( child is UIComponent )
                    dispatchDestroy( UIComponent( child ) );
            }
        }
    }
	
	/**
     * @private
     * Sets the current view state of the popup.
     */
	private function setPopUpState( value:String ):void
	{
		if ( _popUp.hasOwnProperty( "currentState" ) )
        {
            if ( Object( _popUp ).currentState != value )
            {
                Object( _popUp ).currentState = value;
            }
        }
    }
    
    //Hide/Show Handlers
	
	/**
     * @private
     * Hides the popup if a the parent view dispatches a hide event. 
     * 
     * In the latter case, using the hideEffect with an EffectEnd
     * handler in a parent that dispatches a hide event can be used
     * when the parent is in a view stack to hide the popup until the 
     * parent view is visible again.
     * 
     */
    private function hidePopUp( event:Event ):void
    {
        _popUp.visible = false;
    }
    
    /**
     * @private
     * Shows the popup if a the parent view dispatches a show event. 
     * 
     * In the latter case, using the showEffect with an EffectEnd
     * handler in a parent that dispatches a Show event can be used
     * when the parent is in a view stack to show the popup when the 
     * parent view is visible again.
     * 
     */
    private function showPopUp( event:Event ):void
	{
	    _popUp.visible = true;
	}
	
	//Position handlers
	
    /**
     * @private
     * Used on a resize event to keep popups in relative position 
     * on the stage when the browser is resized.
     */
    private function resetPosition( event:Event ):void
    {
    	if ( _popUpRelativeOrigin != null && _popUp != null )
        {
			var application:UIComponent	= UIComponent(
				FlexGlobals.topLevelApplication );
			
        	//Flag so that application moving popup does not reset its
	        //relative status.
	        _isResettingPosition = true;
        
        	//Make sure all properties and positions of display objects
	        //are current before calculating.
			application.validateNow();
        
	        var parentOrigin:Point;
	        var newPosition:Point;
	        
	        //Handle parent according to main application or not.
	         if ( _parent == application )
            {
            	var newApplicationWidth:int = application.width;
            
                //Calculate new effective origin relative to old one
                //since stage is always at (0,0)
                parentOrigin = new Point(newApplicationWidth 
                    - _oldApplicationWidth, 0);
                _oldApplicationWidth = newApplicationWidth;
                
                //Make the origin relative to the effective origin and 
                //only change position in the x direction
                _popUpRelativeOrigin.x += parentOrigin.x;
                
                //Calculate new position
                newPosition = new Point(_popUpRelativeOrigin.x, 
                    _popUpRelativeOrigin.y);
                
            } else {
                parentOrigin = _parent.localToGlobal( new Point );
                newPosition = new Point( _popUpRelativeOrigin.x 
                    + parentOrigin.x, _popUpRelativeOrigin.y + parentOrigin.y )
            } 
            _popUp.move( newPosition.x, newPosition.y );
        }
    }
    
    /**
     * @private
     * Calculates the relative origin of the popup to the parent view origin.
     */
    private function setRelativeOrigin():void
    {
    	//Make sure all properties and positions of display objects
        //are current before calculating.
		FlexGlobals.topLevelApplication.validateNow();  
        
        //Get the parent origing with respect to the stage
        var parentOrigin:Point = _parent.localToGlobal( new Point );
        
        //Initialize the relative origin to the popups current location
        _popUpRelativeOrigin = _popUp.localToGlobal( new Point );
        
        //Make the origin relative to the parent origin
        _popUpRelativeOrigin.x -= parentOrigin.x;
        _popUpRelativeOrigin.y -= parentOrigin.y;
        
        //Reset the initial position the popup opens at if the 
        //parent is hidden and reshown
        _position.point = _popUpRelativeOrigin;   
    }
    
    /**
     * @private 
     * Updates the position of a popup relative to the parent if it is moved.
     */
    private function updatePosition( event:Event ):void
    {
    	//Only updates relative position if popup is directly moved.
    	if ( !_isResettingPosition )
    	{
            setRelativeOrigin();
        }
        _isResettingPosition = false;
    }
}

}