package com.fosrias.core.vos
{

/**
* The CallResult class is a value object for call results 
 * returned from the server. 
*/
[RemoteClass(alias="com.fosrias.core.vos.CallResult")]
public class CallResult
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function CallResult() {}   
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  data
    //----------------------------------
    
    /**
     * The data of the CallResult. 
     */
    public var data:Object;
    
    //----------------------------------
    //  message
    //----------------------------------
    
    /**
     * The message of the CallResult. 
     */
    public var message:String;

}

}