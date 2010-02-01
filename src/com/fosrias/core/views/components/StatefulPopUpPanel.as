package com.fosrias.core.views.components
{
import com.fosrias.core.events.StateEvent;
import com.fosrias.core.utils.popups.StatefulPopUpLoaderDecorator;

import mx.core.UIComponent;

/**
 * The StatefulPopUpPanel is a subclass of <code>PopUpPanel</code> that 
 * is used with <code>AStateManager</code> managers, where the view state of 
 * the component is set by a StateEvent.SET_STATE event instead of
 * updating the <code>currentState</code> property.
 */    
public class StatefulPopUpPanel extends PopUpPanel
{
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function StatefulPopUpPanel()
	{
	   super(); 
	}
	
	/**
     * @private
     */
    override protected function setPopUpProperties( key:Object, 
        type:Object ):void
    {
        //Set loader decorators
        setLoaderDecorator( StatefulPopUpLoaderDecorator );
        
        //Call normal implementation    
        super.setPopUpProperties( key, type );
    }
    
    /**
     * @inheritDoc
     */
    override protected function setPopUpViewState( key:Object, 
        state:String = null ):void
    {
    	//Does nothing
    }
}

}