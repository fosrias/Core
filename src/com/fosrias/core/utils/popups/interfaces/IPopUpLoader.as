package com.fosrias.core.utils.popups.interfaces
{
import com.fosrias.core.utils.popups.PopUpPosition;
import com.fosrias.core.utils.popups.PopUpSize;

import flash.events.IEventDispatcher;
import flash.geom.Point;

import mx.core.UIComponent;

public interface IPopUpLoader extends IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * The close trigger event type the loader listens for on the popup to 
     * initiate closing the popup.
     * 
     * @default <code>Event.CLOSE</code>
     */
    function get closeTrigger():String;
    
    /**
     * @private
     */
    function set closeTrigger( value:String ):void;
    
    //----------------------------------
    //  closeHandler
    //----------------------------------
    
    /**
     * The close event handler the loader calls when a close event occurs
     * on the popup.
     * 
     * @default <code>Event.CLOSE</code>
     */
    function get closeHandler():Function;
    
    /**
     * @private
     */
    function set closeHandler( value:Function ):void;
    
    //----------------------------------
    //  hasPositionLock
    //----------------------------------
    
    /**
     * Whether the popup locks its position relative to the application.
     * If true and the application window is resized, it maintains its
     * position.
     */
    function get hasPositionLock():Boolean;
    
    /**
     * @private
     */
    function set hasPositionLock( value:Boolean ):void;
    
    //----------------------------------
    //  hideEvent
    //----------------------------------
    
    /**
     * The hide event the class listens for to hide the popup. Use 
     * the <code>PopUpEvent.HIDE</code> for popups that need to hide
     * separately than the default.
     * 
     * @default <code>FlexEvent.PopUpLoaderEvent</code>
     */
    function get hideEvent():String;
    
    /**
     * @private
     */
    function set hideEvent(value:String):void;
    
    //----------------------------------
    //  isOpen
    //----------------------------------
    
    /**
     * Whether the popup is open or not.
     */
    function get isOpen():Boolean;
    
    //----------------------------------
    //  key
    //----------------------------------
    
    /**
     * Unless specifically set, it is a key concatenating the loader parent 
     * <code>className</code> and the popup <code>className</code>. It is 
     * used by <code>PopUpLoaderManager</code> to store position and 
     * size mementos persistently. Set this values for non-unique combinations
     * of parent and popup classes to store the mementos.
     */
    function get key():String;
    
    /**
     * @private
     */
    function set key( value:String ):void;
    
    //----------------------------------
    //  modal
    //----------------------------------
    
    /**
     * Whether the popup opens in a modal state or note. Setting this value
     * after the <code>open</code> method is called has no effect unless the
     * popup is re-loaded.
     */
    function get modal():Boolean;
    
    /**
     * @private
     */
    function set modal( value:Boolean ):void;
    
    //----------------------------------
    //  parent
    //----------------------------------
    
    /**
     * The parent the popup is opened relative to. Setting this property
     * after the popup is open has no effect.
     */
    function get parent():UIComponent;
    
    /**
     * @private
     */
    function set parent( value:UIComponent ):void;
    
    //----------------------------------
    //  popUp
    //----------------------------------
    
    /**
     * The popup instance.
     */
    function  get popUp():UIComponent;
    
    //----------------------------------
    //  position
    //----------------------------------
    
    /**
     * The position of the popup. This value only affects the
     * position of the popup when it is initially opened.
     */
    function get position():PopUpPosition;
    
    /**
     * @private
     */
    function set position( value:PopUpPosition ):void;
    
    //----------------------------------
    //  positionMementoKey
    //----------------------------------
    
    /**
     * The key used to store a memento of a popup's position. The key
     * should not be instance dependent otherwise, the memento will not
     * be retrieved.
     */
    function get positionMementoKey():Object;
    
    /**
     * @private
     */
    function set positionMementoKey( value:Object ):void;

    //----------------------------------
    //  showEvent
    //----------------------------------
    
    /**
     * The show event the class listens for to hide the popup. Use 
     * the <code>PopUpLoaderEvent.SHOW</code> for popups that need to hide
     * separately than the default.
     * 
     * @default <code>FlexEvent.SHOW</code>
     */
    function get showEvent():String;
    
    /**
     * @private
     */
    function set showEvent(value:String):void;
    
    //----------------------------------
    //  size
    //----------------------------------
    
    /**
     * The size of the loader popup
     */
    function get size():PopUpSize;
    
    /**
     * @private
     */
    function set size( value:PopUpSize ):void;
    
    //----------------------------------
    //  sizeMementoKey
    //----------------------------------
    
    /**
     * The key used to store a memento of a popup's size. The key
     * should not be instance dependent otherwise, the memento will not
     * be retrieved.
     */
    function get sizeMementoKey():Object;
    
    /**
     * @private
     */
    function set sizeMementoKey( value:Object ):void;
    
    //----------------------------------
    //  state
    //----------------------------------
    
    /**
     * The view state of the popup that has been set by the loader. If
     * the popup state is changed by user interaction, it is not necessarily
     * reflected here.
     */
   function get state():String;
    
    /**
     * @private
     */
   function set state( value:String ):void;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Adds the popUp to the stage. 
     */   
   function addPopUp():void;
    
    /**
     * Compares whether the types match. 
     *  
     * @param type The type to be compared to the loader's type.
     */
   function isSameType( type:Object ):Boolean;
    
    /**
     * Compares a view state string with the loader's state.
     *  
     * @param type The type to be compared.
     * @return Whether the types match. True is returned if they match. 
     * 
     */
   function isSameState( state:String ):Boolean;
    
    /**
     * @copy mx.core.UIComponent#localToGlobal
     */
   function localToGlobal( point:Point ):Point;
    
    /**
     * Moves the popup to the new location.
     * 
     * @param x The x location.
     * @param y The y location.
     * 
     */
   function move( x:Number, y:Number ):void;
    
    /**
     * Removes the popup from the stage.
     */
   function removePopUp():void;
}

}