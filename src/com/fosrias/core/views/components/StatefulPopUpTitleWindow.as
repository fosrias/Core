package com.fosrias.core.views.components
{
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.utils.popups.StatefulPopUpLoaderDecorator;

import mx.core.UIComponent;

/**
 * The StatefulPopUpTitleWindow is a subclass of <code>PopUpTitleWindow</code> 
 * that is used with <code>AStateManager</code> managers, where the view 
 * state of the component is set by a StateEvent.SET_STATE event instead of
 * updating the <code>currentState</code> property.
 */    
public class StatefulPopUpTitleWindow extends PopUpTitleWindow
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function StatefulPopUpTitleWindow()
	{
	   super(); 
	}
	
	/**
     * @private
     */
    override protected function afterSetPopUpProperties( key:Object, 
        type:Object ):void
    {
        //Set loader decorators
        setLoaderDecorator( StatefulPopUpLoaderDecorator );
    }
    
    /**
     * @inheritDoc
     */
    override protected function setPopUpViewState( key:Object, 
        state:String  = null ):void
    {
        //Do Nothing
    }
}

}