////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils.popups
{
import com.fosrias.core.interfaces.AClass;

import flash.errors.IllegalOperationError;
import flash.geom.Point;

import mx.collections.ArrayCollection;

/**
 * The PopUpPosition class defines the position of a popup when it is opened
 * with a <code>PopUpLoader</code>. Either a relative position and 
 * padding can be set or a specific point relative to the parent.
 * 
 * @see com.fosrias.core.utils.PopUpLoader
 */
public class PopUpPosition extends AClass
{
	//--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------

    /**
     * The ABOVE position corresponds to popup positions above the top edge 
     * of a parent UIComponent.
     */
    public static const ABOVE:String 
        = "com.fosrias.core.utils.PopUpPosition.above";
    
    /**
     * The BELOW position corresponds to popup positions below the bottom edge 
     * of a parent UIComponent.
     */
    public static const BELOW:String 
        = "com.fosrias.core.utils.PopUpPosition.below";
    
    /**
     * The BOTTOM position corresponds to popup positions above a parent
     * UIComponent and aligned with its bottom edge.
     */
    public static const BOTTOM:String 
        = "com.fosrias.core.utils.PopUpPosition.bottom";
    
    /**
     * The CENTER position corresponds to popup positions centered above 
     * a parent UIComponent.
     */
    public static const CENTER:String 
        = "com.fosrias.core.utils.PopUpPosition.center";
    
    /**
     * The LEFT position corresponds to popup positions above a parent
     * UIComponent and aligned with its left edge.
     */
    public static const LEFT:String 
        = "com.fosrias.core.utils.PopUpPosition.left";
    
    /**
     * The RIGHT position corresponds to popup positions above a parent
     * UIComponent and aligned with its right edge.
     */
    public static const RIGHT:String 
        = "com.fosrias.core.utils.PopUpPosition.right";
    
    /**
     * The OUTSIDE_LEFT position corresponds to popup positions outside 
     * the left edge of a parent UIComponent.
     */
    public static const OUTSIDE_LEFT:String 
       = "com.fosrias.core.utils.PopUpPosition.outsideLeft";
    
    /**
     * The OUTSIDE_RIGHT position corresponds to popup positions outside 
     * the right edge of a parent UIComponent.
     */
    public static const OUTSIDE_RIGHT:String 
       = "com.fosrias.core.utils.PopUpPosition.outsideRight";
    
    /**
     * The TOP position corresponds to popup positions above a parent
     * UIComponent and aligned with its top edge.
     */
    public static const TOP:String 
        = "com.fosrias.core.utils.PopUpPosition.top";
        
    /**
     * @private 
     */
    private static const POSITIONS:Array = [ ABOVE, BELOW, BOTTOM, CENTER, 
                                             LEFT, RIGHT, OUTSIDE_LEFT, 
                                             OUTSIDE_RIGHT, TOP ];
	
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     * 
     * @param isAbsolute <code>true</code> if the position is an absolute
     * position relative to the stage.
     */
    public function PopUpPosition( isAbsolute:Boolean = false ) 
    {
        super( this );
        
        _isAbsolute = isAbsolute;
    }
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  clone
    //----------------------------------
    
    /**
     * A clone of the Position instance.
     */
    public function get clone():PopUpPosition
    {
    	var position:PopUpPosition = new PopUpPosition;
    	position.horizontalAlign = horizontalAlign;
    	position.verticalAlign = verticalAlign;
    	position.paddingLeft = paddingLeft;
    	position.paddingRight = paddingRight;
        position.paddingTop = paddingTop;
        position.paddingBottom = paddingBottom;
        if ( point != null)
        {
            position.point = new Point( point.x, point.y );
        }
        return position;
    }
    
    //----------------------------------
    //  hasPoint
    //----------------------------------
    
    /**
     * Whether the position has a point defined or not.
     */
    public function get hasPoint():Boolean
    {
        return point != null;
    }
    
    //----------------------------------
    //  horizontalAlign
    //----------------------------------
    
    /**
     * @private
     * Storage for the horizontalAlign property. 
     */
    private var _horizontalAlign:String = CENTER;
    
    /**
     * The horizontal alignment of the popup. 
     */
    public function get horizontalAlign():String
    {
    	return _horizontalAlign;
    }
    
    /**
     * @private
     */
    public function set horizontalAlign( value:String ):void
    {
    	if ( !contains( value ) )
    	{
    		throw new IllegalOperationError("No horizontal alignment '"
    		    + value + " defined in " + className + ".")
    	} 
    	_horizontalAlign = value;
    }
    
    //----------------------------------
    //  isAbsolute
    //----------------------------------
    
    /**
     * @private 
     * Storage for the isAbsolute property. 
     */
    private var _isAbsolute:Boolean;
    
    /**
     * Whether the position is absolute or not. If false, the position
     * is relative to a popup's parent. Otherwise, if the position has a point 
     * defined, it is relative to the stage.
     */
    public function get isAbsolute():Boolean
    {
        return _isAbsolute;
    }
    
    /**
     * @private
     */
    public function set isAbsolute( value:Boolean ):void
    {
    	_isAbsolute = value;
    }
	
    //----------------------------------
    //  verticalAlign
    //----------------------------------
    
    /**
     * @private
     * Storage for the verticalAlign property. 
     */
    private var _verticalAlign:String = CENTER;
	
    /**
     * The vertical alignment of the popup. 
     */
    public function get verticalAlign():String
    {
        return _verticalAlign;
    }
    
    /**
     * @private
     */
    public function set verticalAlign( value:String ):void
    {
        if ( !contains( value ) )
        {
            throw new IllegalOperationError("No vertical alignment '"
                + value + " defined in " + className + ".")
        } 
        _verticalAlign= value;
    }
    
    //----------------------------------
    //  isDefault
    //----------------------------------
    
    /**
     * Whether the position is the default position centered above the
     * parent UIComponent.
     */
    public function get isDefault():Boolean
    {
        return  horizontalAlign == CENTER &&
                verticalAlign == CENTER &&
                paddingLeft == 0 &&
                paddingRight == 0 &&
                paddingTop == 0 &&
                paddingBottom == 0 &&
                point == null;
    }
    
    //----------------------------------
    //  paddingBottom
    //----------------------------------
    
    /**
     * The padding  between the popup and its parent on the bottom edge 
     * of the popup.
     */
    public var paddingBottom:int = 0;
    
    //----------------------------------
    //  paddingLeft
    //----------------------------------
    
    /**
     * The padding between the popup and its parent on the left edge 
     * of the popup.
     */
    public var paddingLeft:int = 0;
	
	//----------------------------------
    //  paddingRight
    //----------------------------------
    
    /**
     * The padding  between the popup and its parent on the right edge 
     * of the popup.
     */
    public var paddingRight:int = 0;
    
	//----------------------------------
    //  paddingTop
    //----------------------------------
    
    /**
     * The padding  between the popup and its parent on the top edge 
     * of the popup.
     */
    public var paddingTop:int = 0;
    
	//----------------------------------
    //  point
    //----------------------------------
    
    /**
     * The point of the popup.
     * 
     * @default null;
     */
    public var point:Point = null;
    
    //--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function contains( value:String ):Boolean
    {
    	return new ArrayCollection( POSITIONS ).contains( value );
    }
}

}