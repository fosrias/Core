package com.fosrias.core.views.components
{
import spark.components.RichEditableText;

/**
 * The AutoScaleRichEditableText class is used as the textDisplay object in 
 * skins that auto-scale in the vertical direction. More complicated in the
 * horizontal direction so I leave that to someone else. 
 * 
 * @see com.fosrias.components.AutoScalingTextAreaSkin.mxml
 */
public class AutosizingRichEditableText extends RichEditableText
{
	public function AutosizingRichEditableText()
	{
		super();
	}
	
	/**
	 *  We allow the heightConstraint to be NaN if the corresponding autoScale 
	 * value is true.
	 */
	override public function setLayoutBoundsSize(width:Number, 
												 height:Number,
												 postLayoutTransform:Boolean 
												 	 = true):void
	{
		super.setLayoutBoundsSize(width, height, postLayoutTransform);
		
		//This is all it takes (plus hours of tracing source code)
		heightInLines  = NaN;
	}
}

}