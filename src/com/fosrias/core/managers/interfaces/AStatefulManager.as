////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.managers.interfaces
{
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.events.ViewModelEvent;
import com.fosrias.core.interfaces.AFactory;
import com.fosrias.core.managers.states.NullState;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.utils.Iterator;
import com.fosrias.core.utils.interfaces.IIterator;
import com.fosrias.core.vos.CallResult;
import com.fosrias.core.vos.Message;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.rpc.Fault;

use namespace app_internal;

[Bindable]
/**
 * The AStateManager class is the base class for all managers that maintain
 * the application model statefully. It implements a State Design pattern using 
 * <code>AState</code> states.
 * 
 * <p>Typically, a package folder should be created for each concrete manager
 * in the com.lt&;yourAppgt&;.managers package. The folder should include the 
 * manager, a manager <code>AStateFactory</code> factory and the concrete 
 * states built by the factory. This approach organizes the application 
 * along the lines of the deep linking paths of states that are registered in 
 * the <code>FragmentManager</code>. Further, it simplifies maintenance 
 * of the application.</p>
 * 
 * @see com.fosrias.core.managers.fragment.FragmentManager
 * @see com.fosrias.core.managers.interfaces.AState
 * @see com.fosrias.core.managers.interfaces.AStateFactory
 * @see com.fosrias.core.views.interfaces.AValidatedViewModel
 * @see com.fosrias.core.views.interfaces.AViewModel
 */
public class AStatefulManager extends AManager
{      
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AStatefulManager( self:AStatefulManager )
    {        
        super( self );
        
        //Initalize state property.
        _state = new NullState( this );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var _initialStateType:String;
    private var _initialParameters:Object;
    
    /**
     * @private 
     * Flag used to monitor if a remote call is pending and has not
     * returned a response. It is used to prevent state changes prior to
     * remote call responses, which would change the handling of the remote
     * call for the state.
     */
    app_internal function get hasPendingRemoteCall():Boolean
    {
        return hasPendingRemoteCall;
    }
    
    /**
     * @private
     */
    app_internal function set hasPendingRemoteCall( value:Boolean ):void
    {
        hasPendingRemoteCall = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  acceptNewChildManager
    //----------------------------------
    
    /**
     * Flag to enable the child manager to be set.
     */
    app_internal var acceptNewChildManager:Boolean = false;
    
    
    //----------------------------------
    //  childManager
    //----------------------------------
    
   /**
     * @private
     * Storage for the childManagerClass property. 
     */
    private var _childManager:AStatefulManager;
    
    /**
     * The child manager of manager. Used to access child
     * states associated with the manager.
     */
    app_internal final function get childManager():AStatefulManager
    {
        return _childManager;
    }
    
    //----------------------------------
    //  hasChildManager
    //----------------------------------
      
    /**
     * Whether the manager has a current child manager.
     */
    public final function get hasChildManager():Boolean
    {
        return childManager != null;
    }
    
    //----------------------------------
    //  hasChildManagerClass
    //----------------------------------
      
    /**
     * Whether the state has a child manager class defined.
     */
    public final function get hasChildManagerClass():Boolean
    {
        return state.hasChildManagerClass;
    }
    
    //----------------------------------
    //  hasInitialState
    //----------------------------------
      
    /**
     * Whether an initial state is set for the manager.
     * 
     * @default <code>false</code>.
     */
    app_internal function get hasInitialState():Boolean
    {
    	return _initialStateType != null && _initialStateType != "";
    }
    
    //----------------------------------
    //  hasResetRequirement
    //----------------------------------
      
    /**
     * @private
     * Storage for hasResetRequirement the property
     */
    private var _hasResetRequirement:Boolean = false;
    
    /**
     * Whether the intial state of the manager should be reset if the 
     * associated view is revisited. Setting this property overriddes 
     * functionality in the <code>FragmentManager</code> that maintains
     * the prior state of the application when processing browser addresses, 
     * in particular, Back and Forward functionality.
     * 
     * @default <code>false</code>.
     */
    app_internal function get hasResetRequirement():Boolean
    {
        return _hasResetRequirement;
    }
    
    //----------------------------------
    //  initialState
    //----------------------------------
      
    /**
     * The intial state of the manager.
     * 
     * @default <code>NullState</code>.
     */
    app_internal function get initialState():AState
    {
        if (hasInitialState) 
        {
            return _stateMap[ _initialStateType ];
        }
        return new NullState( this );
    }
    
    //----------------------------------
    //  messageFactory
    //----------------------------------
    
    /**
     * @private 
     * Storage for the messageFactory property
     */
    private var _messageFactory:AFactory;
    
    /**
     * The message factory for the manager. 
     * 
     * <p>This property is typically injected as a property in the 
     * <code>&lt;ObjectBuilder&gt;</code> <code>tag</code> in the 
     * event map for the manager</p>
     */ 
    public function get messageFactory():AFactory
    {
        return _messageFactory;
    }
    
    /**
     * @private
     */
    public function set messageFactory( value:AFactory ):void
    {
        _messageFactory = value;
    }
    
    //----------------------------------
    //  modelHelpText
    //----------------------------------
    
    /**
     * @private 
     * Storage for the modelHelpText property
     */
    private var _modelHelpText:String = null;
    
    [Bindable(event="helpChange")]
    /**
     * The current help text of the manager state. 
     * 
     * <p>This property is typically injected into a <code>AViewModel</code>
     * presentation model's <code>helpText</code> property.</p>
     */
    public function get modelHelpText():String
    {
        return _modelHelpText;
    }
    
    //----------------------------------
    //  modelIsDirty
    //----------------------------------
    
    /**
     * @private
     * Storage for the modelIsDirty property 
     */
    private var _modelIsDirty:Boolean = false;
    
    [Bindable(event="dirtyChange")]
    /**
     * Whether manager model is dirty or not. 
     * 
     * <p>This property is typically injected into a <code>AViewModel</code>
     * presentation model's <code>isDirty</code> property to indicate 
     * the manager model has changed status.</p>
     */
    public function get modelIsDirty():Boolean
    {
       return _modelIsDirty;
    }
    
    //----------------------------------
    //  modelTitle
    //----------------------------------
    
    [Bindable(event="stateChange")]
    /**
     * The current title of a the manager state.
     * 
     * <p>This property is typically injected into a <code>AViewModel</code>
     * presentation model's <code>title</code> property.</p>
     */
    public function get modelTitle():String
    {
        return state.modelTitle;
    }
    
    //----------------------------------
    //  modelValidatedFields
    //----------------------------------
    
    [Bindable(event="stateChange")]    
    /**
     * An Array strings containing field names to be validated in a 
     * <code>AViewValidateModel</code> presentation model. The field 
     * names should correspond to the <code>sourceName</code> arguments
     * in the presentation model's <code>addValidator</code> methods.
     * 
     * <p>Injecting this Array into a <code>AViewValidateModel</code> 
     * presentation model <code>validatedFields</code> property
     * changes which fields are validated for the current state.</p>
     */
    public function get modelValidatedFields():Array /* Array of String */
    {
        return state.validatedFields;
    }
    
    //----------------------------------
    //  modelViewIndex
    //----------------------------------
    
    [Bindable(event="substateChange")]
    [Bindable(event="stateChange")]
    /**
     * The substate index of the view.
     */
    public function get modelViewIndex():int
    {
        return _state.modelViewIndex;
    }
    
    //----------------------------------
    //  modelViewState
    //----------------------------------
    
    [Bindable(event="stateChange")]
    /**
     * The view state of a <code>AViewModel</code> presentation model. 
     * 
     * <p>This property is typically injected into a <code>AViewModel</code>
     * presentation model's <code>viewState</code> property which 
     * corresponds to view states of <code>UIComponent</code> views 
     * injected with the presentation model.</p>
     */
    public function get modelViewState():String
    {
        return state.modelViewState;
    }
    
    //----------------------------------
    //  registeredStates
    //----------------------------------
    
    /**
     * An iterator of the states mapped in the manager.
     */
    app_internal function get registeredStates():IIterator
    {
    	//Build the iterator source array
    	var states:Array = [];
    	for ( var state:* in _stateMap )
    	{
    		states.push( _stateMap[ state ] );
    	}
    	
    	return new Iterator( states );
    }
    
    //----------------------------------
    //  state
    //----------------------------------
    
    /**
     * @private
     * Storage for the state property 
     */
    private var _state:AState;
    
    /**
     * The current state set in the manager.
     */
    app_internal final function get state():AState
    {
    	return _state;
    }
    
    /**
     * @private
     */
    app_internal final function set state( value:AState ):void
    {
        _state = value;
    }
        
    //----------------------------------
    //  stateFactory
    //----------------------------------
        
    /**
     * @private
     * Storage for the stateFactory propery. 
     */    
    private var _stateFactory:AStateFactory;
    
    /**
     * The <code>AStateFactory</code> subclass that creates the manager states.
     * 
     * <p>Setting this property creates and registers the manager states. If
     * any states exist in the factory with a <code>fragmentSegment</code>, 
     * setting this property ensures that a default child state is also
     * included in the mapping. An error is thrown otherwise.</p>
     */
    public final function get stateFactory():AStateFactory
    {
        return _stateFactory;
    }
    
    public final function set stateFactory( value:AStateFactory ):void
    {
        _stateFactory = value;
        
        //Automatically map the internal states of the manager
        setInternalStates(); 
        
        //Make sure factory contained default child state if it 
        //contained states with fragments and is not a top level manager
        var hasFragmentSegment:Boolean = false;
        var hasDefaultChildState:Boolean = false;
        var state:AState;
        
        for (var stateKey:* in _stateMap)
        {
        	 state = _stateMap[ stateKey ];
        	 if ( state.hasFragmentSegment && !state.isTopLevel )
        	 {
        	 	 hasFragmentSegment = true;
        	 	 if ( state.isDefaultChildState )
        	 	 {
        	 	 	 hasDefaultChildState = true;
        	 	 }
        	 }
        }
        
        //Check for default child state
        if ( hasFragmentSegment && !hasDefaultChildState )
        {
        	throw new IllegalOperationError("No default child state set " + 
        			"in " + qualifiedClassName + ".stateFactory setter for the" 
                    + value.qualifiedClassName + " state factory.");
        			
        }
        
        //Clear the state factory for memory management
        _stateFactory.clear();
                       
        //Register the manager
        registerManager( true );
        
        //Set the initial state of the manager
        if ( hasInitialState )
        {
        	resetInitialState()
        }
        
        //Hook to use after state factory set
        stateFactorySet();
    }
    
    //----------------------------------
    //  stateMap
    //----------------------------------
        
    /**
     * @private
     * Storage for the stateMap propery. 
     */    
    private var _stateMap:Dictionary = new Dictionary( true );
        
    /**
     * The map of the states that can be set in the manager.
     */
    app_internal final function get stateMap():Dictionary
    {
    	return _stateMap;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
   
    /**
     * @inheritDoc
     */
    override public function set dispatcher(value:IEventDispatcher):void
    {
    	super.dispatcher = value;
    	
    	//Listen for show events to re-register manager. Used to register
    	//child managers when a parent state changes a navigator container.
    	dispatcher.addEventListener( FlexEvent.SHOW, reRegisterManager, false, 
    	   0 , true );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
   
    /**
     * Moves to the the previous state by delegating to the current 
     * state's <code>back</code> internal method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.BACK</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public function back( event:ViewModelEvent = null ):void
    {
        state.back( event );
    }
            
    /**
     * Returns arguments to be used in a remote call by returning the current 
     * state's <code>callArguments</code> property by delegating to the 
     * current state. Only call this function to initiate a remote call.
     */
    override public function callArguments( ... args):*
    {
    	//Flags the manager and states that a remote call is in process
    	hasPendingRemoteCall = true;
    	
        return state.callArguments;
    }
    
    /**
     * Handles a remote call fault by delegating to the current 
     * state's <code>callFault</code> internal method.
     * 
     * @param fault The <code>Fault</code> returned by the remote
     * call.
     */
    override public function callFault( fault:Fault, ... args ):*
    {
		super.callFault.apply(null, [fault].concat(args) );
        return state.callFault.apply(null, [fault].concat(args) );
    }
    
    /**
     * Handles a remote call result by delegating to the current 
     * state's <code>callResult</code> internal method.
     * 
     * @param callResult The <code>CallResult</code> returned by the remote
     * call.
     */
    override public function callResult( result:CallResult, ... args ):*
    {
		super.callResult.apply(null, [result].concat(args) );
        return state.callResult.apply(null, [result].concat(args) );
    }
    
    /**
     * Cancels the current state by delegating to the current 
     * state's <code>cancel</code> internal method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.CANCEL</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public function cancel( event:ViewModelEvent = null ):void
    {
        state.cancel( event );
    }
    
    /**
     * Clears the current state by delegating to the current 
     * state's <code>clear</code> internal method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.CLEAR</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public function clear( event:ViewModelEvent = null ):void
    {
        state.clear( event );
    }
    
    /**
     * Closes the current state by delegating to the current 
     * state's <code>close</code> internal method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.CLOSE</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public function close( event:ViewModelEvent = null ):Boolean
    {
        return state.close( event );
    }
    
    /**
     * Closes the current state's help GUI.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.CLOSE_HELP</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public function closeHelp( event:ViewModelEvent = null ):void
    {
        setHelpMessage( null );
    }
    
    /**
     * Executes commands by delegating to the current 
     * state's <code>execute</code> internal method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.CLOSE</code> event and is used in conjunction with 
     * the <code>setDirty</code> method in response to actions in the managers
     * <code>AViewModel</code> presentation model that requires the manager
     * to execute a process, for example, change its state.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public function execute( event:ViewModelEvent = null ):*
    {
        state.execute( event );
    }
    
    /**
     * Moves to the the next state by delegating to the current 
     * state's <code>next</code> internal method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.NEXT</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public function next( event:ViewModelEvent = null ):void
    {
        state.next( event );
    }
    
    /**
     * Opens the current state by delegating to the current 
     * state's <code>open</code> internal method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.OPEN</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public function open( event:ViewModelEvent = null ):Boolean
    {
        return state.open( event );
    }
    
    /**
     * Opens the current state's help GUI.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.OPEN_HELP</code> event. It requires the 
     * <code>messageFactory</code> property to be set for the manager.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public function openHelp( event:ViewModelEvent = null ):void
    {
    	if ( _messageFactory != null )
    	{
    		_messageFactory.create( state.helpTextCode, setHelpMessage );
        }
    }
    
    /**
     * Sets the child manager for the manager if the current state 
     * has a child manager class and the parameter is of the same type of 
     * class.
     *   
     * @param childManager The manager to be added if of the right class.
     */
    public final function setChildManager( 
        childManager:AStatefulManager ):Boolean
    {
    	if ( childManager == null )
    	{ 
    		//Clear the child manager
    	    _childManager = childManager;	
    	    return true;
    	} else if ( hasChildManagerClass && acceptNewChildManager ) {  
    		if (childManager is state.childManagerClass)
    		{
    			//Set the child manager
    			_childManager = childManager;
    			
    			//Moment it gets what its looking for, it stops looking.
    			acceptNewChildManager = false;
    			return true;
    		}
    	}
    	return false;
    }
    
    /**
     * Tracks changes to the manager's presentation model based on the 
     * <code>setDirtyImpl</code> protected method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.DIRTY</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    public final function setDirty( event:ViewModelEvent = null ):Boolean
    {
    	_modelIsDirty = setDirtyImpl(event);

        dispatchEventType("dirtyChange");
    	return _modelIsDirty;
    }
    
    /**
     * Sets the state of the manager by delegating to the current 
     * state's <code>setState</code> internal method.
     * 
     * <p>This method is typically called in a global event listener. By doing
     * this, other states and managers in the application can set this state by
     * dispatching a <code>StateEvent.SET_STATE</code> event. The manager
     * ignores requests for states to be set that are not its mapped states.</p>
     * 
     * @param type The state type to be set.
     * @param parameters An object representing the parameters to be set in
     * the manager as part of setting the new state. Typically, this object 
     * represents the parameters string in the browser address and is set by 
     * the <code>FragmentManager</code>.
     * @return <code>true</code> if the state is set.
     */
    public function setState( type:Object, parameters:Object = null ):Boolean
    {
        return state.setState( type, parameters );
    }

    /**
     * Sets the current state as a substate by delegating to the current 
     * state's <code>setSubstate</code> internal method.
     * 
     * The substate is only updated if the event target or optional argument 
     * dispatcher is the manager's <code>dispatcher</code>.
     * 
     * @param event The event with substate information.
     * @param args Optional arguments that allow the substate to be set
     * directly. There values are needed to be specified: index, reference,
     * and dispatcher in that order. Set event = null to use the optional
     * arguments.
     * 
     * @return <code>true</code> if the substate was set.
     */
    public function setSubstate( event:StateEvent = null, ...args ):Boolean
    {
        if ( event != null )
        {
            return _state.setSubstate( int( event.data ), event.reference, 
                IEventDispatcher( event.target ) );
        } else {
            return _state.setSubstate( args[0], args[1], args[2]);
        }
    } 
    
    /**
     * Montitors other states being set in the system by delegating to 
     * the current state's <code>stateSet</code> internal method.
     * 
     * <p>This method is typically called in a global event listener. By doing
     * this, other states and managers communicate their state to this manager 
     * by dispatching a <code>StateEvent.STATE_SET</code> event.</p>
     * 
     * <p>The default use of this method is to auto-close a state that
     * is set to automatically close (see the <code>AState.stateSet</code> 
     * internal method.</p>
     * 
     * @param event The event with and AState payload
     */
    override public function stateSet(event:StateEvent):void
    {
        state.stateSet(event);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Internal Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Sets the <code>modelServerErrors</code> property.
     * 
     * <p>Typically, called by states that handle a callFault.</p>
     */    
    app_internal function setServerErrors( value:String ):void
    {
        setServerErrors( value );
    }

    /**
     * Resets the current state by delegating to its 
     * <code>reset</code> internal method.
     */
    app_internal final function reset():void
    {
        state.reset();
    } 
    
    /**
     * Postsets the current state by delegating to its 
     * <code>preset</code> internal method.
     */
    app_internal final function postset():void
    {
        state.postset();
    } 
    
    /**
     * Presets the current state by delegating to its 
     * <code>preset</code> internal method.
     */
    app_internal final function preset():void
    {
        state.preset();
    } 
    
    /**
     * Resets the initial state of the manager.
     */
    app_internal final function resetInitialState():Boolean
    {
        return state.setState( _initialStateType, _initialParameters );
    }
    
    /**
     * Sets or clears the modelHelpText property from its related message.
     */
    app_internal function setHelpMessage( value:Message ):void
    {
        if ( value != null)
        {
            _modelHelpText = value.text;
        } else {
           _modelHelpText = null;
        }
        dispatchEventType( "helpChange" );
    }
    
    /**
     * Sets the model dirty status to the value.
     */
    app_internal function updateDirty(value:Boolean):void
    {
        _modelIsDirty = value;
        dispatchEventType("dirtyChange");
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     * Handler to register manager on FlexEvent.SHOW.
     */
    private function reRegisterManager( event:Event ):void
    {
    	registerManager();
    }
    
    /**
     * @private
     * Extends setInternalStates functionality to map substates defined
     * in a state, if any.
     */
    private function setInternalSubstates( state:AState ):void
    {
        if ( state.hasSubstates )
        {
            for each ( var type:String in state.substates )
            {
                registerStates( [ type ] );
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Protected Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Creates and maps states by their type.
     * 
     * @param states An array of state type strings corresponding to 
     * type constants in the <code>stateFactory</code>. Typically, this is
     * the <code>types</code> property of the <code>stateFactory</code>.
     */
    protected function registerStates( states:Array ):void
    {
    	for each ( var type:String in states )
    	{
	    	var state:AState = _stateFactory.create( type, this );
	    	var stateExists:Boolean = _stateMap[type] != null
	    	if ( state != null && !stateExists )
	    	{
		    	_stateMap[ type ] = state;
		    	setInternalSubstates( state );
		    	
	    	} else if ( !stateExists ) {
	    		//May want to remove this so can inject multiple state
	    		//factories.
	    		throw new IllegalOperationError( "No corresponding AState " 
	    				+ "exists for the type " + type
	    				+ " in " + qualifiedClassName + ".registerStates." );
	    	}
    	}
    }
    
    /**
     * A utility method to clear the model dirty state
     */
    protected function resetDirty( isDirty:Boolean = false ):void
    {
        _modelIsDirty = isDirty;
        
        dispatchEventType( "dirtyChange" );
    }
 
    /**
     * Abstract implmentation of the <code>setDirty</code> method. This
     * function must be overridden in concrete implementations to reflect
     * changes to the model.
     * 
     * <p>Typically, this method processes <code>ViewModelEvent.SET_DIRTY</code> 
     * event data property which corresponds to the <code>data</code>
     * property in a <code>AViewModel</code> presentation model. It should
     * return <code>true</code> if the model has changed its dirty status. This
     * method should return true if the model is dirty and false otherwise.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    protected function setDirtyImpl(event:ViewModelEvent = null):Boolean
    {
        return state.setDirty(event);
    }
    
    /**
     * Sets the state type of the initial state of the manager.
     * 
     * <p>This method is typically used in the <code>Constructor</code>. 
     * However, if the initial state is a function of the manager model,
     * use this method in an overridden <code>setInternalStates</code> 
     * method.</p>
     * 
     * @param type A string corresponding to a state type constant defined
     * in the <code>stateFactory</code> of the manager.
     * @param parameters An object representing the initial parameters.
     * @param hasResetRequirement <code>true</code> if a reset is required
     * when the state is accessed by the browser.
     */
    protected function setInitialStateType( type:String, 
        parameters:Object = null, hasResetRequirement:Boolean = false ):void
    {
        _initialStateType = type;
        _initialParameters = parameters;
        _hasResetRequirement = hasResetRequirement;  
    }
    
    /**
     * Sets the states that are registered in the manager. 
     * 
     * <p>Typically, override this function to set an initial state
     * for the manager using the <code>setState</code> method. Call the 
     * <code>setInternalStates</code> method of <code>super</code> in 
     * overridden versions of this method if the standard mapping of 
     * the factory is desired.</p>
     * 
     * <p>If only select states in the manager's <code>stateFactory</code> 
     * are should be set for the manager, call <code>registerStates</code>
     * with an array argument of the select state types as defined in the 
     * manager's <code>stateFactory</code> in the overridden function.</p>
     * 
     * <p>For managers with states that have substates, override the method
     * to set only the top level states. Substates will be automatically
     * mapped as internal states as well.</p>
     */
    protected function setInternalStates():void
    {
    	registerStates(_stateFactory.types);
    }
    
    /**
     * Hook method called in the <code>stateFactory</code> setter that 
     * is called after the <code>stateFactory</code> property is set.
     * 
     */
    protected function stateFactorySet():void
    {
    	//Do nothing unless overridden
    }
}

}