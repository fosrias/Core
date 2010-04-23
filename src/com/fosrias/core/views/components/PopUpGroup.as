////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.views.components
{
import com.fosrias.core.events.PopUpLoaderEvent;
import com.fosrias.core.interfaces.AFactory;
import com.fosrias.core.utils.popups.PopUpLoaderManager;
import com.fosrias.core.utils.popups.interfaces.IPopUpComponent;
import com.fosrias.core.views.interfaces.AViewModel;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.utils.Dictionary;

import mx.binding.utils.BindingUtils;
import mx.collections.ArrayCollection;
import mx.containers.Canvas;
import mx.core.UIComponent;

import spark.components.Group;

/**
 * Metadata for destroy event 
 */
[Event(name="destroy", type="flash.events.Event")]

/**
 * The PopUpGroup class is a <code>Canvas</code> subclass with 
 * internal functionality to open popup windows as part of the view. Popup 
 * opening and closing is completely controlled as a function of 
 * the views state ( including its presentation model ) using overridden 
 * protected methods to set the popup types, positions and properties.
 * 
 * <p>To open a popup in subclasses:
 *    <ol>
 *    <li><p>Watch for model property changes associated with the opening of 
 *        the popup. Optional approaches include:
 *         <ul>
 *         <li><p>In a setter or event handler queue any popup to be opened 
 *         or closed based on the new state using the queuePendingPopUps or 
 *         queueClosingPopUps methods. After all popups are queued, call 
 *         addPopUps() and/or removePopUps() at the end of the setter or
 *         handler, depending on the view state and the appropriate 
 *         response.</p></li>
 * 
 *         <li><p>Alternatively, for property change driven popups, use a 
 *         BindingUtils.bindsetter(...) in a preinitialize event handler
 *         and follow the previous steps in the binding setter.</p></li>
 *         <ul></p>
 *    </li>
 *    <li>Override the <code>setPopUpProperties</code> method. This 
 *    determines the initial state of the popup to be opened corresponding to
 *    the current state of the parent view. This method is always passed the 
 *    key and type queued so that blocks can be set for multiple popups
 *    based on the type or key or both using if..then..else and switch 
 *    statments.</p>
 *         <ul>
 *         <li>Specify a different popup close trigger (optional). The 
 *         default is <code>CloseEvent.CLOSE</code>. By specifying a different 
 *         close trigger, the popup can send a close event to a handler 
 *         that can cancel the close or prompt for further intstructions to 
 *         finally close it using the custom close event.</li>
 *         <li>Specify a close handler ( optional only if the view uses an
 *         <code>AViewModel</code> presentation model. If a model 
 *         property is specified for the view, the model.close() method
 *         is the default).<li>
 *         <li>Specify other properties to be set on the popup (optional)
 *         including position, parent it is postioned relative to ( default
 *         is this component), whether it is modal, etc. See the 
 *         <code>setPopUpProperties</code> method for more information.<li>
 *         </ul>
 * 
 *    <li>Override the popUpPositionMementoKey method to specify a key to 
 *    be used to maintain the popup's last position when it is 
 *    removed (optional). The default is null.</li>
 * 
 *    <li>Override the popUpViewState method to set the popup's view state 
 *    when it opens (optional). The default is ''.</li>
 * 
 * @see com.fosrias.core.utils.PopUpLoader
 * @see com.fosrias.core.utils.PopUpLoaderEvent
 * @see com.fosrias.core.utils.PopUpPosition
 * @see com.fosrisa.core.views.PopUpPanel
 * @see com.fosrisa.core.views.PopUpTitleWindow
 * @see com.fosrisa.core.views.StatefulPopUpCanvas
 * @see com.fosrisa.core.views.StatefulPopUpPanel
 * @see com.fosrisa.core.views.StatefulPopUpTitleWindow
 */
public class PopUpGroup extends Group implements IPopUpComponent
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function PopUpGroup()
	{
		super();
		
		//Listen for destroy event from PopUpLoader.
		addEventListener( PopUpLoaderEvent.DESTROY, destroyEventHandler );
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _openChangeWatchers:Array /* Array of ChangeWatcher */ = [];
	
	/**
	 * @private
	 */
	private var _openPopUpSourceMap:Dictionary = new Dictionary;
	
	/**
	 * @private
	 * Constructor includes hook functions into this component.
	 */
	private var _popUpLoaderManager:PopUpLoaderManager 
	= new PopUpLoaderManager( IPopUpComponent( this ), 
		setPopUpPropertiesMaster, getPopUpViewState );
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  openPopUpKeys
	//----------------------------------
	
	/**
	 * A list of open popup keys. Reference only: changing this collection does
	 * not modify popups.
	 */
	public function get openPopUpKeys():ArrayCollection
	{
		return _popUpLoaderManager.openPopUpKeys;
	}
	
	//----------------------------------
	//  popUpFactory
	//----------------------------------
	
	/**
	 * @private 
	 * Storage for the popUpFactory property. 
	 */
	private var _popUpFactory:AFactory = null;
	
	[Bindable]
	/**
	 * The popUpFactory for the view.
	 * 
	 * @param value The popUpFactory.
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
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 * 
	 * <p>Overridding this function requires calling super.commitProperties.</p> 
	 */    
	override protected function commitProperties():void 
	{
		super.commitProperties();
		
		//Necessary to prevent prior versions that have not yet 
		//garbage collected from responding. Popups that are closed
		//directly through interaction with themselves don't gargage
		//collect for some reason until the same popup class is opened
		//again.
		if ( systemManager.contains( this ) )
			callLater( _popUpLoaderManager.addPopUps );
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected Methods
	//
	//--------------------------------------------------------------------------    
	
	/**
	 * Adds all popups qeued for opening. Call this when all popups
	 * have been qeued for the current state of the parent view.
	 * 
	 * @private
	 * Works indirectly with commitProperties() method.
	 */
	protected final function addPopUps():void
	{
		invalidateProperties();
	}
	
	/**
	 * Hook function that can be overridden to add other properties 
	 * automatically. Typically, this is used to extend the class with
	 * fixed properties that are always set in the new class, e.g. decorators,
	 * and override values that may be set in the 
	 * <code>setPopUpProperties</code> method.
	 */
	protected  function afterSetPopUpProperties( key:Object,  
												 type:Object ):void
	{
		//Do nothing 
	}
	
	/**
	 * Hook function that can be overridden to add other properties 
	 * automatically before other properties are set. Typically, this is used 
	 * to extend the class with default properties that are always set in 
	 * the new class, e.g. decorators, but can be overridden in the 
	 * <code>setPopUpProperties</code> method.
	 */
	protected  function beforeSetPopUpProperties( key:Object,  
												  type:Object ):void
	{
		//Do nothing 
	}
	
	/**
	 * A utility method to create binding setters in the component. Use
	 * this method to create binding setters with strong references as
	 * they will be cleared automatically when the component is destroyed
	 * if opened with a PopUpLoader for garbage collecion.
	 */
	protected function bindSetter( setter:Function, host:Object,
								   chain:Object,
								   commitOnly:Boolean = false,
								   useWeakReference:Boolean = false ):void
	{
		_openChangeWatchers.push( BindingUtils.bindSetter( setter, host, chain, 
			commitOnly, useWeakReference ) );
	}
	
	/**
	 * The comparePopUpKeys method is a hook into the setPopUpsByArray and 
	 * setPopUpsByArrayCollection methods. It enables a comparison
	 * to be defined by the propertyName.
	 * 
	 * <p>For example, if the keys need to be equal when they are different
	 * instances with the same value, then that can be set here. The default
	 * is straight equality.</p>
	 */
	protected function comparePopUpKeys( key:Object, comparisonKey:Object, 
										 propertyName:String = null ):Boolean
	{
		return key == comparisonKey;
	}
	
	/**
	 * @private 
	 * Clears the maps when the view is removed from the stage. 
	 */
	protected function destroyEventHandler( event:Event ):void
	{
		//Clear maps
		_popUpLoaderManager.clear();
		for ( var key:* in _openPopUpSourceMap )
		{
			_openPopUpSourceMap[ key ] = null;
			delete _openPopUpSourceMap[ key ];
		} 
		
		//Clear references
		_popUpLoaderManager = null;
		
		//Clear ChangeWatchers
		while ( _openChangeWatchers.length > 0 )
		{
			_openChangeWatchers.pop().unwatch();
		}
		
		removeEventListener( PopUpLoaderEvent.DESTROY, destroyEventHandler );
	}  
	
	/**
	 * Returns an open popup instance by its key.
	 */
	protected final function findOpenPopUp( key:Object ):UIComponent
	{
		return _popUpLoaderManager.findOpenPopUp( key );
	}
	
	/**
	 * Returns the view state of the popup based on the state of this parent
	 * view. This must be overridden to return the view state of the popup. 
	 */
	protected function getPopUpViewState( key:Object, 
										  type:Object):String
	{
		return '';
	}
	
	/**
	 * Queues a loader by key to be removed. Use this function to 
	 * remove popups in handlers that process state changes associated
	 * with the popup. After all popups have been qeued, 
	 * call addPopUps() to remove the popups.
	 */
	protected final function queueClosingPopUp( key:Object ):void 
	{
		if ( _popUpLoaderManager != null )
		{
			_popUpLoaderManager.queueClosingPopUp( key );
		}
	}
	
	/**
	 * Queues a loader by key to be opened. Use this function to 
	 * remove popups in handlers that process state changes associated
	 * with the popup. After all popups have been qeued, call addPopUps() 
	 * to open the popups. 
	 * 
	 * @param The key of the popup.
	 * @param The type of the popup. If null, the key is used as the type.
	 * This can be a type in the popUpFactory
	 * or a UIComponent class to be used as the popup.
	 */
	protected final function queuePendingPopUp( key:Object, 
												type:Object = null ):void 
	{
		_popUpLoaderManager.queuePendingPopUp( key, type ); 
	}
	
	/**
	 * Override this method to set the properties of the popup.
	 * 
	 * <p>For each property or decorator to be added to the popUp or
	 *    its popUpLoader:
	 *     <ul>
	 *     <li><p>Call a separate instance of the <code>setPopUpProperty</code> 
	 *            utility method for each property to be set on the 
	 *            popup. These include any properties on a 
	 *            <code>UIComponent</code>.</p></li>
	 *     <li><p>Call a separate instance of the <code>setLoaderProperty</code> 
	 *            utility method for each property to be set on the loader. 
	 *            Valid properties include:
	 *            <ul>
	 *            <li>closeTrigger</li> 
	 *            <li>closeHandler</li> 
	 *            <li>hasPositionLock</li> 
	 *            <li>hideEvent</li> 
	 *            <li>modal</li> 
	 *            <li>parent</li> 
	 *            <li>position</li> 
	 *            <li>positionMementoKey</li> 
	 *            <li>showEvent</li> 
	 *            <li>size</li> 
	 *            <li>sizeMementoKey</li> 
	 *            </ul></p>
	 *            <p>The viewState of the popup must be set using the 
	 *            <code>getPopUpViewState</code> method. See the
	 *            documentation on the PopUpLoader class for more 
	 *            information.</p></li>
	 *     <li>Call a separate instance of the 
	 *            <code>setLoaderDecorator</code> utility method for each 
	 *            decorator to be applied to the loader.These would be 
	 *            custom decorators.</li>
	 *     <li>Call the <code>setPositionMementoKey</code> utility method 
	 *            for each to maintain position of a popup if it reopens
	 *            after closing.</li>
	 *     <li>Call the <code>setSizeMementoKey</code> utility method 
	 *            for each to maintain the size of a popup if it reopens
	 *            after closing.</li>
	 *     </ul>
	 * </p>  
	 */
	protected function setPopUpProperties( key:Object,  
										   type:Object ):void
	{
		//Set loader decorators
		
		//Set loader properties:   
		//    Override base properties: closeTrigger, closeHandler, 
		//    hasPositionLock, hideEvent, modal, parent, position, and 
		//    showEvent, but not viewState.
		//   
		//Set popup properties:   
		//    Custom popup properties: e.g. model, etc.
	}
	
	/**
	 * Sets the popups by an array of keys. Use this function when multiple
	 * popups are opened based on an array property of the state.
	 * 
	 * @param keyArray The Array of keys for the corresponding popups.
	 * @param type The type of popup. This can be a type in the popUpFactory
	 * or a UIComponent class to be used as the popup.
	 * @param propertyName The name of the property associated with the 
	 * array.
	 */
	protected final function setPopUpsByArray( keyArray:Array,
											   type:Object, 
											   propertyName:String ):void
	{
		//First so closing popups are available to cross reference as 
		//pending popups are added.
		queueClosingPopUpsByArray( keyArray, propertyName );
		queuePendingPopUpsByArray( keyArray, type, propertyName );
		
		//Call these here so closing popups are not added
		removePopUps();
		addPopUps();	
		
		//Update the map
		_openPopUpSourceMap[propertyName] = keyArray.slice();
	}
	
	/**
	 * Sets the popups by a collection of keys. Use this function 
	 * when multiple popups are opened based on an array property of the state.
	 * 
	 * @param keyArray The collection of keys for the corresponding popups.
	 * @param type The type of popup. This can be a type in the popUpFactory
	 * or a UIComponent class to be used as the popup.
	 * @param propertyName The name of the property associated with the 
	 * array.
	 */
	protected final function setPopUpsByCollection( 
		keyCollection:ArrayCollection, type:Object, 
		propertyName:String ):void
	{
		if ( keyCollection == null )
		{
			keyCollection = new ArrayCollection( [] );
		} 
		
		if ( keyCollection.source == null )
		{
			keyCollection.source = [];
		} 
		
		//First so closing popups are available to cross reference as 
		//pending popups are added.
		queueClosingPopUpsByArray( keyCollection.source, propertyName );
		queuePendingPopUpsByArray( keyCollection.source, type, propertyName );
		
		//Call these here so closing popups are not added
		removePopUps();
		addPopUps();    
		
		//Update the map
		_openPopUpSourceMap[propertyName] = keyCollection.source.slice();
	}
	
	/**
	 * Removes all popups qeued for closing. 
	 */
	protected final function removePopUps():void
	{
		if ( _popUpLoaderManager != null )
		{
			_popUpLoaderManager.removePopUps();
		}
	}
	
	/**
	 * Sets the decorator type for any decorators to be applied to the loader.
	 * This method should be used in the setPopUpProperies method
	 * to set individual properties.
	 * 
	 * @param type A string representing the decorator type.
	 * 
	 */    
	protected final function setLoaderDecorator( type:Class, ... args ):void
	{
		_popUpLoaderManager.setLoaderDecorator.apply( null,  
			[ type ].concat( args ) );
	}
	
	/**
	 * Defines properties to be applied to loader and the popup the loader
	 * creates. This method should be used in the setPopUpProperies method
	 * to set individual properties.
	 * 
	 * @param property A string corresponding to the property name.
	 * @param value The value of the property.
	 */    
	protected final function setLoaderProperty( property:String, 
												value:Object ):void
	{
		_popUpLoaderManager.setLoaderProperty( property, value );
	}
	
	/**
	 * Defines properties to be applied to popup. This method should be 
	 * used in the setPopUpProperies method to set individual properties.
	 * 
	 * @param property A string corresponding to the property name.
	 * @param value The value of the property.
	 */    
	protected final function setPopUpProperty( property:String, 
											   value:Object ):void
	{
		_popUpLoaderManager.setPopUpProperty( property, value );
	}
	
	/**
	 * A utility method to change the view state of an open popup.
	 * 
	 * @param key The key corresponding to the popup.
	 * @param state The view state to be set on the popup.
	 */
	protected function setPopUpViewState( key:Object, 
										  state:String  = null ):void
	{
		findOpenPopUp( key ).currentState = state;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Queues any popups for removal whose keys are no longer in the last value
	 * of the associated source array.
	 */
	private function queueClosingPopUpsByArray( keyArray:Array, 
												propertyName:String ):void
	{
		var priorSource:Array = _openPopUpSourceMap[propertyName];
		var keyNotFound:Boolean = true;
		
		for each( var sourceKey:Object in priorSource )
		{
			for each ( var key:Object in keyArray )
			{
				if ( comparePopUpKeys( key, sourceKey ) )
				{
					keyNotFound = false;
					break;
				}
			}
			
			if ( keyNotFound )
			{
				queueClosingPopUp( sourceKey );
			}
			
			//Reset
			keyNotFound = true;
		}
	} 
	
	/**
	 * @private
	 * Queues any popups for opening whose keys are not in the last value
	 * of the associated source array.
	 */
	private function queuePendingPopUpsByArray( keyArray:Array, 
												type:Object, 
												propertyName:String ):void
	{
		var priorSource:Array = _openPopUpSourceMap[propertyName];
		var keyNotFound:Boolean = true;
		
		for each( var key:Object in keyArray )
		{
			for each ( var sourceKey:Object in priorSource )
			{
				if ( comparePopUpKeys( key, sourceKey ) )
				{
					keyNotFound = false;
					break;
				}
			}
			
			if ( keyNotFound )
			{
				queuePendingPopUp( key, type );
			}
			
			//Reset
			keyNotFound = true;
		}
	} 
	
	/**
	 * @private
	 * This is the primary hook function that the PopUpLoaderController
	 * calls.
	 */
	private function setPopUpPropertiesMaster( key:Object,  
											   type:Object ):void
	{
		if ( this.hasOwnProperty( "model" ) )
		{
			var model:Object = this["model"];
			if ( model is AViewModel )
			{
				setLoaderProperty("closeHandler", model.close );
			}
		}
		
		//Hook function for extending class
		beforeSetPopUpProperties( key,  type );
		
		//Call the hook to set the rest of the properties
		setPopUpProperties( key,  type );
		
		//Hook function for extending class
		afterSetPopUpProperties( key,  type );
	}
}
	
}