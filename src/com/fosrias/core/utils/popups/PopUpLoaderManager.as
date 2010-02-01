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
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.utils.Builder;
import com.fosrias.core.utils.interfaces.IBuilder;
import com.fosrias.core.utils.popups.interfaces.IPopUpComponent;
import com.fosrias.core.utils.popups.interfaces.IPopUpLoader;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;

/**
 * The PopUpLoaderManager class is a delegate class that manages opening and 
 * closing popups. It maintains the position of a popup on the stage using the 
 * PopUpLoader class as a delegate and can store a memento of the 
 * prior position of a popup by a key so that the popup can re-position
 * itself if it re-opens.
 */
public class PopUpLoaderManager extends AClass
{
	//--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    protected static var loaderKeyToPositionMap:Dictionary = new Dictionary;
    
    /**
     * @private 
     */
    protected static var loaderKeyToSizeMap:Dictionary = new Dictionary;
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private 
     * Retrieves a memento, if any, for the class and key.
     */
    protected static function retrieveMemento( loaderKey:String, 
        mementoKey:Object, dictionary:Dictionary ):*
    {
        var mementoDictionary:Dictionary = dictionary[ loaderKey ];
        if ( mementoDictionary == null )
        {
            return null;
        } else if ( mementoDictionary[ mementoKey ] != null ) {
            
            var memento:* = mementoDictionary[ mementoKey ];
            
            //Clear the dictionary
            mementoDictionary[ mementoKey ] = null;
            delete mementoDictionary[ mementoKey ];
            
            return memento;
        }
        return null;
    }
    
    /**
     * @private 
     * Retrieves a position memento, if any, for the class and key.
     */
    protected static function retrievePositionMemento( loaderKey:String, 
        mementoKey:Object ):PopUpPosition
    {
    	return retrieveMemento( loaderKey, mementoKey, loaderKeyToPositionMap);
    }
    
    /**
     * @private 
     * Retrieves a size memento, if any, for the class and key.
     */
    protected static function retrieveSizeMemento( loaderKey:String, 
        mementoKey:Object ):PopUpSize
    {
        return retrieveMemento( loaderKey, mementoKey, loaderKeyToSizeMap);
    }
    
    /**
     * @private 
     * Stores a position memento, if any, for the class and key.
     */
    protected static function storeMemento( loaderKey:String, 
        mementoKey:Object, memento:Object, dictionary:Dictionary ):void
    {
        var mementoDictionary:Dictionary = dictionary[ loaderKey ];
        if ( mementoDictionary == null )
        {
            mementoDictionary = new Dictionary;
            dictionary[ loaderKey ] = mementoDictionary;
        } 
        
        //Store the memento
        mementoDictionary[ mementoKey ] = memento;
    }
    
    /**
     * @private 
     * Stores a size memento, if any, for the class and key.
     */
    protected static function storePositionMemento( loaderKey:String, 
        mementoKey:Object, memento:Object ):void
    {
        storeMemento( loaderKey, mementoKey, memento, loaderKeyToPositionMap );
    }
    
    /**
     * @private 
     * Stores a size memento, if any, for the class and key.
     */
    protected static function storeSizeMemento( loaderKey:String, 
        mementoKey:Object, memento:Object ):void
    {
    	storeMemento( loaderKey, mementoKey, memento, loaderKeyToSizeMap );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     * 
     * @param parent The component delegating to the PopUpLoaderManager.
     * @param setPropertiesHook A function in the delegating component
     * that is used to set properties and decorators in the PopUpLoaderManager. 
     * It must be of the form setProperties( key:Object, type:Object ):void;
     * @param getViewStateHook A function in the delegating component
     * returns a key to use for a position memento. It must be of the form 
     * getViewState( key:Object, type:Object ):String;
     * 
     */
    public function PopUpLoaderManager( parent:IPopUpComponent, 
        setPropertiesHook:Function, getViewStateHook:Function )
    {
    	super( this );
    	_parent = parent;
    	_setPropertiesHook = setPropertiesHook;
    	_getViewStateHook = getViewStateHook;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private 
     */
    private var _closingPopUps:ArrayCollection = new ArrayCollection;
    
    /**
     * @private 
     */
    private var _getViewStateHook:Function;
    
    /**
     * @private 
     */
    private var _loaderBuilder:IBuilder = new Builder;
    
    /**
     * @private 
     */
    private var _openLoaderMap:Dictionary = new Dictionary( true );
    
    /**
     * @private 
     */
    private var _parent:IPopUpComponent;
    
    /**
     * @private 
     */
    private var _pendingPopUps:ArrayCollection = new ArrayCollection;
    
    /**
     * @private 
     */
    private var _popUpClass:Class;
    
    /**
     * @private 
     */
    private var _popUpBuilder:IBuilder = new Builder;
    
    /**
     * @private 
     */
    private var _popUpTypeMap:Dictionary = new Dictionary( true );
    
    /**
     * @private 
     */
    private var _positionMementoKey:Object = null;
    
    /**
     * @private 
     */
    private var _setPropertiesHook:Function;
    
    /**
     * @private 
     */
    private var _sizeMementoKey:Object = null;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  openPopUpKeys
    //----------------------------------
    
    /**
     * A collection of open popup keys.
     */
    public function get openPopUpKeys():ArrayCollection
    {
    	var source:Array = [];
    	
    	for ( var key:* in _openLoaderMap )
        {
            source.push( key );
        } 
        
        return new ArrayCollection( source );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Adds any queued pending popups to the stage
     */
    public function addPopUps():void
    { 
        var key:Object;
        var type:Object;
        var loader:IPopUpLoader;
        
        while ( _pendingPopUps.length > 0 )
        {
            //Retrieve the pending popUp information
            key = _pendingPopUps.removeItemAt( 0 );
            type = _popUpTypeMap[ key ];
            
            //Initialize loader builder
            _loaderBuilder.setProperty( "parent", _parent );
            _loaderBuilder.setProperty( "state", 
                _getViewStateHook( key, type ) );
            
            //Initialize the popUpBuilder
            _popUpBuilder.factory = _parent.popUpFactory;
            _popUpBuilder.setType( type );
            
            //Set the popup and loader properties and decorators
            _setPropertiesHook( key, type );
                        
            //Finalize the loader builder
            _loaderBuilder.setType( PopUpLoader, _popUpBuilder.create(), type );
            
            //Create the loader
            loader = _loaderBuilder.create(); 
                        
            //Check if a position memento for the popup exists
            var position:PopUpPosition = retrievePositionMemento( loader.key,
                 _positionMementoKey );
                 
            //Set positon from the memento
            if ( position != null )
            {    
                loader.position = position;
            }
            
            //Check if a size memento for the popup exists 
            var size:PopUpSize = retrieveSizeMemento( loader.key,
                 _sizeMementoKey );
            
            //Set size from the memento          
            if ( size != null )
            {
                loader.size = size;
            }
            
            //Register the open loader
            _openLoaderMap[ key ] = loader;
            
            //Clear the builders
            _loaderBuilder.clear();
            _popUpBuilder.clear();
            
            //Clear key references
            _positionMementoKey = null;
            _sizeMementoKey = null;
            
            //Open the popup
            loader.addPopUp();
        }
    }
    
    /**
     * Clears the maps internal variables. This function must be called in a 
     * <code>PopUpLoaderEvent.DESTROY</code> handler in a class that delegates
     * the PopUpLoaderManager to clear references for garbage collection.
     */
    public function clear():void
    {
    	//Clear maps
        clearMap( _popUpTypeMap );
        clearMap( _openLoaderMap );
        
        //Clear all references to the parent UIComponent for garbage 
        //collection
        _getViewStateHook = null;
        _setPropertiesHook = null;
        _parent = null;
    }
    
    /**
     * Returns an open popup by its key.
     */
    public function findOpenPopUp( key:Object ):UIComponent
    {
        var loader:IPopUpLoader = _openLoaderMap[ key ];
        
        if( loader != null )
            return loader.popUp;
            
        return null;
    }
    
    /**
     * Queues a loader by key to be removed. Use this function to 
     * remove popups in handlers that process state changes associated
     * with the popup. After all popups have been qeued, 
     * call invalidateProperties() to remove the popups.
     * 
     */
    public function queueClosingPopUp(key:Object):void 
    {
    	if (_openLoaderMap[key] != null && !_closingPopUps.contains( key) )
    	{
            _closingPopUps.addItem( key );  
        }
        if ( _pendingPopUps.contains( key ) ) 
        {
        	//Clear the pending popup if it has not opened before
        	//a call to close it.
        	while ( _pendingPopUps.contains( key ) )
        	{
        	   _pendingPopUps.removeItemAt( 
        	       _pendingPopUps.getItemIndex( key ) );
        	    
        	   //Clear the map
        	   _popUpTypeMap[ key ] = null;
        	   delete _popUpTypeMap[ key ];
        	}
        }
    }
    
    /**
     * Queues a loader by key to be opened. Use this function to 
     * remove popups in handlers that process state changes associated
     * with the popup. After all popups have been qeued, 
     * call invalidateProperties() to open the popups.
     * 
     */
    public function queuePendingPopUp( key:Object, 
        type:Object = null ):void 
    {
        var popUpLoader:IPopUpLoader = _openLoaderMap[ key ];
        
        if ( popUpLoader == null && !_pendingPopUps.contains( key ) ) 
        {
            //Queue popUpLoader
            _pendingPopUps.addItem( key );
            if ( type == null )
            {
                type = key;
            }
            _popUpTypeMap[ key ] = type;
            
            
        } else if ( popUpLoader != null && popUpLoader.isSameType( type ) ) {
        	
        	//Call to set new popup state
            var state:String = _getViewStateHook( key, type );
            if ( !popUpLoader.isSameState( state ) )
            {
                popUpLoader.state = state;
            }
        } 
    }
        
    /**
     * Removes any popups queued for closing from the stage.
     */
    public function removePopUps():void
    { 
        //Remove each popup in the collection   
        while ( _closingPopUps.length > 0 )
        {
            var key:Object = _closingPopUps.removeItemAt( 0 );
            
            //Retrieve loader
            var loader:IPopUpLoader = _openLoaderMap[ key ];
        
	        if (loader != null)
	        {
	            var type:Object = _popUpTypeMap[ key ];
	            
	            //Clear the loader maps
	            _openLoaderMap[ key ] = null
	            delete _openLoaderMap[ key ];
	            
	            //Clear the type map
	            _popUpTypeMap[ key ] = null;
	            delete _popUpTypeMap[ key ];
	            
	           //Store a memento of the popup position
	           if ( loader.positionMementoKey != null )
	           {
	                storePositionMemento( loader.key, loader.positionMementoKey,
	                    loader.position );
	           }
	           
	           //Store a memento of the popup size
	           if ( loader.sizeMementoKey != null)
	           {
	               storeSizeMemento( loader.key, loader.sizeMementoKey,
	                    loader.size );
	           }
	           
	           //Remove the popup
	           loader.removePopUp();
	        }
        }
    }
    
    /**
     * Sets a decorator to decorate a <code>PopUpLoader</code> instance. 
     * The decorator constructor must take the instance to be decorated 
     * as the first argument and any other arguments must follow the 
     * instance argument as a comma delimited list.
     * 
     * @param type The class of the decorator.
     * @param args A comma separated list of arguments that correspond to 
     * the constructor arguments of the decorator.
     */
    public function setLoaderDecorator( type:Class, ... args ):void
    {
        _loaderBuilder.setDecorator.apply( null, [ type ].concat( args ) );
    }
    
    /**
     * Sets a property on a built <code>PopUpLoader</code> instance. If the 
     * property does not exist an error is thrown when the instance is created.
     * 
     * @param property The name of the property.
     * @param value The value to be set on the property.
     * 
     */
    public function setLoaderProperty( property:String, 
        value:Object ):void
    {
    	if( property == "state" )
        {
            throw new IllegalOperationError("The state of the " 
                + " popup up cannot be set using the setLoaderProperty "
                + "method. Override the getPopUpViewState method "
                + "instead." );
        } else if ( property == "positionMementoKey" ) {
        	
        	_positionMementoKey = value;
        	
        } else if ( property == "sizeMementoKey" ) {
        	
            _sizeMementoKey = value;
        } 
        _loaderBuilder.setProperty( property, value) ;
    }
    
    /**
     * Sets a property on a built popup instance. If the property does not
     * exist an error is thrown when the instance is created.
     * 
     * @param property The name of the property.
     * @param value The value to be set on the property.
     * 
     */
    public function setPopUpProperty( property:String, 
        value:Object ):void
    {
        if( property == "currentState" )
        {
            throw new IllegalOperationError("The currentState of the " 
                + " popup up cannot be set using the setPopUpProperty "
                + "method. Override the getPopUpViewState method "
                + "instead." );
        } 
        _popUpBuilder.setProperty( property, value );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function clearMap( map:Dictionary ):void
    {
        for (var key:* in map)
        {
            map[ key ] = null;
            delete map[ key ];
        }
    }
}

}