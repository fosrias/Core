////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.site.views.components
{
import com.asfusion.mate.core.GlobalDispatcher;
import com.fosrias.site.events.SiteEvent;
import com.fosrias.site.views.skins.ItemLinkButtonSkin;

import flash.events.MouseEvent;
import flash.text.TextFormat;

import mx.controls.ButtonPhase;
import mx.controls.LinkButton;
import mx.core.FlexGlobals;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Roll over alpha of the button skin.
 * 
 *  The default value is <code>1</code>.
 * 
 */
[Style(name="rollOverAlpha", type="Number", format="Number", inherit="yes")]

/**
 *  Roll over text decoration of the link button.
 * 
 *  The default value is <code>none</code>.
 * 
 */
[Style(name="rollOverTextDecoration", type="String", enumeration="none,underline", inherit="yes")]

/**
 * The ItemLinkButton is custom button that dispatches a 
 * <code>SiteEvent.LINK_CLICK</code> event into the application event flow.
 * The reference property of the event contains the name of the link.
 */
public class ItemLinkButton extends LinkButton
{
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static var classConstructed:Boolean = classConstruct();
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function ItemLinkButton()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  openLinkEnabled
	//----------------------------------
	
	/**
	 * Whether the link dispatches a <code>SiteEvent.OPEN_LINK</code> event
	 * or not.
	 */
	public var openLinkEnabled:Boolean = true;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override protected function clickHandler(event:MouseEvent):void
	{
		super.clickHandler(event);
		
		if (openLinkEnabled)
		    FlexGlobals.topLevelApplication.dispatchEvent( 
				new SiteEvent(SiteEvent.OPEN_LINK, null, label ) );
	}
	
	// Override the styleChanged() method to detect changes in your new style.
	override public function styleChanged(styleProp:String):void {
		
		super.styleChanged(styleProp);
		
		// Check to see if style changed. 
		if (styleProp=="rollOverAlpha" || 
			styleProp=="rollOverTextDecoration") 
		{
			changeSkins();
		}
	}
	
	/**
	 * @inheritDoc
	 */
	override mx_internal function viewSkinForPhase(tempSkinName:String, 
												   stateName:String):void 
	{
		super.viewSkinForPhase(tempSkinName, stateName);
		
		var textFormat:TextFormat = new TextFormat;
		
		if (enabled)
		{
			if (phase == ButtonPhase.OVER || phase == ButtonPhase.DOWN)
				textFormat.underline = getStyle(
					"rollOverTextDecoration") == "underline";
			else
				textFormat.underline = getStyle("textDecoration") == "underline";
			
			textField.setTextFormat(textFormat);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Static methods: initialization
	//
	//--------------------------------------------------------------------------
	
	// Define a static method.
	private static function classConstruct():Boolean 
	{
		var myLinkButtonStyle:CSSStyleDeclaration = 
			FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration(
				"com.fosrias.site.views.components.ItemLinkButton");
		
		if (!myLinkButtonStyle)
		{
			// If there is no CSS definition for ItemLinkButton, 
			// then create one and set the default value.
			myLinkButtonStyle = new CSSStyleDeclaration();
			myLinkButtonStyle.defaultFactory = function():void
			{
				this.rollOverAlpha = 1;
				this.rollOverTextDecoration = "none";
				this.skin = ItemLinkButtonSkin;
			}
			FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration(
				"com.fosrias.site.views.components.ItemLinkButton", 
				myLinkButtonStyle, true);
		} else {
			
			if (myLinkButtonStyle.getStyle("rollOverAlpha") == undefined)
				myLinkButtonStyle.setStyle("rollOverAlpha", 1);
			
			if (myLinkButtonStyle.getStyle("rollOverTextDecoration") == undefined)
				myLinkButtonStyle.setStyle("rollOverTextDecoration", "none");
			
			if (myLinkButtonStyle.getStyle("skin") == undefined)
				myLinkButtonStyle.setStyle("skin", ItemLinkButtonSkin);
			
			
		}
		return true;
	}
}
	
}