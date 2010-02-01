////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils
{

/**
 * System-wide constants
 *  
 * @author mfoster
 * 
 */
public class SystemConstants
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     * Boolean integer version of false for use with remote data.
     */
    public static const BOOLEAN_FALSE_INT:int = 0; 
    
    /**
     * Boolean integer version of true for use with remote data.
     */
    public static const BOOLEAN_TRUE_INT:int = 1; 
    
    /**
     * Default ActionEnum ordinal for initializing date variables
     */
    public static const DEFAULT_ACTION_ORDINAL:int = 2; //Watch
    
    /**
     * Default date for initializing date variables
     */
    public static const DEFAULT_DATE:String = "1990-01-01 00:00:00";
    
    /**
     * Default id for initializing id variables
     */
    public static const DEFAULT_ID:int = -10000001;
    
    /**
     * Default string for initializing string variables
     */
    public static const DEFAULT_String:String = "";
    
    /**
     * Default None enum ordinal
     */
    public static const DEFAULT_NONE_ENUM_ORDINAL:int = -1; 
    
    /**
     * Default None enum value
     */
    public static const DEFAULT_NONE_ENUM_VALUE:String = "None";
    
    /**
     * Default SecurityTypeEnum ordinal for initializing date variables
     */
    public static const DEFAULT_SECURITY_TYPE_ORDINAL:int = 2; //Stock
    
    /**
     * Default Date format for persistent dates
     */
    public static const DEFAULT_PERSISTENT_DATE_FORMAT:String = "YYYY-MM-DD";
    
    /**
     * Default Date format for persistent dates
     */
    public static const DEFAULT_PERSISTENT_DATETIME_FORMAT:String = 
        "YYYY-MM-DD NN:SS:00";
  
    /**
     * Limit for items stored in Queue for recent target testing
     */
    public static const ITEM_QUEUE_SIZE:int = 40; 
    
    /**
     * Cutoff for recent target testing
     */
    public static const TARGET_TEST_CUTOFF:int = 40; 
    
    /**
     * Journal recommendation progress bar maximum
     */
    public static const JOURNAL_RECOMMENDATION_MAXIMUM:int = 23;    	
	
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /** 
     * Constructor
     */
    public function SystemConstants()
    {
    	 if (_created)
        {
            throw new Error("The SystemContants is already created.");
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     * Internal variable used to check if the class has been instantiated 
     */    
    private static var _created:Boolean = false;
        
    /**
     * @private
     * Static Code Block to keep one instance instantiated
     */
    {
        _created = true;
    }
}

}