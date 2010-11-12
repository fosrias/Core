////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009-2010 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.validators
{
import com.fosrias.core.interfaces.AFactory;

import mx.validators.CreditCardValidator;
import mx.validators.CurrencyValidator;
import mx.validators.DateValidator;
import mx.validators.EmailValidator;
import mx.validators.NumberValidator;
import mx.validators.PhoneNumberValidator;
import mx.validators.RegExpValidator;
import mx.validators.SocialSecurityValidator;
import mx.validators.StringValidator;
import mx.validators.ZipCodeValidator;

public class ValidatorFactory extends AFactory
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * Defines the type used to create a <code>ConfirmationValidator</code>. 
     */    
    public static const CONFIRMATION:String 
        = "com.fosrias.core.validators.confirmation";
    
    /**
     * Defines the type used to create a <code>CreditCardValidator</code>. 
     */    
    public static const CREDIT_CARD:String = "com.adobe.validators.creditCard";
    
    /**
     * Defines the type used to create a <code>CurrencyValidator</code>. 
     */    
    public static const CURRENCY:String = "com.adobe.validators.currency";
    
    /**
     * Defines the type used to create a <code>DateValidator</code>. 
     */    
    public static const DATE:String = "com.adobe.validators.date";
    
    /**
     * Defines the type used to create a <code>DateComparisonValidator</code>. 
     */    
    public static const DATE_COMPARISON:String 
        = "com.fosrias.core.validators.dateComparison";
    
    /**
     * Defines the type used to create a <code>EmailValidator</code>. 
     */    
    public static const EMAIL:String = "com.adobe.alidators.email";
    
    /**
     * Defines the type used to create a <code>NumberValidator</code>. 
     */    
    public static const NUMBER:String = "com.adobe.validators.number";
    
    /**
     * Defines the type used to create a <code>Validator</code>. 
     */    
    public static const PHONE_NUMBER:String 
        = "com.adobe.validators.phoneNumber";
    
    /**
     * Defines the type used to create a <code>RegExpValidator</code>. 
     */    
    public static const REG_EXP:String = "com.adobe.validators.regExp";
    
    /**
     * Defines the type used to create a <code>SocialSecurityValidator</code>. 
     */    
    public static const SOCIAL_SECURITY:String 
        = "com.adobe.validators.socialSecurity";
    
    /**
     * Defines the type used to create a <code>StringValidator</code>. 
     */    
    public static const STRING:String = "com.adobe.validators.string";
    
    /**
     * Defines the type used to create a <code>ZipCodeValidator</code>. 
     */    
    public static const ZIP_CODE:String = "com.adobe.validators.zipCode";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function ValidatorFactory() 
    {
        super( this );
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     */
    override protected function instantiateImpl( factoryType:*, 
        type:*, args:Array):*
    {
    	return new factoryType;
    }
    
    /**
     * inheritDoc
     */
    override protected function mapImpl():void
    {
        _map[ CONFIRMATION ] = ConfirmationValidator;;
        _map[ CREDIT_CARD ] = CreditCardValidator;      
        _map[ CURRENCY ] = CurrencyValidator;
        _map[ DATE ] = DateValidator;
        _map[ DATE_COMPARISON ] = DateComparisonValidator;
        _map[ EMAIL ] = EmailValidator;
        _map[ NUMBER ] = NumberValidator;
        _map[ PHONE_NUMBER ] =  PhoneNumberValidator;
        _map[ REG_EXP ] =  RegExpValidator;
        _map[ SOCIAL_SECURITY ] = SocialSecurityValidator;
        _map[ STRING ] = StringValidator;
        _map[ ZIP_CODE ] = ZipCodeValidator;
    }
    
    /**
     * inheritDoc
     */
    override protected function typesImpl():Array
    {
        return [ CONFIRMATION, 
                 CREDIT_CARD, 
                 CURRENCY, 
                 DATE,
                 DATE_COMPARISON, 
                 EMAIL, 
                 NUMBER, 
                 PHONE_NUMBER, 
                 REG_EXP, 
                 SOCIAL_SECURITY, 
                 STRING, 
                 ZIP_CODE ];
    }
}

}