////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.validators
{
import mx.validators.ValidationResult;
import mx.validators.Validator;

public class URLValidator extends Validator 
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function URLValidator() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	private var _invalidUrlError:String = "This is an invalid URL.";
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  domainOnly
	//----------------------------------
	
	/**
	 *  Whether to check for a valid domain only.
	 */
	public var domainOnly:Boolean = false;
	
	//----------------------------------
	//  invalidUrlError
	//----------------------------------
	
	[Inspectable(category="Errors", defaultValue="null")]
	/**
	 *  Error message when a string is not a valid url. 
	 *  @default "This is an invalid url."
	 */
	public function get invalidUrlError():String 
	{
		return _invalidUrlError;
	}
	
	/**
	 *  @private
	 */
	public function set invalidUrlError(value:String):void 
	{
		_invalidUrlError = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @inheritDoc
	 */
	override protected function doValidation(value:Object):Array 
	{
		var results:Array = super.doValidation(value);
		if ( !isUrl(value.toString(), domainOnly) ) 
		{
			results.push( new ValidationResult(true, "", 
				"invalidUrl", invalidUrlError) );   
		}
		return results;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Static methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Tests the url string for validity.
	 */
	public static function isUrl(url:String, domainOnly:Boolean):Boolean 
	{
		var regexp:RegExp;

		if (domainOnly)
		{
			//Refactor using this code to download and test this.
			//http://publicsuffix.org/
			regexp = /^[a-z0-9\-]{2,63}\.\w{2,3}/;
			
				///(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
		} else {
			regexp =
				/(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/; 
		}
		return regexp.test(url);
	}
}

}