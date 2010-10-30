package com.fosrias.core.vos
{
import flash.events.Event;
import flash.events.EventDispatcher;

[RemoteClass(alias="com.fosrias.site.components.physical.User")]
[Bindable]
/**
 * The CFUser class is a user class for use with ColdFusion sites.
 */
public class CFUser extends EventDispatcher
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
						   oldPassword:String = null)
	{
		this.id = id;
		this.login = login; 
		this.password = password;
	} 
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isNew
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public function get isNew():Boolean
	{
		return id != 0;
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
	 * The description of the role.
	 */
	public var persistenceToken:String;
	
	//----------------------------------
	//  loginCount
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public var loginCount:int;
	
	//----------------------------------
	//  lastRequestAt
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public var lastRequestAt:Date;
	
	//----------------------------------
	//  lastLoginAt
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public var lastLoginAt:Date;
	
	//----------------------------------
	//  lastLoginIp
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public var lastLoginIp:String;
	
	//----------------------------------
	//  currentLoginIp
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public var currentLoginIp:String;
	
	//----------------------------------
	//  oldPassword
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public var oldPassword:String;
	
	//----------------------------------
	//  roles
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the roles property.
	 */
	private var _roles:Array

	[Bindable("roleChange")]
	/**
	 * The description of the role.
	 */
	public function get roles():Array
	{
		return _roles;
	}

	/**
	 * @private
	 */
	public function set roles(value:Array):void
	{
		_roles = value;
		
		dispatchEvent(new Event("roleChange") );
	}

	//----------------------------------
	//  createdAt
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public var createdAt:Date;
	
	//----------------------------------
	//  updatedAt
	//----------------------------------
	
	/**
	 * The description of the role.
	 */
	public var updatedAt:Date;
	
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
		if (_roles == null || forceSingular)
		{
			_roles = [value];
			
		} else {
			
			//Check if the role is already set on the user
			var hasRole:Boolean = false;
			for each (var userRole:UserRole in _roles)
			{
				hasRole = userRole.name == value.name;
				
				if (hasRole)
					break;
			}
			
			if (!hasRole)
				_roles.push(value);
		}
		dispatchEvent(new Event("roleChange") );
	}
}

}
