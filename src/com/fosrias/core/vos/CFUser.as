package com.fosrias.core.vos
{
import com.fosrias.core.models.Memento;
import com.fosrias.core.models.interfaces.IIsEqual;
import com.fosrias.core.models.interfaces.IMemento;
import com.fosrias.core.models.interfaces.IMementoHost;
import com.fosrias.core.namespaces.memento_internal;
import com.fosrias.core.utils.ArrayUtils;
import com.fosrias.core.utils.ComparisonUtils;
import com.fosrias.core.vos.interfaces.ATimestamp;

import flash.events.Event;
import flash.events.EventDispatcher;

use namespace memento_internal;

[RemoteClass(alias="CFCore.com.fosrias.site.components.physical.User")]
[Bindable]
/**
 * The CFUser class is a user class for use with ColdFusion sites.
 */
public class CFUser extends ATimestamp
		            implements IIsEqual, IMementoHost
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function CFUser(id:uint = 0,
						   login:String = null, 
						   password:String = null,
						   oldPassword:String = null,
						   convertRemoteDates:Boolean = false)
	{
		super(convertRemoteDates);
		this.id = id;
		this.login = login; 
		this.password = password;
		this.oldPassword = oldPassword;
	} 
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  clone
	//----------------------------------
	
	[Transient]
	/**
	 * A clone of the instance.
	 */
	public function get clone():CFUser
	{
		var clone:CFUser = new CFUser(id, login, password, oldPassword);
		clone.createdAt = createdAt;
		clone.currentLoginIp = currentLoginIp;
		clone.lastLoginIp = lastLoginIp;
		clone.lastLoginAt = lastLoginAt;
		clone.lastRequestAt = lastRequestAt;
		clone.loginCount = loginCount;
		clone.nickname = nickname;
		clone.passwordConfirm = passwordConfirm;
		clone.persistenceToken = persistenceToken;
		clone.updatedAt = updatedAt;
		clone.roles = ArrayUtils.clone(roles);
		
		return clone;
	}
	
	//----------------------------------
	//  isNew
	//----------------------------------
	
	[Transient]
	/**
	 * The description of the role.
	 */
	public function get isNew():Boolean
	{
		return id == 0;
	}
	
	//----------------------------------
	//  memento
	//----------------------------------
	
	[Transient]
	/**
	 * Whether the item is the site master or not. 
	 * @ private
	 * Implements the IMementoRestore interface.
	 */
	public function get memento():IMemento
	{
		return new Memento(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Remote properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  persistenceToken
	//----------------------------------
	
	/**
	 * The id.
	 */
	public var id:int;
	
	//----------------------------------
	//  login
	//----------------------------------
	
	/**
	 * The login.
	 */
	public var login:String;
	
	//----------------------------------
	//  nickname
	//----------------------------------
	
	/**
	 * The nickname that is used to display the user in lists.
	 */
	public var nickname:String;
	
	//----------------------------------
	//  password
	//----------------------------------
	
	/**
	 * The password. This value is only used to create users and to reset
	 * their password. It is never returned from the remote server.
	 */
	public var password:String;
	
	//----------------------------------
	//  passwordConfirm
	//----------------------------------
	
	/**
	 * The password confirmation. This value is only used to create users and 
	 * to reset their password. It is never returned from the remote server.
	 */
	public var passwordConfirm:String;
	
	//----------------------------------
	//  persistenceToken
	//----------------------------------
	
	/**
	 * The persistence token used to automatically login the user.
	 */
	public var persistenceToken:String;
	
	//----------------------------------
	//  loginCount
	//----------------------------------
	
	/**
	 * The number of times the user has logged in.
	 */
	public var loginCount:int;
	
	//----------------------------------
	//  lastRequestAt
	//----------------------------------
	
	/**
	 * The timestamp of the last request by the user.
	 */
	public var lastRequestAt:Date;
	
	//----------------------------------
	//  lastLoginAt
	//----------------------------------
	
	/**
	 * The timestamp of the last login.
	 */
	public var lastLoginAt:Date;
	
	//----------------------------------
	//  lastLoginIp
	//----------------------------------
	
	/**
	 * The ip address of the last login.
	 */
	public var lastLoginIp:String;
	
	//----------------------------------
	//  currentLoginIp
	//----------------------------------
	
	/**
	 * The ip address of the current login.
	 */
	public var currentLoginIp:String;
	
	//----------------------------------
	//  oldPassword
	//----------------------------------
	
	/**
	 * The old password used in resetting passwords.
	 */
	public var oldPassword:String;
	
	//----------------------------------
	//  roles
	//----------------------------------
	
	/**
	 * The roles assigned to the user.
	 */
	public var roles:Array;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Adds a role to the user.
	 */
	public function addRoll(value:UserRole, forceSingular:Boolean):void
	{
		if (roles == null || forceSingular)
		{
			roles = [value];
			
		} else {
			
			//Check if the role is already set on the user
			var hasRole:Boolean = false;
			for each (var userRole:UserRole in roles)
			{
				hasRole = userRole.name == value.name;
				
				if (hasRole)
					break;
			}
			
			if (!hasRole)
			{
				roles.push(value);
			}
		}
	}
	
	/**
	 * @inheritDoc
	 * @ private
	 * Implements the IIsEqual interface.
	 */
	public function isEqual(value:Object):Boolean
	{
		if (value is CFUser)
		{
			var isEqual:Boolean = value.id == id &&
								  value.login == login &&
								  value.password == password &&
								  value.passwordConfirm == passwordConfirm &&
								  value.oldPassword == oldPassword &&
								  value.currentLoginIp == currentLoginIp &&
							      value.lastLoginIp == lastLoginIp &&
								  value.lastRequestAt == lastRequestAt &&
								  value.loginCount == loginCount &&
								  value.nickname == nickname &&
								  value.persistenceToken == persistenceToken &&
								  ComparisonUtils.isEqualArray(value.roles, 
									  roles);
			if (!isEqual)
			{
				return false;
			} else if (value.lastLoginAt == null && lastLoginAt == null) {
				return isEqual;
				
			} else if (value.lastLoginAt == null && lastLoginAt != null ||
				value.lastLoginAt != null && lastLoginAt == null) {
				
				return false;
				
			} else {
				
				return value.lastLoginAt.time == lastLoginAt.time;
			}
		}
		return false;
	}
	
	/**
	 * @inheritDoc
	 * @ private
	 * Implements the IMementoRestore interface.
	 */
	public function restore(memento:IMemento):*
	{
		memento.restore(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMementoRestore methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Maps the current properties of the object for storage in a memento. 
	 * This method should return a static map of the object. For simple objects
	 * that do not compose custom classes, return null from this function 
	 * and the memento will map itself. Use the namespace memento_internal
	 * in the function declaration.
	 */
	memento_internal function mapProperties():*
	{
		//We use a clone as the map since it is easier.
		return clone;
	}
	
	/**
	 * Hook that allows exception handling with default property mapping.
	 * If there are no exceptions, this function must return the value
	 * argument.Use the namespace memento_internal in the function declaration.
	 */
	memento_internal function propertyMapExceptions(property:String, 
													value:Object,
													isRestore:Boolean = false):Object
	{
		//Not using default.
		return value;
	}
	
	/**
	 * Restores properties using the memento's property map passed to it 
	 * from the memento. Return true if the property was remapped. Return 
	 * false to use the mementos internal restore for simple classes.Use the 
	 * namespace memento_internal in the function declaration.
	 */
	memento_internal function restoreProperties(propertyMap:Object):Boolean
	{
		id			  	 = propertyMap.id;
		login     		 = propertyMap.login;
		password 		 = propertyMap.password;
		passwordConfirm  = propertyMap.passwordConfirm;
		oldPassword   	 = propertyMap.oldPassword;
		createdAt 		 = propertyMap.createdAt;
		currentLoginIp   = propertyMap.currentLoginIp;
		lastLoginIp      = propertyMap.lastLoginIp;
		lastLoginAt      = propertyMap.lastLoginAt;
		lastRequestAt  	 = propertyMap.lastRequestAt;
		loginCount    	 = propertyMap.loginCount;
		nickname   		 = propertyMap.nickname;
		persistenceToken = propertyMap.persistenceToken;
		updatedAt        = propertyMap.updatedAt;
		roles      		 = propertyMap.roles;
		
		return true;
	}
	
	/**
	 * Used by a memento to determine if its state is equal to an objects
	 * state. If you are using the default property mapping, return the value
	 * of the mementoIsEqualFunction. Otherwise, return true if the propertyMap 
	 * state is equal to the state of the object (this). Use the namespace 
	 * memento_internal in the function declaration.
	 */
	memento_internal function stateIsEqual(propertyMap:Object,
										   mementoIsEqual:Function):Boolean
	{
		return isEqual(propertyMap);
	}
}

}
