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
import com.fosrias.core.interfaces.AClass;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.utils.NullIterator;
import com.fosrias.core.utils.interfaces.IIterator;
import com.fosrias.core.vos.CallResult;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.rpc.Fault;
import mx.utils.StringUtil;

use namespace app_internal;

/**
 * The AState class is the base class for all state subclasses that implement 
 * the State Design pattern in <code>AStatefulManager</code> subclasses. 
 * Concrete implementations of this class are created in an 
 * <code>AStateFactory</code> subclass.
 * 
 * <p>Typically, <code>AState</code> subclasses correspond to view states of 
 * <code>UIComponent</code> views associated with <code>AViewModel</code> 
 * presentation models injected by an associated manager model. Like view 
 * states in a <code>UIComponent</code>, these states can be extended from one 
 * another when different states utililze common functionality.</p>
 * 
 * <p>By setting a <code>fragmentSegment</code> for a state, the browser
 * address will be updated to reflect the address. States that have
 * fragment segments defined should have at least one sibling state with a 
 * fragment segement set to a blank string, which corresponds to the default 
 * state of a browser address. This latter state ensures that a browser address 
 * is hackable one level up in the state tree and is the default child state
 * for the fragment one level up. Multiple default child states 
 * are allowable as long as only one default child state is valid at
 * a time based on the current manager model. See the 
 * <code>FragmentManager</code> documentation for further information.</p>
 * 
 * @see com.fosrias.core.managers.fragment.FragmentManager 
 * @see com.fosrias.core.managers.interfaces.AStateFactory
 * @see com.fosrias.core.managers.interfaces.AStateManager
 * @see com.fosrias.core.views.interfaces.AValidatedViewModel
 * @see com.fosrias.core.views.interfaces.AViewModel
 */
public class AState extends AClass
{    
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * Maps last states so they can be restored if a lastStateMapKey is 
     * defined.
     */
    protected static var stateMementoMap:Dictionary = new Dictionary;
    
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------

    /**
     * The fragment that corresponds to the Home page of the application.
     */
    public static const HOME:String = "";
    
    /**
     * State type that must be used with a single <code>AState</code> concrete
     * subclass that corresponds to the Home page of the application
     * in the main application state factory. The <code>fragmentSegment</code> 
     * set for this state must be the constant <code>HOME</code>.
     */
    public static const HOME_STATE:String 
        = "com.fosrias.core.managers.StateManager.home";
     
    /**
     * State type that must be used with a concrete <code>AState</code> 
     * implementation that extends the <code>HOME_STATE</code> state 
     * but with a null fragment segment in the main application state factory.
     * 
     * <p>This state is set by states that are top level states that require 
     * the Home page to be set along with the state. Such states can 
     * dispatch a <code>StateEvent.SET_STATE</code> event with the constant
     * <code>FragmentManager.HOME_NO_STATE</code> as the 
     * <code>reference</code> property in the <code>presetImp</code> or 
     * <code>resetImp</code> methods of the state.</p>
     */
    public static const HOME_NO_PATH_STATE:String 
        = "com.fosrias.core.managers.StateManager.homeNoPath";
     
    /**
     * State type that must be used with a concrete <code>AState</code> 
     * implementation in the main application state factory that corresponds
     * to the login page of the application when an browser address 
     * corresponds to a <code>AState</code> that requires a session and 
     * the application does not have a session. This state must open or 
     * navigate to the login window of the application. It may or may not 
     * have a fragment defined. Typically it will not.
     */
    public static const LOGIN_STATE:String 
        = "com.fosrias.core.managers.StateManager.login";
    
    /**
     * The path separator in a <code>fragmentSegment</code>.
     */
    public static const PATH_SEPARATOR:String = "/";
    
    /**
     * The parameters separator in a fragment. The string following this
     * separator is a parameter object with properties separated by the
     * constant <code>PROPERTY_SEPARATOR</code>.
     */
    public static const PARAMETERS_SEPARATOR:String = "?";
    
    /**
     * The property separator in a fragment's parameters. This string separates
     * individual properties in the parameters. 
     */
    public static const PROPERTY_SEPARATOR:String = "&";
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function AState( self:AState, type:String, manager:AStatefulManager )
    {
    	super( self );
    	_type = type;
        _manager = manager;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
 
    /**
     * @private 
     * Flag for auto closing. 
     */
    private var _hasAutoClose:Boolean = false;
    
    /**
     * @private 
     */
    private var _stateMementoKeys:ArrayCollection = new ArrayCollection;
    
    /**
     * @private
     * The reference to the state's manager.
     */
    protected var _manager:AStatefulManager;
    
    /**
     * @private 
     */    
    private var _pendingCallTimeout:int;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  browserTitle
    //----------------------------------
      
    /**
     * @private
     * Storage for the browserTitle property. 
     */
    private var _browserTitle:String = null;
    
    /**The browser title associated with the state.
     */
    public function get browserTitle():String
    {
        return _browserTitle;
    }
    
    //----------------------------------
    //  callArguments
    //----------------------------------
        
    /**
     * Returns call arguments to be used in a remote call associated with 
     * the state.
     * 
     * <p>This abstract method must be overridden in concrete implementations of 
     * <code>AState</code> if the <code>callArguments</code> property is 
     * used.</p>
     */
    public function get callArguments():*
    {
        return raiseImplementationError( "getter", "callArguments" ); 
    }
    
    //----------------------------------
    //  childManager
    //----------------------------------
      
    /**
     * The child manager of the state's manager. Used to access child
     * states associated with the manager.
     */
    app_internal final function get childManager():AStatefulManager
    {
        return manager.childManager;
    }
    
    //----------------------------------
    //  childManagerClass
    //----------------------------------
        
    /**
     * @private
     * Storage for the childManagerClass property. 
     */
    private var _childManagerClass:Class;
    
    /**
     * The class type of child manager of child states of current state. 
     * Setting this property with the <code>setChildManagerClass</code> method
     * indicates that this state has child states of that manager that can be
     * used to set the brower address for the application state or the 
     * application state from the browser address.
     */
    public function get childManagerClass():Class
    {
        return _childManagerClass;
    }
    
    //----------------------------------
    //  childStates
    //----------------------------------
      
    /**
     * An iterator of the child states (states of the <code>childManager</code>)
     * of the state.
     */
    app_internal final function get childStates():IIterator
    {
    	if ( hasChildManager )
    	{
    	   return childManager.registeredStates;
    	} else {
    		return new NullIterator;
    	}
    }
    
    //----------------------------------
    //  fragmentSegment
    //----------------------------------
      
    /**
     * @private
     * Storage for the fragmentSegment property. 
     */
    private var _fragmentSegment:String = null;
    
    /**
     * The fragment segment associated with the state, if any. Includes the
     * <code>PATH_SEPARATOR</code> at the beginning.
     */
    public final function get fragmentSegment():String
    {
        if ( _fragmentSegment != null )
        {
            return PATH_SEPARATOR + StringUtil.trim( _fragmentSegment );
        }
        return null;
    }
       
    //----------------------------------
    //  hasBrowserTitle
    //----------------------------------
      
    /**
     * Whether a <code>browserTitle</code> has been set.
     */
    public final function get hasBrowserTitle():Boolean
    {
        return _browserTitle != null;
    }
    
    //----------------------------------
    //  hasChildManager
    //----------------------------------
      
    /**
     * Whether the manager has a current <code>childManager</code>.
     */
    public final function get hasChildManager():Boolean
    {
        return manager.hasChildManager;
    }
    
    //----------------------------------
    //  hasChildManagerClass
    //----------------------------------
      
    /**
     * Whether the state has a <code>childMmanagerClass</code> defined.
     */
    public final function get hasChildManagerClass():Boolean
    {
        return childManagerClass != null;
    }
    
    //----------------------------------
    //  hasFragmentSegment
    //----------------------------------
      
    /**
     * Whether the <code>fragmentSegment</code> property has been set.
     */
    public final function get hasFragmentSegment():Boolean
    {
        return _fragmentSegment != null;
    }
    
    //----------------------------------
    //  hasManagerInitialState
    //----------------------------------
      
    /**
     * Whether an initial state is set for the manager.
     * 
     * @default <code>false</code>.
     */
    app_internal function get hasManagerInitialState():Boolean
    {
        return manager.hasInitialState;
    }
    
    //----------------------------------
    //  hasParameters
    //----------------------------------
      
    /**
     * Whether the state has a <code>parameters</code> property defined.
     */
    public function get hasParameters():Boolean
    {
        return parameters != null;
    }
    
    //----------------------------------
    //  hasPendingRemoteCall
    //----------------------------------
    
    /**
     * @private 
     * Flag used to monitor if a remote call is pending and has not
     * returned a response. It is used to prevent state changes prior to
     * remote call responses, which would change the handling of the remote
     * call for the state.
     */
    protected function get hasPendingRemoteCall():Boolean
    {
        return _manager.hasPendingRemoteCall;
    }
    
    /**
     * @private
     */
    protected function set hasPendingRemoteCall( value:Boolean ):void
    {
        _manager.hasPendingRemoteCall = value;
    }
    
    //----------------------------------
    //  hasResetRequirement
    //----------------------------------
      
    /**
     * Whether the intial state of the manager should be reset if the 
     * associated view is revisited. Used in the <code>FragmentManager</code>
     * to force the resetting of a state to its initial state.
     * 
     * @default <code>false</code>.
     */
    public function get hasResetRequirement():Boolean
    {
        return manager.hasResetRequirement;
    }
    
    //----------------------------------
    //  hasSessionRequirement
    //----------------------------------
      
    /**
     * Whether the state requires a current session.
     * 
     * <p>This value is always <code>false</code> for <code>AState</code>
     * subclasses. If a state requires a session, use the 
     * <code>ASessionState</code> base class or override this property to
     * <code>true</code>.</p>
     */
    public function get hasSessionRequirement():Boolean
    {
        return false;
    }
    
    //----------------------------------
    //  hasSubstates
    //----------------------------------
        
    /**
     * Whether the state has substates.
     */
    public function get hasSubstates():Boolean
    {
        return substates.length > 0;
    }
    
    //----------------------------------
    //  hasValidSession
    //----------------------------------
      
    /**
     * Whether the state has a valid session.
     * 
     * </p>If the state is not an <code>ASessionState</code> sublclass or
     * overridden to behave like one, it always returns <code>true</code>.</p>
     */
    public function get hasValidSession():Boolean
    {
    	if ( hasSessionRequirement )
    	{
    		return manager.hasSession;
    	}
        return true;
    }
    
    //----------------------------------
    //  helpTextCode
    //----------------------------------
        
    /**
     * @private
     * Storage for the helpText property 
     */
    private var _helpTextCode:String;
    
    /**
     * Returns a message code associated with the help message, if any. 
     * Requires setting a code using the <code>setHelpTextCode</code> 
     * protected method in the constructor.
     * 
     * <p>If different help text messages are possible for a state, override
     * the <code>helpTextCode</code> getter accordingly.</p>
     */
    public function get helpTextCode():String
    {
    	return _helpTextCode;
    }
    
    //----------------------------------
    //  isCurrent
    //----------------------------------
    
    /**
     * Whether the state is the current state of its manager.
     */
    public function get isCurrent():Boolean
    {
    	return manager.state == this;
    }
    
    //----------------------------------
    //  isDefaultChildState
    //----------------------------------
    
    /**
     * @private
     * Storage for the isDefaultChildState property.
     */
    private var _isDefaultChildState:Boolean = false;
    
    /**
     * Whether the state is a default child state. This corresponds to a 
     * state with a <code>FragmentSegment</code> that is the 
     * <code>PATH_SEPARATOR</code> and is not a top-level state.
     */
    public function get isDefaultChildState():Boolean
    {
        return _isDefaultChildState;
    }
    
    //----------------------------------
    //  isTopLevel
    //----------------------------------
        
    /**
     * @private
     * Storage for the isTopLevel property. 
     */     
    private var _isTopLevel:Boolean = false;
    
    /**
     * Whether the state corresponds to a top-level segment and 
     * the <code>fragmentSegment</code> property has been set.
     * 
     * <p>Top-level states must specify a <code>ChildManagerClass</code>
     * in the constructor if a child manager has states that have a 
     * <code>fragmentFragment</code> and are accessible from the view 
     * associated with the top-level state.</p>
     */
    public final function get isTopLevel():Boolean
    {
        return _isTopLevel && hasFragmentSegment;
    }
    
    //----------------------------------
    //  isValid
    //----------------------------------
        
    /**
     * Whether the state is valid. 
     * 
     * <p>This value is used as a pre-condition to setting the state in the 
     * <code>setState</code> method. Override this value to specify 
     * custom pre-conditions for setting this state.</p>
     * 
     * <p>The return value must include the <code>isValid</code> property of 
     * <code>super</code> if the <code>isValid</code> method is overridden, 
     * which maintains session validation and <code>isInvalidImpl</code> 
     * method implementation for the state. Typically this getter would not
     * be overridden and instead the <code>isInvalidImpl</code> 
     * method would be overridden with the validation logic.</p>
     */
    public function get isValid():Boolean
    {
        return hasValidSession && !isInvalidImpl();
    }
    
    //----------------------------------
    //  manager
    //----------------------------------
    
    /**
     * Internal accessors to the state's manager.
     */
    app_internal function get manager():AStatefulManager
    {
        return _manager;
    }
    
    //----------------------------------
    //  managerInitialState
    //----------------------------------
    
    /**
     * The intial state of the manager.
     * 
     * @default <code>NullState</code>.
     */
    app_internal function get managerInitialState():AState
    {
        return manager.initialState;
    }
    
    //----------------------------------
    //  managerStateType
    //----------------------------------
       
    /**
     * The type of the current manager state.
     */
    public function get currentStateType():String
    {
        return manager.state.type;
    }
    
    //----------------------------------
    //  modelTitle
    //----------------------------------
     
    /**
     * @private 
     * Storage for the modelTitle property. 
     */
    private var _modelTitle:String;
    
    /**
     * The title of the view. 
     * 
     * <p>The <code>modelTitle</code> property is injected into the 
     * associated presentation model and is typically bound as the 
     * <code>title</code> property of the MXML view.</p>
     */
    public function get modelTitle():String
    {
    	return _modelTitle;
    }
    
    //----------------------------------
    //  modelViewIndex
    //----------------------------------
    
    /**
     * @private 
     * Storage for the modelSubstateIndex property. 
     */
    protected var _modelViewIndex:int = 0;
    
    /**
     * The substate index of the view.
     */
    app_internal function get modelViewIndex():int
    {
        return _modelViewIndex;
    }
    
    /**
     * @private
     * Can only be set in subclasses.
     */
    app_internal function set modelViewIndex( value:int ):void
    {
        _modelViewIndex = value;
    }
    
    //----------------------------------
    //  modelViewState
    //----------------------------------
    
    /**
     * @private 
     * Storage for the modelViewState property. 
     */
    private var _modelViewState:String;
    
    /**
     * The presention model view state.
     * 
     * <p>This property is a string that represents a view state in the MXML 
     * view associated with the state manager and is injected into the 
     * presention model. The value is set with the 
     * <code>setModelProperties</code> method in the state's 
     * <code>Constructor</code>.</p>
     * 
     * <p>Typically, it will correspond to a constant defined in the 
     * associated <code>AViewModel</code> presentation model that corresponds
     * to a view state of the MXML view.</p> 
     */
    public function get modelViewState():String
    {
        return _modelViewState;
    }
    
    //----------------------------------
    //  parameters
    //----------------------------------
        
    /**
     * The parameters associated with this state that are shown in the 
     * parameters portion of the browser fragment.
     * 
     * <p>Override this function in concrete implementations as an object
     * with properties that will be shown in the fragment when converted
     * to a fragment parameter. If the <code>parameters</code> property
     * is overridden, the <code>isValidParametersImpl</code> method must
     * also be overridden to accordingly confirm parameter objects set from the 
     * browser fragment are valid.</p>
     */
    public function get parameters():Object
    {
        return null;
    }
    
    //----------------------------------
    //  requiresHomePage
    //----------------------------------
        
    /**
     * Whether the state requires the Home page to be concurrently visible
     * when the state is current. This value is set in the 
     * <code>Constructor</code> using the <code>setBrowserProperties</code>
     * protected method.
     */
    app_internal var requiresHomePage:Boolean = false;
    
    //----------------------------------
    //  substates
    //----------------------------------
        
    /**
     * @private
     * Storage for the substates property 
     */
    private var _substates:Array = [];
    
    /**
     * The array of substates for the state.
     * 
     * <p>Substates are distinct <code>AState</code> classes that represent
     * the state of the manager when navigation containers are used in the view. 
     * They are always extensions of a particular <code>AState</code> that 
     * corresponds to the default component in the navigator container.</p>
     * 
     * <p>The recommended naming convention is to use the associated  
     * container <code>selectedIndex</code> value in the name. 
     * E.g., State_0 for the default state and  State_1, ... State_N for the 
     * substates. In the case that multiple navigator containers are used, 
     * the naming convention would be State_0_1, etc.</p>
     */
    public function get substates():Array /* Array of String*/
    {
       return _substates;
    }
    
    //----------------------------------
    //  type
    //----------------------------------
        
    /**
     * @private 
     * Storage for the type property. 
     */
    private var _type:String
    
    /**
     * The type of the state defined in the manager's 
     * <code>AStateFactory</code>. 
     */
    public final function get type():String
    {
       return _type;
    }
    
    //----------------------------------
    //  validatedFields
    //----------------------------------
    
    /**
     * @private 
     * Storage for the validatedFields property
     */
    private var _validatedFields:Array = []; /* Array of String*/
    
    /**
     * The fields to be validated in the presentation model. 
     * 
     * <p>This property is an array of strings that correspond to the 
     * <code>sourceName</code> parameter set in the <code>addValidator</code> 
     * method used to set validators on properties in a 
     * <code>AValidatedViewModel</code> presentation model. It is set in
     * the state's <code>Constructor</code> using the 
     * <code>setValidatedFields</code> method.</p>
     * 
     * <p>Since a particular presentation model may control a view 
     * that only validates a subset of all the properties set for validation in 
     * itself, setting this for a particular state will then
     * only activate those properties for validation in the presentation
     * model.</p>
     *
     */
    public function get validatedFields():Array /* Array of String*/
    {
        return _validatedFields.slice();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Internal Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Moves to the state defined as the previous state in the 
     * <code>backImpl</code> protected method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.BACK</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    app_internal final function back( event:ViewModelEvent = null ):void
    {
        backImpl( event );
    }
    
    /**
     * Handles a remote call fault for this state based on the 
     * <code>callFaultImpl</code> protected method.
     * 
     * @param fault The <code>Fault</code> returned by the remote
     * call.
     */
    app_internal final function callFault( fault:Fault, ... args ):*
    {
        manager.hasPendingRemoteCall = false;
        return callFaultImpl( fault, args );
    }
    
    /**
     * Handles a remote call result for this state based on the 
     * <code>callResultImpl</code> protected method.
     * 
     * @param callResult The <code>CallResult</code> returned by the remote
     * call.
     */
    app_internal final function callResult( callResult:CallResult, ... args ):*
    {
        manager.hasPendingRemoteCall = false;
        return callResultImpl.apply( null, [callResult].concat(args) );
    }
        
    /**
     * Cancels the state based on the <code>cancelImpl</code> protected method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.CANCEL</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    app_internal final function cancel( event:ViewModelEvent = null ):void
    {
        cancelImpl( event );
    }
    
    /**
     * Clears the state based on the <code>clearImpl</code> protected method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.CLEAR</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    app_internal final function clear( event:ViewModelEvent = null ):void
    {
        clearImpl( event );
    }
    
    /**
     * Closes the state based on the <code>closeImpl</code> protected method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.CLOSE</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    app_internal final function close( event:ViewModelEvent = null ):Boolean
    {
    	if ( closeImpl( event ) )
        {
        	//Reset to actual home page on close
        	if (requiresHomePage)
        	{
                dispatchEvent(new StateEvent( StateEvent.RESET_HOME, this,
        		    this.type ) );
        	}
        	return setClosed();	
        }
        return false;
    }
    
    /**
     * Executes commands based on the <code>executeImpl</code> protected method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.EXECUTE</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    app_internal final function execute( event:ViewModelEvent = null ):void
    {
        executeImpl( event );
    }

    /**
     * Whether the state has a child state.
     * 
     * @param state The prospective child state.
     */
    app_internal final function hasChildState( state:AState ):Boolean
    {
        if ( hasChildManager )
        {
        	return childManager.state.isSiblingState( state );
        }
        return false;
    }
    
    /**
     * Whether the state's <code>fragmentSegment</code> is a segment in the 
     * fragment string specified.
     * 
     * <p>This returns <code>false</code> for default child states since
     * their <code>fragmentSegment<code> is the <code>PATH_SEPARATOR</code> by 
     * definition, which is always a part of a path.</p>
     * 
     * @param A string representing the fragment to be compared.
     */
    app_internal final function isSegmentOf( fragment:String ):Boolean
    {
    	return this.fragmentSegment != PATH_SEPARATOR && 
    	   fragment.lastIndexOf( this.fragmentSegment ) >= 0;
    }
    
    /**
     * Whether the state is a sibling of the state specified. Sibling states 
     * are states that are mapped in the same manager.
     * 
     *  @param state The prospective sibling state.
     */
    app_internal final function isSiblingState( state:AState ):Boolean
    {
        return manager.stateMap[ state.type ] != null &&
            state.manager == this.manager;
    }
    
    /**
     * Whether the state type corresponds to a is a sibling of the 
     * state specified. Sibling states are states that are mapped in 
     * the same manager.
     * 
     *  @param state The prospective sibling state.
     */
    app_internal final function isSiblingStateType( type:String ):Boolean
    {
        return isSiblingStateType( type );
    }
    
    /**
     * Whether parameters from the browser address are valid for this
     * state as based on <code>isValidParametersImpl</code> protected method.
     * 
     * @param An object, typically representing the parameters string in the  
     * browser address.
     */
    app_internal final function isValidParameters(parameters:Object):Boolean
    {
        return isValidParametersImpl(parameters);
    }

    /**
     * Moves to the state defined as the next state in the 
     * <code>nextImpl</code> protected method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.NEXT</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    app_internal final function next( event:ViewModelEvent = null ):void
    {
        nextImpl( event );
    }
    
    /**
     * Opens the state based on the <code>openImpl</code> protected method.
     * 
     * <p>Typically, this method is used as a handler for a
     * <code>ViewModelEvent.OPEN</code> event.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    app_internal final function open( event:ViewModelEvent = null ):Boolean
    {
        return openImpl( event );
    }
    
    /**
     * Records the last state as this.
     */
    app_internal function recordStateMemento():void
    {
        for each ( var mementoKey:String in _stateMementoKeys )
        {
            //Record a memento of the state if the key is in the 
            //stateMementoKeys
            stateMementoMap[ mementoKey ] = this;
        }
    }
    
    /**
     * Resets the state based on the <code>resetImpl</code> protected method.
     */
    app_internal final function reset():void
    {
    	//Set the home page concurrently
    	if ( requiresHomePage )
    	{
            //Set state that shows the Home page, but does not change the 
		    //browser address.
            dispatchEvent(new StateEvent(StateEvent.SET_STATE,
                HOME_NO_PATH_STATE));
    	}
        resetImpl(); 
    }
    
    /**
     * Resets the initial state of the manager by delegating to its manager's 
     * <code>resetInitialState</code> internal method.
     */
    app_internal final function resetInitialState():Boolean
    {
        return manager.resetInitialState();
    }
    
    /**
     * Post sets the state based on the <code>postsetImpl</code> 
     * protected method.
     */
    app_internal final function postset():void
    {
        postsetImpl(); 
    }
    
    /**
     * Presets the state based on the <code>presetImpl</code> protected method.
     */
    app_internal final function preset():void
    {
        presetImpl(); 
    }
    
    /**
     * Sets the state as the current state of the manager.
     * 
     * @param An object representing the parameters string in the  
     * browser address.
     */
    app_internal final function setCurrent( parameters:Object = null ):Boolean
    {
        if ( isCurrent )
        { 
            if ( setParameters( parameters ) )
            {
                dispatchEvent( new Event("stateChange") );
                return true;
            }
        } else {
            return setState( this.type, parameters );          
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
    app_internal final function setDirty(event:ViewModelEvent = null):Boolean
    {
        return setDirtyImpl(event);
    }
 
    /**
     * Sets parameters from a browser address for the state, if any.
     * 
     * <p>If the parameters are valid and successfully set for the state,
     * the <code>reset</code> method is also called to refresh the state.</p>
     * 
     * @param An object representing the parameters string in the  
     * browser address.
     */
    app_internal final function setParameters( parameters:Object, 
        validateParameters:Boolean = true ):Boolean
    {
    	var hasValidParameters:Boolean = true;
    	
    	//Check if the parameters are valid
    	if ( validateParameters )
    	{
	    	hasValidParameters = this.isValidParameters( parameters );
	    }
	    
	    //Set the parameters and reset the state if successful
	    if ( hasValidParameters ) 
	    {
	    	setParametersImpl( parameters );
            reset();
            return true;
        }
        return false;
    }
    
    /**
     * Sets the state of the manager by delegating to its 
     * <code>setStateImpl</code> internal method.
     * 
     * <p>Requests to set states that are not mapped in the manager are 
     * ignored.</p>
     * 
     * @param type The state type to be set. This can be a string state factory 
     * key or a StateEvent event with a state factory key as the reference
     * and its data being the state parameters.
     * @param parameters An object representing the parameters to be set in
     * the manager as part of setting the new state. Typically, this object 
     * represents the parameters string in the browser address and is set by 
     * the <code>FragmentManager</code>.
     */
    app_internal final function setState( type:Object, 
                                          parameters:Object = null ):Boolean
    {
        if ( manager.hasPendingRemoteCall )
        {
            //Try again later
            _pendingCallTimeout = setTimeout( setState, 10, type, parameters );
        } else {
            var event:StateEvent; 
            
            //Get the correct type
            if ( type is StateEvent )
            {
                event = StateEvent( type );
                parameters = type.data;
                type = type.reference;
            } else if ( !type is String ) {
                throw new IllegalOperationError( "State Error: type is not "
                    + "valid in " + qualifiedClassName + " setState method." );
            }
            return setStateImpl( String( type ), parameters, event );
        }
        return false;
    }
        
    /**
     * Sets the state of that manager as a substate based on the 
     * <code>setSubstateImpl</code> protected method.
     * 
     * @param reference A string that can be used to reference a particular
     * navigator container.
     * @param index The selected index of the navigator container.
     * @param dispatcher The dispatcher requesting the substate to be set. 
     * The substate is only updated if the dispatcher is the manager's
     * <code>dispatcher</code>.
     * 
     */
    app_internal final function setSubstate( index:int, reference:String, 
        dispatcher:IEventDispatcher ):Boolean
    {
        if ( dispatcher == manager.dispatcher )
        {
            if ( setSubstateImpl( index, reference ) )
            {
                //Notify the manager that state has changed
                //so that binding events occur.
                dispatchEventType( "substateChange" );
                return true;
            }
        }
        return false;
    }
    
    /**
     * Montitors other states being set in the system based on the 
     * <code>stateSetImpl</code> protected method.
     * 
     * <p>The default use of this method is to auto-close as state that
     * is set to automatically close (see the <code>AState.stateSet</code> 
     * internal method.</p>
     * 
     * @param event The event with an AState payload
     */
    app_internal final function stateSet( event:StateEvent ):void
    {
         stateSetImpl( event );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     * Adds a listener to the main application for a StateEvent.REGISTER event. 
     * Used to listen for child manager registration as part of the 
     * setState method.
     */
    private function addRegisterListener():void
    {
    	//Enable manager to set new child manager
    	manager.acceptNewChildManager = true;
    	
    	//Create listener on main application
    	var application:UIComponent = UIComponent( 
			FlexGlobals.topLevelApplication ); 
    	application.addEventListener( StateEvent.REGISTER, register );
    }
		
    /**
     * @private
     * Handler for StateEvent.REGISTER event that registers a child manager
     * for the manager.
     */
    private function register( event:StateEvent ):void
    {
    	//Call the manager method
    	if ( manager.setChildManager( AStatefulManager( event.data ) ) )
    	{   	
	    	//Clear the listener if successful
	    	removeRegisterListener();
    	}
    }
    
    /**
     * Retrieves that last state for the state. If there is no last state
     * it returns itself.
     */
    app_internal function checkStateMemento( key:String ):AState
    {
        if ( _stateMementoKeys.contains( key ) )
        {
            var mementoState:AState = stateMementoMap[ key ];
            if ( mementoState != null )
            {
                return mementoState;
            }
        }
        return this;
    }
    
    /**
     * @private
     * Removes a listener on the main application for a StateEvent.REGISTER 
     * event.
     */
    private function removeRegisterListener():void
    {
        //Disable manager from setting new child manager
        manager.acceptNewChildManager = false;
    	
    	//Clear the listener, if any      
    	var application:UIComponent 
			= UIComponent( FlexGlobals.topLevelApplication ); 
        if ( application.hasEventListener( StateEvent.REGISTER ) )
    	{
            application.removeEventListener( StateEvent.REGISTER, register );
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Protected Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * This abstract method is the actual implementation of the internal 
     * <code>back</code> method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the back method. It must be overridden to set the state in managers
     * that use the <code>back</code> method.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    protected function backImpl( event:ViewModelEvent = null ):void
    {
        raiseImplementationError( "method", "AViewState.backImpl" );
    }
 
    /**
     * This method is the actual implementation of the internal 
     * <code>callFault</code> method.
     * 
     * <p>Because there are problems with overriding methods in custom
     * namespaces, this method is needed to let subclasses override the 
     * <code>callFault</code> method. It must be overridden in managers that 
     * handle remote calls.</p>
     *
     * The default behaviour is to traceDebug the fault message.
     */
    protected function callFaultImpl( fault:Fault, ... args ):*
    {
        traceDebug(fault.faultString + '\n' + fault.message);
    }
    
    /**
     * This abstract method is the actual implementation of the internal 
     * <code>callResult</code> method.
     * 
     * <p>Because there are problems with overriding methods in custom
     * namespaces, this method is needed to let subclasses override the 
     * <code>callResult</code> method. It must be overridden in managers that 
     * handle remote calls.</p>
     */
    protected function callResultImpl( result:CallResult, ... args ):*
    {
       raiseImplementationError( "method", "callResultImpl" ); 
    }
    
    /**
     * This is the actual implementation of the internal <code>cancel</code> 
     * method.
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>cancel</code> method.</p>
     */
    protected function cancelImpl( event:ViewModelEvent = null ):void
    {
        raiseImplementationError( "method", "cancelImpl" );
    }   
    
    /**
     * This is the actual implementation of the internal <code>clear</code> 
     * method.
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>clear</code> method.</p>
     */
    protected function clearImpl( event:ViewModelEvent = null ):void
    {
        raiseImplementationError( "method", "clearImpl" );
    }   
    
    /**
     * This is the actual implementation of the internal <code>close</code> 
     * method.
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>close</code> method.</p>
     */
    protected function closeImpl( event:ViewModelEvent = null ):Boolean
    {
       return true;
    }   

    /**
     * This abstract method is the actual implementation of the internal 
     * <code>execute</code> 
     * method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>execute</code> method.</p>
     */
    protected function executeImpl( event:ViewModelEvent = null ):*
    {
        raiseImplementationError( "method", "executeImpl" );
    }
    
    /**
     * This is the actual implementation of the internal 
     * <code>isInvalid</code> method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>isInvalid</code> method. The default is <code>false</code>. 
     * Overridding this function should return <code>true</code>if the 
     * state is invalid.</p>
     */
    protected function isInvalidImpl():Boolean
    {
        return false;
    }
    
    /**
     * Whether the state type corresponds to a is a sibling of the 
     * state specified. Sibling states are states that are mapped in 
     * the same manager.
     * 
     *  @param state The prospective sibling state.
     */
    protected final function isSiblingStateType( type:String ):Boolean
    {
        return manager.stateFactory.contains( type );
    }
    
    /**
     * This is the actual implementation of the
     * <code>isValidParameters</code> internal method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override the 
     * <code>isValidParameters</code> method. This method must be
     * overridden if the <code>setParametersImpl</code> protected method
     * is overridden.<p>
     */
    protected function isValidParametersImpl( parameters:Object ):Boolean
    {
        return parameters == null;
    } 
    
    /**
     * This abstract method is the actual implementation of the internal 
     * <code>next</code> method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the back method. It must be overridden to set the state in managers
     * that use the <code>next</code> method.</p>
     * 
     * @param event The <code>ViewModelEvent</code> event.
     */
    protected function nextImpl( event:ViewModelEvent = null ):void
    {
        raiseImplementationError( "method", "nextImpl" );
    }
    
    /**
     * This is the actual implementation of the internal <code>open</code> 
     * method.
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>open</code> method.</p>
     */
    protected function openImpl( event:ViewModelEvent = null ):Boolean
    {
        return true;
    }   
    
    /**
     * This is the actual implementation of the internal <code>reset</code> 
     * method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>reset</code> method.</p>
     * 
     * <p>The functionality of this method resets the state of the manager
     * and can be called to reset the state of the manager after the manager 
     * model is updated.</p>
     */
    protected function resetImpl():void
    {
        //Does nothing unless overridden.
    }
    
    /**
     * This is the actual implementation of the internal <code>postset</code> 
     * method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>preset</code> method.</p>
     * 
     * <p>Use this method to post set any  state or manager properties when 
     * after a state is set. Only include functionality here that needs 
     * to be done once when the state is set and is not dependent on future
     * changes to the manager model. Include all other functionality
     * in the <code>resetImpl</code> protected method.
     */
    protected function postsetImpl():void
    {
        //Does nothing unless overridden.
    } 
    
    /**
     * This is the actual implementation of the internal <code>preset</code> 
     * method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>preset</code> method.</p>
     * 
     * <p>Use this method to preset any  state or manager properties when 
     * a state is initially set. Only include functionality here that needs 
     * to be done once when the state is set and is not dependent on future
     * changes to the manager model. Include all other functionality
     * in the <code>resetImpl</code> protected method.
     */
    protected function presetImpl():void
    {
        //Does nothing unless overridden.
    } 
    
    /**
     * Sets the <code>browserTitle</code>, <code>fragment</code>, and
     * <code>isTopLevel</code> properties. It also indicates if the 
     * state is requires the Home page to be visible as its base page. 
     * 
     * <p>This latter functionality is used to process browser address changes 
     * for top-level states of the home page. Use this method only in the 
     * <code>Constructor</code>. If you are not a resetting a property in an 
     * extended class, use the corresponding <code>property</code> as an 
     * argument to maintain the <code>super</code> class values.</p>
     *  
     * @param browserTitle The browser title string.
     * @param fragmentSegment The fragment segment string.
     * @param isTopLevel <code>true</code> if the state is top level.
     * @param isDefaultChildState <code>true</code> if the state is the default 
     * child state. This must be false for top-level states.
     * @param requiresHomePage <code>true</code> if the state is top level
     * and requires the Home page to be set with it. 
     */
    protected final function setBrowserProperties( browserTitle:String, 
        fragmentSegment:String, isTopLevel:Boolean = false, 
        isDefaultChildState:Boolean = false, 
        requiresHomePage:Boolean = false):void
    {
        _browserTitle = browserTitle;
        
        //Check if valid fragment segment
        if ( fragmentSegment != null)
        { 
        	if (fragmentSegment.split( AState.PATH_SEPARATOR ).length > 1 )
	        {
	        	throw new IllegalOperationError( "Fragment segment set in " +
	        	   qualifiedClassName + ".setBrowserProperties that includes the " + 
	    	   	   "path segment separator.  Fragment segments cannot " + 
		   		   "contain the path separator." );
	        }
        }
        
        _fragmentSegment = fragmentSegment;
        _isTopLevel = isTopLevel;
        
        if (isTopLevel && isDefaultChildState)
            throw new IllegalOperationError("The state " +
                qualifiedClassName + ".setBrowserProperties is setting a " +
                "default child state when it is a top-level state."  );
        
        _isDefaultChildState = isDefaultChildState;
        
        this.requiresHomePage = requiresHomePage && _isTopLevel
    }
    
    /**
     * Sets the <code>childManagerClass</code> property. Use this method only 
     * in the <code>Constructor</code>.
     * 
     * @param value The class of the child manager.
     */
    protected final function setChildManagerClass(value:Class):void
    {
    	_childManagerClass = value;
    }
    
    /**
     * Dispatches a <code>StateEvent.CLOSED</code> event.
     * 
     * <p>Default functionality is that this method is called if the 
     * <code>closeImpl</code> protected method returns true. If a close event
     * is cancelled per user input, this event can be called after processing 
     * changes in order to close. This is relevant to listeners watching for a
     * <code>StateEvent.CLOSED</code> event to indicate some further action or
     * to confirm the close event.</p>
     */
    protected function setClosed():Boolean
    {
        return dispatchEvent( new StateEvent( StateEvent.CLOSED, 
            this, type ) );
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
        return raiseImplementationError( "method", "setDirty" ); 
    }

    /**
     * Flags the state to close if another state is set that is not a 
     * siblling state and is a top-level state. Use this method only in the 
     * <code>Constructor</code>. See also <code>stateSetImpl</code>.
     * 
     * @param autoClose <code>true</code> if the state should auto-close.
     */
    protected function setHasAutoClose( autoClose:Boolean = false ):void
    {
        _hasAutoClose = autoClose;
    }
    
    /**
     * Sets the <code>helpTextCode</code> property of the state. 
     * Use this method only in the <code>Constructor</code>.
     * 
     * @param code The string code corresponding to the state's "Help" message.
     */
    protected function setHelpTextCode(code:String):void
    {
    	_helpTextCode = code;
    }
    
    /**
     * Sets keys for states that check for a memento when the state is
     * changing away from it. 
     * 
     * <p>Typically, this would be a base state type so that when the state 
     * changes away from the base state, it checks if  a memento is stored for 
     * the last non-base state.
     *  
     * @param value An array of state types.
     */
    protected function setStateMementoKeys( value:Array /* of String */ ):void
    {
        _stateMementoKeys = new ArrayCollection( value );
    }
   
    /**
     * Sets the <code>modelTitle</code> and <code>modelViewState</code>
     * properties. Use this method only in the <code>Constructor</code>.
     *  
     * @param modelTitle The title string.
     * @param modelViewState The view state as a string.
     */
    protected final function setModelProperties(modelTitle:String, 
        modelViewState:String):void
    {
        _modelTitle = modelTitle;
        _modelViewState = modelViewState;
    }
    
    /**
     * This is the actual implementation of the internal 
     * <code>setParameters</code> method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>setParameters</code> method. 
     * 
     * <p>Overridding this method requires overridding the 
     * <code>isValidParameters</code> method to ensure that the state 
     * can verify that that a parameters object is valid for the state. 
     * This is critical to ensure that no changes be made to the manager by this
     * method unless the parameters object is valid. This method is not 
     * called unless the parameters are valid, so validation logis should not 
     * be included in this method as it would be redundant. All validation
     * must be handled in the <code>isValidParameters</code> method.</p>
     * 
     * @param parameters An object representing the parameters to be set in
     * the manager as part of setting the new state. Typically, this object 
     * represents the parameters string in the browser address and is set by 
     * the <code>FragmentManager</code>.
     * 
     * @return Unless overridden, it is always <code>true</code>. If overridden,
     * it must return <code>true</code> for valid parameters so that states
     * can be set in the <code>setState</code> method.
     */
    protected function setParametersImpl(parameters:Object):void
    {
        //Do nothing unless overridden
    }
    
   /**
    * This method is a hook into the <code>setState</code> method.
    * 
    * <p>Override this method to handle the case when a state is not
    * successfully set. The default behavior is that the manager state is
    * unchanged if a <code>setState</code> method call fails.</p>
    * 
    * @param type The state type to be set.
    * @param parameters An object representing the parameters to be set in
    * the manager as part of setting the new state. Typically, this object 
    * represents the parameters string in the browser address and is set by 
    * the <code>FragmentManager</code>.
    */
    protected function setStateFailed( type:Object, 
        parameters:Object = null):void
    {
    	//Do nothing unless overridden
    }
    
    /**
     * This method is the actual implementation of the internal 
     * <code>setState</code> method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>setState</code> method. Overridding this method 
     * must call the <code>super</code> <code>setStateImpl</code> method.</p>
     * 
     * @param type The state type to be set.
     * @param parameters An object representing the parameters to be set in
     * the manager as part of setting the new state. Typically, this object 
     * represents the parameters string in the browser address and is set by 
     * the <code>FragmentManager</code>.
     * @param The event triggering the setState method, if any. This value
     * can be used to differentiate the state being internally by a 
     * sibling state ( which should use a string type key ) from a different
     * manager setting the state.
     */
    protected function setStateImpl( type:String, 
                                     parameters:Object,
                                     event:StateEvent ):Boolean
    {
        //See if the manager contains the state.
        var newState:AState = manager.stateMap[type];
        
        //Only respond to states mapped in this manager
        if ( newState!= null )
        {  
            //Only check for stateMemento, when the current state is the key
            //and the state is changing.
            if ( type != this.type )  
                newState = newState.checkStateMemento( this.type );
            
            //Only set the state if it is not the current manager state
            if ( !newState.isCurrent )
            {
                //Check if the state is valid and the parameters are 
                //valid for the state.
                if ( newState.isValid 
                    && newState.isValidParameters( parameters ) )
                {
                    //Set the state of the manager to the new state.
                    manager.state = newState;
                    
                    //Preset the state of the managers new state
                    manager.preset();
                    
                    //Set listener for child manager registery
                    var hasChildManagerClass:Boolean 
                        = newState.hasChildManagerClass;
                    
                    //Instruct the state to listen for child manager 
                    //register event
                    if ( hasChildManagerClass )
                    {
                        addRegisterListener();
                    }                       
                
                    //Call this on the new state set in the manager, not 
                    //this state which is processing the change.
                    if ( newState.setParameters(parameters) )
                    {
                        //Let the DebugConsole know
                        traceDebug( "State Set: " + type + " | "
                            + toString() + " " );
                        
                        //Clear child manager if none exist for the 
                        //new state.    
                        if ( !newState.hasChildManagerClass )
                        {
                            manager.setChildManager( null );
                            manager.acceptNewChildManager = false;
                        } 
                                                            
                        //Register the manager for managers listening
                        //for child managers. 
                        manager.registerManager();
                        
                        //Attempt to record the state as the last state
                        newState.recordStateMemento();
                        
                        //Post set the state of the managers new state
                        manager.postset();
                        
                        //Notify the manager that state has changed
                        //so that binding events occur.
                        dispatchEventType( "stateChange" );
                        
                        //Notify the world that a state has been set
                        //(primarily the Fragment Manager).
                        dispatchEvent( new StateEvent(
                            StateEvent.STATE_SET, newState, 
                            newState.type));
                        
                        //If a related event exits, dispatch it
                        if (event != null && event.relatedEvent != null)
                            dispatchEvent(event.relatedEvent);
                        
                        return true;
                    }
                }

                //Recover from the state not being set
                removeRegisterListener();
                setStateFailed( type, parameters );
                return false;
            } else {
                
                //Reset the state if current
                newState.reset();
                
                //If a related event exits, dispatch it
                if (event != null && event.relatedEvent != null)
                    dispatchEvent(event.relatedEvent);
                
                dispatchEventType( "stateChange" );
                return true;
            }
        }
        return false;
    }
    
    /**
     * This abstract method is the actual implementation of the internal 
     * <code>setSubstate</code> method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>setParameters</code> method. This method must be overridden
     * for managers that handle views with navigation containers
     * using the <code>setSubstate</code> method.</p>
     * 
     * @param index The selected index of the navigator container.
     * @param reference A string that can be used to reference a particular
     * navigator container.
     * @param dispatcher The dispatcher requesting the substate to be set. 
     * The substate is only updated if the dispatcher is the manager's
     * <code>dispatcher</code>.</p>
     * 
     * @return <code>true</code> if the substate is set
     */
    protected function setSubstateImpl( index:int, reference:String ):Boolean
    {
    	return raiseImplementationError("method", "setSubstateImpl");
    }
        
    /**
     * Sets the <code>substates</code> property. Use this 
     * method only in the <code>Constructor</code>.
     *  
     * @param value The array of state type strings representing the substates
     * that are mapped in the state manager. 
     */
    protected final function setSubstates(value:Array):void
    {
        _substates = value;
    }
    
    /**
     * This method is the actual implementation of the internal 
     * <code>stateSet</code> method. 
     * 
     * <p>Because there are problems with overriding methods in custom 
     * namespaces, this method is needed to let subclasses override 
     * the <code>stateSet</code> method.</p>
     * 
     * <p>The default use of this method is to auto-close as state that
     * is set to automatically close (see the <code>AState.stateSet</code> 
     * internal method. Overridding this state must call the 
     * <code>super</code> <code>stateSetImpl</code> method to maintain this
     * default functionality.</p>
     * 
     * @param event The event with and AState payload
     */
    protected function stateSetImpl( event:StateEvent ):void
    {
         if ( _hasAutoClose )
         {
         	var state:AState = AState ( event.data );
         	if (! state.isSiblingState( this ) && state.isTopLevel )
         	{
         		close();
         	}
         }
    }
    
    /**
     * Sets the <code>validatedFields</code> property. Use this 
     * method only in the <code>Constructor</code>.
     *  
     * @param value The array of <code>sourceName</code> strings 
     * representing the validatedFields in the presentation model. 
     */
    protected final function setValidatedFields(value:Array):void
    {
        _validatedFields = value;
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
     * Dispatches events to the state and the manager.
     */
    override public function dispatchEvent( event:Event ):Boolean
    {
    	manager.dispatchEvent( event );
    	return super.dispatchEvent(event);
    }
}

}