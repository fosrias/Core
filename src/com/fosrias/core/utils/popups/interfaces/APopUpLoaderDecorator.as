package com.fosrias.core.utils.popups.interfaces
{
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.utils.popups.PopUpPosition;
import com.fosrias.core.utils.popups.PopUpSize;

import flash.geom.Point;

import mx.core.UIComponent;

public class APopUpLoaderDecorator extends AClass 
    implements IPopUpLoader
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function APopUpLoaderDecorator( self:APopUpLoaderDecorator, 
	   popUpLoader:IPopUpLoader )
	{
		super( self );
		
        _popUpLoader = popUpLoader;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    protected var _popUpLoader:IPopUpLoader;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  closeTrigger
    //----------------------------------
    
    /**
     * The close trigger event type the loader listens for on the popup to 
     * initiate closing the popup.
     * 
     * @default <code>Event.CLOSE</code>
     */
    public function get closeTrigger():String
    {
        return _popUpLoader.closeTrigger;
    }
    /**
     * @private
     */
    public function set closeTrigger( value:String ):void
    {
        _popUpLoader.closeTrigger = value;
    }
    
    //----------------------------------
    //  closeHandler
    //----------------------------------
    
    /**
     * The close event handler the loader calls when a close event occurs
     * on the popup.
     * 
     * @default <code>Event.CLOSE</code>
     */
    public function get closeHandler():Function
    {
        return _popUpLoader.closeHandler;
    }
    /**
     * @private
     */
    public function set closeHandler( value:Function ):void
    {
        _popUpLoader.closeHandler = value;
    }
    
    //----------------------------------
    //  hasPositionLock
    //----------------------------------
    
    /**
     * Whether the popup locks its position relative to the application.
     * If true and the application window is resized, it maintains its
     * position.
     */
    public function get hasPositionLock():Boolean
    {
        return _popUpLoader.hasPositionLock; 
    }
    
    /**
     * @private
     */
    public function set hasPositionLock( value:Boolean ):void
    {
        _popUpLoader.hasPositionLock = value;
    }
    
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
    public function get hideEvent():String
    {
        return _popUpLoader.hideEvent;
    }
    
    /**
     * @private
     */
    public function set hideEvent(value:String):void
    {
        _popUpLoader.hideEvent = value;
    }
    
    //----------------------------------
    //  isOpen
    //----------------------------------
    
    /**
     * Whether the popup is open or not.
     */
    public function get isOpen():Boolean
    {
        return _popUpLoader.isOpen;
    }
    
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
    public function get key():String
    {
        return _popUpLoader.key;
    }
    
    /**
     * @privat
     */
    public function set key( value:String ):void
    {
    	_popUpLoader.key = value;
    }

    //----------------------------------
    //  modal
    //----------------------------------
    
    /**
     * Whether the popup opens in a modal state or note. Setting this value
     * after the <code>open</code> method is called has no effect unless the
     * popup is re-loaded.
     */
    public function get modal():Boolean
    {
        return _popUpLoader.modal; 
    }
    
    /**
     * @private
     */
    public function set modal( value:Boolean ):void
    {
        _popUpLoader.modal = value;
    }
    
    //----------------------------------
    //  parent
    //----------------------------------
    
    /**
      * The parent the popup is opened relative to. Setting this property
      * after the popup is open has no effect.
      */
     public function get parent():UIComponent
    {
        return _popUpLoader.parent;
    }
    
    /**
     * @private
     */
    public function set parent( value:UIComponent ):void
    {
            _popUpLoader.parent = value;
    }
    
    //----------------------------------
    //  popUp
    //----------------------------------
    
    /**
     * The popup instance.
     */
    public function  get popUp():UIComponent
    {
        return _popUpLoader.popUp;
    } 
    
    //----------------------------------
    //  position
    //----------------------------------
    
    /**
     * The position of the popup. This value only affects the
     * position of the popup when it is initially opened.
     */
    public function get position():PopUpPosition
    {
        return _popUpLoader.position;
    }
    
    /**
     * @private
     */
    public function set position( value:PopUpPosition ):void
    {
        _popUpLoader.position = value;
    }
    
    //----------------------------------
    //  positionMementoKey
    //----------------------------------
    
    /**
     * The key used to store a memento of a popup's position. The key
     * should not be instance dependent otherwise, the memento will not
     * be retrieved.
     */
    public function get positionMementoKey():Object
    {
        return _popUpLoader.positionMementoKey;
    }
    
    /**
     * @private
     */
    public function set positionMementoKey( value:Object ):void
    {
        _popUpLoader.positionMementoKey = value;
    }

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
    public function get showEvent():String
    {
        return _popUpLoader.showEvent;
    }
    
    /**
     * @private
     */
    public function set showEvent(value:String):void
    {
        _popUpLoader.showEvent = value;
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
        return _popUpLoader.size;
    }
    
    /**
     * @private
     */
    public function set size( value:PopUpSize ):void
    {
        _popUpLoader.size = value;
    }
    
    //----------------------------------
    //  sizeMementoKey
    //----------------------------------
    
    /**
     * The key used to store a memento of a popup's size. The key
     * should not be instance dependent otherwise, the memento will not
     * be retrieved.
     */
    public function get sizeMementoKey():Object
    {
        return _popUpLoader.sizeMementoKey;
    }
    
    /**
     * @private
     */
    public function set sizeMementoKey( value:Object ):void
    {
        _popUpLoader.sizeMementoKey = value;
    }
    
    //----------------------------------
    //  state
    //----------------------------------
    
    /**
     * The view state of the popup that has been set by the loader. If
     * the popup state is changed by user interaction, it is not necessarily
     * reflected here.
     */
    public function get state():String
    {
        return _popUpLoader.state;
    }
    
        /**
     * @private
     */
    public function set state( value:String ):void
    {
        _popUpLoader.state = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Adds the popUp to the stage. 
     */   
    public function addPopUp():void
    {
        _popUpLoader.addPopUp();
    }
    
    /**
     * Compares whether the types match. 
     *  
     * @param type The type to be compared to the loader's type.
     */
    public function isSameType( type:Object ):Boolean
    {
        return _popUpLoader.isSameType( type );
    }
    
    /**
     * Compares a view state string with the loader's state.
     *  
     * @param type The type to be compared.
     * @return Whether the types match. True is returned if they match. 
     * 
     */
    public function isSameState( state:String ):Boolean
    {
        return _popUpLoader.isSameState( state );
    }
    
    /**
     * @copy mx.core.UIComponent#localToGlobal
     */
    public function localToGlobal( point:Point ):Point
    {
        return _popUpLoader.localToGlobal( point );
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
        _popUpLoader.move( x, y ); 
    }
    
    /**
     * Removes the popup from the stage.
     */
    public function removePopUp():void
    {   
        _popUpLoader.removePopUp();
    }
}

}