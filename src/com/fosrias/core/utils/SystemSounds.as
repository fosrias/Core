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
import flash.media.Sound;

import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
	
/**
 * The SystemSounds class is a static utility that plays sounds. The sounds are 
 * defined in a custom stylesheet ".systemSounds" for the class.
 */	
public class SystemSounds
{
    //--------------------------------------------------------------------------
    //
    //  Contants
    //
    //--------------------------------------------------------------------------
    
    /**
     * The constant WARN is associated with a warn sound in the stylesheet. 
     */
    public static const WARN:String = "warn";
    
    /**
     * The constant CLICK is associated with a click sound in the stylesheet. 
     */
    public static const CLICK:String = "click";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function SystemSounds() {}
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Plays a sound.
     * 
     * @param type The type of sound to play. Valid options are 
     * the constants.
     */
    public static function play( type:String ):void
    {
        //Get the current style declaration
    	var css:CSSStyleDeclaration = StyleManager.getStyleManager(null).
            getStyleDeclaration(".systemSounds");
        
        //Get the sound style
    	var soundClass:Class = css.getStyle( type );
    	
    	//Play the sound
    	if ( soundClass != null )
    	{
	    	var sound:Sound = Sound(new soundClass);
	        sound.play();
        }
    }
}

}