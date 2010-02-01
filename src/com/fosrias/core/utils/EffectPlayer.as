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
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.effects.Effect;
import mx.effects.EffectManager;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.events.MoveEvent;
import mx.events.ResizeEvent;

use namespace mx_internal;

/**
 * The EffectPlayer class plays and/or retrieves effects defined in mxml 
 * tags of a UIComponent that cannot otherwise be accessed externally.
 */
public class EffectPlayer
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function EffectPlayer() {}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Retrieves the effect from the target UIComponent, if any.
     * 
     * @param target The UIComponent target to play its own effect on.
     * @param effectType The type of effect to retrieve.
     */
    public static function effect( target:UIComponent, 
         effectType:String ):Effect
    {
        var effectEvent:String = eventType( effectType );
        
        if ( effectEvent == null )
           return null;
           
        return EffectManager.mx_internal::createEffectForType( target, 
                                                               effectEvent ); 
    }

    /**
     * Retrieves the event type corresponding to the effect.
     * 
     * @param effectType The effect name to retrieve the corresponding event.
     */
    public static function eventType( effectType:String ):String
    {
    	switch ( effectType )
    	{
    		case "added", "addedEffect": return Event.ADDED;
    		
    		case "creationComplete", "creationCompleteEffect": 
    		    return FlexEvent.CREATION_COMPLETE;
            
            case "focusIn", "focusInEffect": return FocusEvent.FOCUS_IN;
            
            case "focusOut", "focusOutEffect": return FocusEvent.FOCUS_OUT;
            
            case "hideEffect", "hideEffect": return FlexEvent.HIDE;
            
            case "mouseDown", "mouseDownEffect": return MouseEvent.MOUSE_DOWN;
            
            case "mouseUp", "mouseUpEffect": return MouseEvent.MOUSE_UP;
            
            case "move", "moveEffect": return MoveEvent.MOVE;
            
            case "resize", "resizeEffect": return ResizeEvent.RESIZE;
            
            case "rollOut", "rollOutEffect": return MouseEvent.ROLL_OUT;
            
            case "rollOver", "rollOverEffect": return MouseEvent.ROLL_OVER;
            
            case "show", "showEffect": return FlexEvent.SHOW;
            
            default: return null;
    	}
    }
    
    /**
     * Begins playing the effect. 
     * 
     * @param target The UIComponent target to play its own effect on.
     * @param effectType The type of effect to play.
     * @param effectEnd The effect end handler.
     * @param effectStart The effect start handler.
     */
    public static function play( target:UIComponent, effectType:String,
        effectEndHandler:Function = null, effectStartHandler:Function = null, 
        playReversedFromEnd:Boolean = false ):Effect
    {
        var effectInst:Effect = effect( target, effectType );
            
        if ( effectInst == null )
            return null;
        
        //Stop any previously playing instances
        effectInst.end();
        
        //Add handlers
        if ( effectEndHandler != null )
        {
            //Use weak reference since cannot control when destroyed.
            effectInst.addEventListener( EffectEvent.EFFECT_END, 
                                         effectEndHandler, false, 0, true );
        }
        
        if ( effectStartHandler != null )
        {
            //Use weak reference since cannot control when destroyed.
            effectInst.addEventListener( EffectEvent.EFFECT_START, 
                                         effectStartHandler, false, 0, true );
        } 
        
        //Make sure everything is current before playing the effect.
        UIComponent( target ).validateNow();
        
        //Play the effect
        effectInst.play( [ target ] , playReversedFromEnd );
        
        return effectInst;
    } 
}

}