////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.managers.fragment
{
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.events.ViewModelEvent;
import com.fosrias.core.events.WebBrowserEvent;
import com.fosrias.core.managers.interfaces.AManager;
import com.fosrias.core.managers.interfaces.AState;
import com.fosrias.core.managers.interfaces.AStatefulManager;
import com.fosrias.core.models.interfaces.AUser;
import com.fosrias.core.namespaces.app_internal;
import com.fosrias.core.utils.interfaces.IIterator;
import com.fosrias.core.views.interfaces.AMainViewModel;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.core.Application;
import mx.core.FlexGlobals;
import mx.utils.StringUtil;
import mx.utils.URLUtil;

use namespace app_internal;

/**
 * The FragmentManager class monitors and maintains the state of the 
 * application and updates the browser address in response to application 
 * state changes and updates the application state in response to browser 
 * address changes. The browser title corresponding to the application state
 * is set with each update.</p>
 * 
 * <p>Prior state of visited pages is maintained and restored 
 * upon revisiting them unless this default functionality is overridden 
 * in a particular <code>AState</code> sublclass.</p>
 * 
 * <p>In order to use the <code>FragmentManager</code> class in an application, 
 * the following must be implemented:
 * 
 * <ol>
 * <li>
 *     <p>The <code>FragmentEventMap</code> <code>tag</code> must 
 *     be included in the main application MXML file before the 
 *     main application event map.</p>
 * </li>
 * <li>
 *     <p>The <code>WebBrowserEventMap</code> <code>tag</code> must 
 *     be included in the main application MXML file after the 
 *     <code>FragmentEventMap</code> <code>tag</code> but before the 
 *     main application event map.</p>
 * </li>
 * <li>
 *     <p>The main application manager must implement at least two states 
 *     with the types (all three if the site requires a user session): 
 *     <ul>
 *          <li><code>AState.HOME_STATE</code>
 *          <li><code>AState.HOME_NO_PATH_STATE</code>
 *          <li><code>AState.LOGIN_STATE</code> (optional)
 *     </ul></p>
 * 
 *     <p>To do this, define the states in the main application state factory 
 *     and set the corresponding state factory type constants equal to these 
 *     constants. This will ensure that any module implementing the 
 *     <code>FragmentManager</code> can access the necessary Home page 
 *     functionality in the main application. See the constant definitions for 
 *     further information for the <code>AState</code> class.</p>
 * </li>
 * <li>
 *     <p>The main application must include a GUI component as its last child
 *     which must implement a <code>ViewStack</code> 
 *     with at least two containers. The first contains the complete site. 
 *     The second container must be the <code><lt&;SiteStatusUI.mxmlgt&;<code>
 *     view, or a similarily implemented view component. The second container 
 *     is the default page for invalid browser addresses. The 
 *     <code>selectedIndex</code> property of the view stack must be bound to
 *     the main application GUI presentation model's 
 *     <code>pageViewStackIndex</code> property.
 * 
 *     <p>The main application GUI presentation model must include a 
 *     <code>pageViewStackIndex</code> property and its event map must inject 
 *     the <code>FragmentManager.modelViewStackIndex</code> 
 *     property into the presentation model's <code>pageViewStackIndex</code> 
 *     property. This ensures the <code>FragmentManager</code> can set the 
 *     site view appropriately when the browser address is invalid.</p>
 * </li>
 * <li>
 *     <p>Each <code>AState</code> sublclass must specify a child manager 
 *     class type for any managers that contain states that are child states
 *     of the current state. These states correspond to deeper links in the 
 *     browser fragment. See <code>AState</code> for further information.</p>
 * </li>
 * </ol></p>
 * 
 * @see com.fosrias.core.managers.interfaces.AState
 * @see com.fosrias.core.managers.WebBrowserManager
 * @see com.fosrias.core.maps.FragmentEventMap.mxml
 * @see com.fosrias.core.maps.SiteStatusLocalEventMap.mxml
 * @see com.fosrias.core.maps.WebBrowserEventMap.mxml
 * @see com.fosrias.core.views.interfaces.AMainViewModel
 */	
public class FragmentManager extends AStatefulManager
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function FragmentManager()
	{   
		super(this);
		setInitialStateType( FragmentStateFactory.VALID );
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    //Parsing flags used to delay processing if parsing
    private var _isParsingFragment:Boolean = false;
    private var _isParsingState:Boolean = false;
    
    //Timer variables
    private var _parseAddressTimeoutInterval:uint = 0;
    private var _stateSetQueueTimeoutInterval:uint = 0;
    
    //Maps used when states are registered
    private var _fragmentToStateMap:Dictionary = new Dictionary;
    private var _stateMementoMap:Dictionary = new Dictionary;
    
    //Maps used in transactions
    private var _currentParametersMap:Dictionary = new Dictionary;
    private var _currentStateMap:Dictionary = new Dictionary;
    
    //Browser state variables
    private var _currentFragment:String = AState.HOME; 
    private var _currentStatesStack:ArrayCollection = new ArrayCollection;  
    
    //Browser state working variables
    private var _pendingFragment:String;
    private var _pendingParameters:Object;
    private var _pendingStatesStack:Array = [];
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  modelViewStackIndex
    //----------------------------------
    
    /**
     * @private
     * Storage for the modelViewStackIndex property.
     */
    private var _modelViewStackIndex:int;
    
    [Bindable(event="stateChange")]
    /**
     * The model view stack that is used to set the <code>SiteStatusUI</code>
     * as the current view if the browser address is invalid.
     */
    public function get modelViewStackIndex():int
    {
        return _modelViewStackIndex;
    }
    
    //----------------------------------
    //  selectedLink
    //----------------------------------
    
    /**
     * The link clicked on the <code>SiteStatusUI</code>. It is used by the
     * <code>FragmentInvalidState.executeIml</code> method to
     * respond to user interaction with the the invalid page view.
     */
    app_internal var selectedLink:String;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Handles a browserURLChange event by parsing the browser fragment to 
     * a corresponding application state.
     * 
     * @param event The <code>WebBrowserEvent</code>.
     */
    public function browserURLChange( event:WebBrowserEvent ):void
    {
        if ( !_isParsingFragment && _currentFragment != event.reference )
        {
        	parseBrowserFragment( event.reference );

        } else if ( _currentFragment != event.reference ) {
        	
        	//Retry after current address has been parsed.
            _parseAddressTimeoutInterval = setTimeout( browserURLChange, 10, 
                event );
        }
    }
    
    /**
     * Registers <code>AStateManager</code> sublclass <code>AState</code>
     * subclasses that have a top-level <code>fragmentSegment</code> 
     * defined for them.
     *  
     * @param state The manager to be registered.
     */
    public function register( event:StateEvent ):void
    {
    	//Only process intial registration events
    	if (event.reference == AManager.INITIAL_REGISTRATION)
    	{
	    	var manager:AStatefulManager = AStatefulManager( event.data );
	    	var states:IIterator = manager.registeredStates;
	    	var state:AState;
	    	var fragmentSegment:String;
	    	var topLevelState:AState;
	    	
	    	while (!states.eof)
	    	{
	    		state = states.next();
	    		
		        //Map top level states by their fragment
		        if ( state.isTopLevel )
		        {
		            //Remove leading path separator
		            fragmentSegment = state.fragmentSegment;
		            fragmentSegment = fragmentSegment.slice( 1, 
		                fragmentSegment.length );
		
		            //Check if top level path is set
		            topLevelState = _fragmentToStateMap[ fragmentSegment ];             
		        
		            //Register top level states by their fragment
		            if ( topLevelState == null && state.hasFragmentSegment )
		            {
		                _fragmentToStateMap[fragmentSegment] = state;
		            } else if ( state.hasFragmentSegment ){
		            	
		            	//Only one state can exist for a discrete 
		            	//top-level fragment
		                throw new IllegalOperationError( "Top level fragment '" 
		                    + fragmentSegment + "' is already set in " 
		                    + qualifiedClassName + ".register corresponding to " 
		                    + "state " + state.qualifiedClassName + "." ); 
		            }
		        }
	            
		        //Set DebugMessage
		        traceDebug( "State registered: " + state.className + 
		           " for Manager:" + manager.className );
		    }
    	}
    }
    
    /**
     * Handler for <code>StateEvent.RESET_HOME</code> event.
     * 
     * <p>This event is dispatched by states that require the Home page to 
     * be concurrently visible. When they close, they dispatch this event to
     * reset the <code>FragmentManager</code> model to that of the 
     * Home page.</p>
     *  
     * @param The <code>AState</code> subclass resetting the Home page.
     */
    public function resetHome(state:AState):void
    {
    	//Only reset if current fragment contains the state's fragment.
    	//Otherwise, state of application has already been set by a 
    	//different state.
    	if ( _currentFragment.lastIndexOf(state.fragmentSegment) >= 0 )
    	{
    		//Set the current state to the home page
    		var homeState:AState = _fragmentToStateMap[ AState.HOME ];
    		_currentFragment = homeState.fragmentSegment;
    		_currentStatesStack 
    		    = new ArrayCollection( [ homeState ] );
    		
    		//Update the browser
    		dispatchEvent( new WebBrowserEvent( WebBrowserEvent.SET_FRAGMENT,
                    null, null, AState.HOME ) );
            dispatchEvent( new WebBrowserEvent( WebBrowserEvent.SET_TITLE,
                null, null, homeState.browserTitle ) );
    	}
    }    
    
    //--------------------------------------------------------------------------
    //
    //  Internal Methods
    //
    //--------------------------------------------------------------------------
    
    
    /**
     * @private
     * Accessed by states to update the view stack index of the model.
     */
    app_internal function setModelViewStackIndex( index:int):void
    {
        _modelViewStackIndex = index;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    //Mapping State for transactions and to remember previous child states
        
    /**
     * @private
     * Clears a specific map element of the current browser fragment 
     * related states and and parameters.
     * 
     * @param stateKey The state that is the map key.
     */
    private function clearTransactionMap( stateKey:AState ):void
    {
    	_currentStateMap[ stateKey ] = null;
        delete _currentStateMap[ stateKey ];
        _currentParametersMap[ stateKey ] = null;
        delete _currentParametersMap[ stateKey ];
    }
    
    /**
     * @private
     * Clears all map elements of the current browser fragment 
     * related states and and parameters.
     */
    private function clearTransactionMaps():void
    {
    	for ( var stateKey:* in _currentStateMap )
        {
            //Clear the map
             clearTransactionMap( stateKey );
        }
    }
        
    /**
     * @private 
     * Stores a record of a state prior to changing it for use
     * in rolling back transactions.
     */
    private function mapStateOfState( state:AState ):void
    {
        _currentStateMap[ state ] = state.currentStateType;
        _currentParametersMap[ state ] = state.parameters;
    }  
        
    /**
     * @private
     * Gets a state's memento, if any.
     * 
     * @param The state with a memento.
     */
    private function getStateMemento( state:AState ):StateMemento
    {
        var memento:StateMemento = _stateMementoMap[ state ];
        
        //Clear the map
        if ( memento != null )
        {
            _stateMementoMap[ state ] = null;
            delete _stateMementoMap[ state ];
        }
        return memento;
    }
    
    /**
     * @private
     * Sets a memento based on a state stack and parameters.
     * 
     * @param stateStack The stack of states to be mapped in the memento. 
     * Typically, the current state stack. The top-level state in the stack
     * is used as the map key.
     * @param parameters The parameters to be mapped with the state.
     */
    private function setStateMemento( stateStack:Array, parameters:Object ):void
    {
         _stateMementoMap[ stateStack[ stateStack.length - 1 ] ] = 
            new StateMemento( stateStack, parameters );
    }

    //Parsing fragments to states and states to fragments
       
    /**
     * @private 
     * Builds a stack of states that corresponds to the 
     * fragment address and parameters.
     *  
     * @param address The address string to compare with state fragments.
     * @param parameters The paramaters object from the fragment.
     * @param state The state to use to compare its <code>fragmentSegment</code>
     * and that of any of its child states to the address and parameters.
     */
    private function buildStateStack( address:String, parameters:Object, 
        state:AState ):Array
    {
        //Initialize variables
        var traversedStack:Array = [];
        var traversedSubStack:Array;
        
        //Remove the state fragment from the address for comparison with
        //child state fragments.
        var workingAddress:String 
            = StringUtil.trim( address.replace( state.fragmentSegment, "" ) );    
        if (workingAddress == AState.PATH_SEPARATOR)
        {
        	workingAddress = AState.HOME;
        }
        
        //Check if any more potential state fragmment segments 
        //exist in the address
        var onlyCheckForDefaultChildStates:Boolean = workingAddress.length == 0;
        
        //Flag to check if state is set successfully
        var stateSet:Boolean = false;
        var isValidParameters:Boolean = false;
          
        //Set state if valid
        if ( state.isValid )
        {
        	//Store the state of the current state should a later failure
            //cause these changes to roll back.
            mapStateOfState( state );
            
            //Set the state
            if ( onlyCheckForDefaultChildStates )
            {
            	isValidParameters = state.isValidParameters( parameters );
            	if ( isValidParameters )
            	{
                    stateSet = state.setCurrent( parameters );
                } else {
                	
                	//Wait to set parameters on a child state.
                	stateSet = state.setCurrent();
                }
            } else {
                stateSet = state.setCurrent();
                isValidParameters = true;
            }
        }   
        
        //If the state was not set, fail.
        if ( !stateSet )
        {
            setInvalid( state );
            return [];
        }
        
        //Validate so child manager of the state is set, if any.
		FlexGlobals.topLevelApplication.validateNow();  
        
        //If no child states, parameters must have been applied successfully
        //to this state.
        if ( !state.hasChildManager && ( !isValidParameters 
            ||  workingAddress.length > 0 ) )
        {
            setInvalid( state );
            return [];
        } else if ( !state.hasChildManager ) {
        	return [ state ];
        }
        
        //Initialize child state related variables
        var childState:AState
        var childStates:IIterator = state.childStates;
        
        //Flag to monitor an invalid session as reason for child state not
        //being valid.
        var invalidSession:Boolean = false;
        
        //Iterate each child state and compare with the working address
        while ( !childStates.eof )
        {
            childState = childStates.next();
            if ( childState.hasFragmentSegment && childState.isValid )
            {
            	if ( onlyCheckForDefaultChildStates ) 
            	{
            		//If the child manager has a reset requirement,
            		//set it as the child state.
            		if ( childState.hasResetRequirement )
            		{
            		    var initialState:AState 
            		         = childState.managerInitialState;
            		    if ( initialState.isValidParameters( parameters ) )
            		    {
            		    	if ( initialState.resetInitialState() )
            		    	{
            		    		return [ initialState, state ];
            		    	} else if ( !invalidSession && 
                                !initialState.hasValidSession ) {
                                
                               //Only set if not already set
                               invalidSession = true;
                               break;
                            } 
            		    }
            		} else if ( childState.isDefaultChildState ) {
            			
            			//Default states have the path separator as a fragment
            			//and are the only valid state type if 
            			//onlyCheckForDefaultChildStates is true.
            			if ( childState.isValid )
            			{
	            			//Deepest state is only set in the 
                            //commitStatesUpdate method so that parameters
                            //can be properly applied.
	            			return [ childState, state ];
            			} else if ( !invalidSession && 
            			    !childState.hasValidSession ) {
            			    	
            			       //Only set if not already set and 
                               //keep looking for valid state.
        					   invalidSession = true;
            			} 
            		}
            	} else if ( childState.isSegmentOf( workingAddress ) ) {
            		
            		//Traverse child state nodes to complete the stack
                    traversedSubStack = buildStateStack( 
                        workingAddress, parameters, childState );
                        
                    //Add the current state to the top of the stack. 
                    traversedSubStack.push( state );
                    
                    //Success!
                    return traversedSubStack;
            	}
            }
        }
        
        //Find out why it failed and set the state of the FragmentManager
        //accordingly.
        if ( invalidSession )
        {
        	setInvalidSession();
        } else {
            setInvalidAddress();
        }
        return [];
    }

    /**
     * Parses a browser fragment to a state stack (and corresponding application 
     * state) that corresponds to the browser fragment including any parameters 
     * in the browser address. 
     * 
     * @param fragment The current browser fragment.
     */
    private function parseBrowserFragment( fragment:String ):void
    {
    	//Set parsing flag
        _isParsingFragment = true;
        
        //Store the pending fragment
        _pendingFragment = fragment;
        
        //Begin state change transactions
        beginStatesUpdate();
        
        //Parse the new address.
        if ( parsePendingFragmentToStates() )
        {
            //Commit state change transactions
            commitStatesUpdate();
        }
        
        //Reset parsing flag
        _isParsingFragment = false;
    }
    
        
    /**
     * @private 
     * Parses out the address portion of the browser fragment.
     */
    private function parseFragmentAddress( fragment:String ):String
    {
        var addressLength:int = fragment.lastIndexOf( 
            AState.PARAMETERS_SEPARATOR );
        var address:String;
        if ( addressLength > 0 )
        {
            address = fragment.slice( 0, addressLength );
        } else {
            address = fragment;
        }
        return address;
    }
            
    /**
     * @private 
     * Parses out the parameters portion of the browser address and 
     * returns an object with properties. 
     */
    private function parseFragmentParameters( fragment:String ):Object
    {
        var addressLength:int = fragment.lastIndexOf( 
            AState.PARAMETERS_SEPARATOR);
        if ( addressLength > 0 )
        {
            var address:String = fragment.slice( 0, addressLength );
            return URLUtil.stringToObject( fragment.slice( address.length + 1, 
                   fragment.length ), AState.PROPERTY_SEPARATOR );
        } else {
            return null;
        }
    }
    
    /**
     * @private
     * Parses a fragment to a valid state stack, if any, that corresponds to 
     * the browser fragment.
     */
    private function parsePendingFragmentToStates():Boolean
    {
    	var address:String = parseFragmentAddress( _pendingFragment );
    	var parameters:Object = parseFragmentParameters( _pendingFragment );
        
        //Check if home state
        if ( address == AState.HOME )
        {
        	//Home address state fragment will be the path separator
            address = AState.PATH_SEPARATOR;
        }
                
        //Split the address by the path separator and only keep the 
        //first two elements. The first element should be the empty string 
        //for a valid path.
        var pathSegments:Array = address.split( AState.PATH_SEPARATOR, 2 );
        
        //Check for malformed fragment (has path separator directly before 
        //parameters)
        if ( pathSegments[ pathSegments.length - 1 ] == "" 
            && parameters != null )
        {
            return setInvalidAddress();
        }
        
        //Remove blank first element
        pathSegments.shift();
        
        //Get the top level state
        var topLevelState:AState 
            = _fragmentToStateMap[ pathSegments.pop() ];
        
        //If the top level path segment does not exist, fail.
        if ( topLevelState == null )
        {
        	return setInvalidAddress();
        }
        
        //Find the valid state path to the same address
        _pendingStatesStack = buildStateStack( address, parameters ,
            topLevelState );
        
        //Fragment is invalid if paths not found or session is invalid
        if ( _pendingStatesStack.length != 0 )
        {
	        _pendingParameters = parameters;
	        return true;
        } 
        return false;
    }
    
    /**
     * @private
     * Parses a state set in the application by user interaction to a 
     * browser address, if a valid address exist for the resulting application
     * state.
     * 
     * @param state The set state. 
     */
    private function parseSetState( state:AState ):void
    {
    	//Set parsing flag. Ignores other states being set as part of parsing
        //the state.
        _isParsingState = true;
        
        //Store the pending fragment as the current fragment for 
        //comparison with the new fragment generated
        _pendingFragment = _currentFragment;

        //Intialize the pending parameters
        _pendingParameters = null;
        
        //Begin state change transactions
        beginStatesUpdate();
        
        //Parse the new address.
        if ( parseStateToStateStack( state ) )
        {
            //Commit state change transactions
            commitStatesUpdate();
        }
        
        //Reset parsing flag
        _isParsingState = false;
    }
    
    /**
     * @private
     * Finds a path stack associated with a state. If the state is not a 
     * top-level state, it finds its place in the current stack and 
     * builds a new stack under it if it has child states. It then builds a
     * fragment based on the state and parses it as if it was received by the 
     * browser.
     * 
     * @param The state being converted to a stack of related states
     */
    private function parseStateToStateStack( state:AState ):Boolean
    {   
    	//Initialize variables
    	var stateStack:Array = [];
    	var newAddress:String = "";
    	var parameters:Object = null;
    	var topLevelState:AState;
    	
    	//Check if top level state
        if (state.isTopLevel)
        {
            //Set the top level state
            topLevelState = state;
            
        	//Flag to process result
        	var stackIsValid:Boolean = true;
                    
        	//If the state has a memento, restore its complete state.
        	var memento:StateMemento = getStateMemento( state );
        	if ( memento != null )
        	{            
    			//Check if all states in memento are valid. Clear memento 
    			//and skip if not.
    			var stack:Array = memento.stack.slice();
    			var mementoState:AState;
    			while ( stack.length > 0 )
    			{
    				mementoState = stack.pop();
    				if ( !mementoState.isValid 
    				    && !state.hasResetRequirement )
    				{               
                        //Flag invalid stack
    					stackIsValid = false;
    				} else {
    					//Build an address based on the memento stack
                        newAddress += mementoState.fragmentSegment;
    				}
    			}
        	} else {
        		stackIsValid = false;
        	}
        	
        	//If valid, process the memento
            if ( stackIsValid )
            {
                _pendingParameters = memento.parameters;
                parameters = _pendingParameters;
            } else {
            	
            	//These will be handled in the commit phase.
        	    parameters = null;
        	    newAddress = state.fragmentSegment;
            }
        } else if ( _currentStatesStack.length > 0 ) {
        	
        	//Get the last index
        	var lastIndex:int = _currentStatesStack.length - 1;
        	
        	//Top level state is the last state
        	topLevelState = AState( _currentStatesStack.getItemAt( lastIndex ) );
        	
        	//Crawl down the currentStatesStack and find out where to
            //add the new state
            var currentState:AState;
        	for ( var i:int = lastIndex; i >= 0; i-- )
        	{
        		currentState = _currentStatesStack[i];
        		if ( currentState.hasChildState( state ) )
                {
                	newAddress += currentState.fragmentSegment + 
                	    state.fragmentSegment;
                	break;
                
                } else if ( currentState.isSiblingState( state ) ) {
                    
                    newAddress += state.fragmentSegment;
                    break;
                } else {
                	
                	//State depth is above the state being parsed
                	newAddress += currentState.fragmentSegment;
                }
        	}
        }
        
        //Get the corresponding new state stack. Ignore default states.
        if (newAddress != "" && !( newAddress == AState.PATH_SEPARATOR
             && state.isDefaultChildState ) )
        {
           stateStack = buildStateStack( newAddress, parameters, topLevelState );
        } 
        
        //Check if a path exists for the state
        if ( stateStack.length > 0 )
        {
        	_pendingStatesStack = stateStack;
            return true;
        } 
        
        //Clear any transaction maps since no path was found.
        clearTransactionMaps();
        return false;
    }
     
    /**
     * @private
     * Sets the correct invalid state of the <code>FragmentManager based 
     * the type of state invalidity.
     *  
     * @param state The invalid state.
     */
    private function setInvalid(state:AState):Boolean
    {
        if (!state.hasValidSession )
        {
            return setInvalidSession();
        } else {
            return setInvalidAddress();
        }
    }
        
    /**
     * @private 
     * Called if a state being set is invalid or a state does not exist for 
     * a browser address segment or the browser address parameters are
     * not valid for a state and rolls back any transactions.
     */
    private function setInvalidAddress():Boolean
    {
    	//Restore original state
    	rollbackStatesUpdate();
    	
		//If invalid address set from home state, change home state
		//so home link functionality works.
	    setHomeNoPathState();
    	
		//Update currentFragment
		_currentFragment = _pendingFragment;
		
    	//Clear the pending values
        _pendingParameters = null;
        _pendingStatesStack = [];
        
        //Shows the invalid warning page
        setState( FragmentStateFactory.INVALID );
        return false;
    }
    
    /**
     * @private
     * Rolls any state changes back and sets the application to the warning
     * page. If a session login occurs, the pending fragment is automatically
     * retried.
     */
    private function setInvalidSession():Boolean
    {
    	//Rollback any state changes
    	rollbackStatesUpdate();

        //If invalid address set from home state, change home state
        //so home link functionality works.
        setHomeNoPathState();
        
        //Store the pending fragment to retry if a user session is set
        _currentFragment = _pendingFragment;
        
        //Sets the warning page to prompt login
        setState( FragmentStateFactory.REQUIRES_SESSION );
        return false;
    }
    
    /**
     * @private
     * If the prior page was the home page, set the Home page to 
     * the homeNoPathState so that the Home link on the SiteStatusUI 
     * will set the state to the Home page when clicked.
     */
    private function setHomeNoPathState():void
    {
    	if ( _currentFragment == AState.HOME || _currentFragment == null || 
    	   _currentFragment == AState.PATH_SEPARATOR )
    	{
    		dispatchEvent( new StateEvent( StateEvent.SET_STATE, null,
    		    AState.HOME_NO_PATH_STATE ) );
    	}
    }
    
        
    /**
     * @private 
     * Sets the state of the <code>FragmentManager</code> when the browser
     * address is valid to the <code>FragmentValidState</code>.
     */
    private function setValidAddress():Boolean
    {
        setState( FragmentStateFactory.VALID );
        return true;
    }
    
    //Transactions
    
    /**
     * @private
     * Stores the current address related state of the application.
     */
    private function beginStatesUpdate():void
    {
    	//Store the current state stack and its current state
        var currentStateStackCopy:Array = _currentStatesStack.source.slice();
        while (currentStateStackCopy.length > 0)
        {
            mapStateOfState(currentStateStackCopy.pop());
        }
    }
    
    /**
     * Commits the changes to the state of the application. 
     */
    private function commitStatesUpdate():Boolean
    {    
        //Initialize variables
        var state:AState;
        var newFragment:String = "";
        var newTitle:String = "";
        
        //Get the deepest path segment state in the stack
         state = _pendingStatesStack[0];
            
        //Check if parameters are valid for last state
        //If not, quit now.
        if ( !state.isValidParameters( _pendingParameters ) ) 
        {
            return setInvalidAddress();
        }
        
        //Copy the state stack
        var pendingStatesStack:Array = _pendingStatesStack.slice();
            
        //Determine the shortest valid path for the state. Accept the first
        //valid path.   
        while ( pendingStatesStack.length > 0 )
        {   
            //Get the path state
            state  = pendingStatesStack.pop();

            //Set DebugMessage          
            traceDebug( toString() + "[commit " + state.type 
                + "]" );
                    
            //Stack the titles
            if ( state.hasBrowserTitle )
            {
                newTitle += state.browserTitle + " ";
            }
            
            //Build the new path, but don't add a path separator to the
            //end if last state fragment is a path separator.
            if ( pendingStatesStack.length == 0 
               && state.fragmentSegment != AState.PATH_SEPARATOR ||
               pendingStatesStack.length > 0 )
            {
                newFragment += state.fragmentSegment;
            }
        }
        
        //Get the parameters of the last state, if any.
        if ( _pendingParameters == null && state.hasParameters && 
            _isParsingState )
        {
            _pendingParameters = state.parameters;
        }
       
        //Store the current state should a later failure
        //cause these changes to roll back.
        mapStateOfState( state );
        
        //Set the deepest state
        if ( !state.setCurrent( _pendingParameters ) )
        {
        	return setInvalid( state);
        }

        //Clear the maps of the current application state
        clearTransactionMaps();

        //Compare new fragment to the current address portion of the pending
        //fragment. If only difference is the pending address has a path 
        //separator, add one to the new fragment.
        var address:String = parseFragmentAddress( _pendingFragment );
        address = address.replace( newFragment,"" );
        if ( address == AState.PATH_SEPARATOR )
        {
            newFragment += AState.PATH_SEPARATOR;
        }
                
        //Complete the new fragment. If the pending address fragment ends 
        //with a path separator, add it back to the new fragment
        if ( newFragment == AState.PATH_SEPARATOR 
            && ( _pendingFragment == AState.HOME 
            || _pendingFragment != AState.PATH_SEPARATOR) )
        {
            //Home state never has parameters
            newFragment = AState.HOME;
        } else if ( _pendingParameters != null ) {
            newFragment += AState.PARAMETERS_SEPARATOR +
                URLUtil.objectToString( _pendingParameters, 
                    AState.PROPERTY_SEPARATOR );
        }
        
        //Update the browser fragment if necessary
        if ( newFragment != _pendingFragment )
        {
            dispatchEvent( new WebBrowserEvent( WebBrowserEvent.SET_FRAGMENT, 
                null, null, newFragment ) );  
        }
        
        //Always update the title
        dispatchEvent(new WebBrowserEvent( WebBrowserEvent.SET_TITLE,
            null, null, newTitle ) );
        
        //Store the state of the current stack by the top level state
        //so that returning to that state will completely restore state.
        //Used with setState.
       setStateMemento( _pendingStatesStack, _pendingParameters );
       
        //Store the new current fragment for comparison with closing
        //states in resetHome method
        _currentFragment = newFragment;
        
        //Close all current toplevel states that are not in the new path
        //Child states are left current so state can be returned to them.
        var newStates:ArrayCollection 
            = new ArrayCollection(_pendingStatesStack);
        for each ( state in _currentStatesStack )
        {
            if ( !newStates.contains( state ) )
            {
                //Check if a sibling state
                var isSibling:Boolean = false;
                for each ( var newPathState:AState in _pendingStatesStack )
                {
                    if (newPathState.isSiblingState( state ) )
                    {
                        isSibling = true;
                        break;
                    }
                }
                if ( !isSibling && state.isTopLevel )
                {
                    traceDebug( toString() + "[close " + state.type + "]" );
                    state.close();
                }
            }
        }
        
        //Store the new current states stack after closing states not in
        //new states stack.
        _currentStatesStack = new ArrayCollection( _pendingStatesStack );
        
        //Clear the pending values
        _pendingParameters = null;
        _pendingStatesStack = [];
        
        //Set state for valid address
        return setValidAddress();
    }
    
    /**
     * Rolls back any state changes that may have occured. 
     */
    private function rollbackStatesUpdate():void
    {
        //Iterate over map objects
        for ( var state:* in _currentStateMap )
        {
            //Reset the state to its former value
            state.setState( _currentStateMap[ state ], 
                _currentParametersMap[ state ] );
            
            //Clear the map
            clearTransactionMap( state );
        }
        
        //Ensure the display list is reprocessed     
		FlexGlobals.topLevelApplication.validateNow();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override public function loggedIn( event:StateEvent = null ):void
    {
    	//Automatically retry parsing pending state after session is created 
        if ( _pendingFragment != null 
            && state.type == FragmentStateFactory.REQUIRES_SESSION ) 
        {
        	parseBrowserFragment( _pendingFragment );
        }
    }
    
    /**
     * @inheritDoc
     */
    override protected function setDirtyImpl(
        event:ViewModelEvent = null):Boolean
    {
        selectedLink = String( event.data );
        return true;
    }
    
    /**
     * Montitors other states being set in the system by delegating to 
     * the current state's <code>stateSet</code> internal method.
     * 
     * <p>Overridden to update the browser address if the event payload
     * has a <code>fragmentSegment</code>.</p>
     * 
     * @param event The event with and AState payload
     */
    override public function stateSet( event:StateEvent ):void
    {
        //Don't process changes if the system currently is parsing
        //a fragment or a state.
        if ( !_isParsingFragment && !_isParsingState )
        {
            var state:AState = AState( event.data );

            if ( state.hasFragmentSegment )
            {   
                //Only process states that have a fragmentSegment that is not 
                //part of the current state stack. Always parse the home state.
                if ( !_currentStatesStack.contains( state ) 
                    || state.type == AState.HOME_STATE )
                {
                    //Update the browser address based on the state
                    parseSetState( state );
                    
                    //Set DebugMessage
                    traceDebug( "State Set: " + state.className );
                }       
            }
        }
    } 
}

}

/**
 * The StateMemento class stores a snapshot of the current fragment state.
 */
internal class StateMemento
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function StateMemento ( stack:Array, paramenters:Object )
	{
		_stack = stack.slice();
		_parameters = parameters;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  parameters
    //----------------------------------
    
    /**
     * @private 
     * Storage for the parameters property 
     */
    private var _parameters:Object
    
    /**
     * The parameters associated with the stack.
     */
    public function get parameters():Object
    {
        return _parameters;
    }
    
    //----------------------------------
    //  stack
    //----------------------------------
    
    /**
     * @private 
     * Storage for the stack property 
     */
    private var _stack:Array
    
    /**
     * The stack of former states.
     */
    public function get stack():Array
    {
    	return _stack;
    }
}