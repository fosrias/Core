////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.fosrias.core.utils
{
import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.formatters.CurrencyFormatter;
import mx.formatters.DateFormatter;
import mx.formatters.NumberFormatter;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.utils.StringUtil;

/**
 * The FormatterUtils class is a utility class that returns
 * localized formatter instances.
 */
public class FormatterUtils
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public function FormatterUtils() {}
    
    //--------------------------------------------------------------------------
    //
    //  Static properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * A <code>DateFormatter</code> instance with localized date formatting. 
     */
    public static function dateFormatter():DateFormatter
    {
        var resourceManager:IResourceManager = ResourceManager.getInstance();
        var formatter:DateFormatter = new DateFormatter;
        
        formatter.formatString = resourceManager.getString('FormattingValues', 
            'DATE_FORMAT');
        return formatter;
    }
    
    /**
     * A <code>DateFormatter</code> instance with localized full year date 
     * formatting. 
     */
    public static function dateFullYearFormatter():DateFormatter
    {
        var formatter:DateFormatter = dateFormatter();
        
        //Replace partial year with full year.
        if (!formatter.formatString.match(/YYYY/))
            formatter.formatString = formatter.formatString.replace(/YY/, 
                'YYYY');
        return formatter;
    }
    
    /**
     * A <code>CurrencyFormatter</code> instance with localized currency 
     * formatting. 
     */
    public static function currencyFormatter(showThousands:Boolean = true
        ):CurrencyFormatter
    {
        var resourceManager:IResourceManager = ResourceManager.getInstance();
        var formatter:CurrencyFormatter = new CurrencyFormatter;
        
        formatter.precision = resourceManager.getInt('FormattingValues', 
            'CURRENCY_PRECISION');
        formatter.currencySymbol = resourceManager.getString('FormattingValues', 
            'CURRENCY_SYMBOL');
        if(showThousands)
        {
            formatter.thousandsSeparatorTo= resourceManager.getString(
                'FormattingValues', 'THOUSANDS_SEPARATOR');
        } else {
            formatter.thousandsSeparatorTo = '';
        }
        formatter.decimalSeparatorTo= resourceManager.getString(
            'FormattingValues', 'DECIMAL_SEPARATOR');
        return formatter;
    } 
    
    /**
     * A <code>NumberFormatter</code> instance with localized number formatting. 
     */
    public static function numberFormatter(showThousands:Boolean = true
        ):NumberFormatter
    {
        var resourceManager:IResourceManager = ResourceManager.getInstance();
        var formatter:NumberFormatter = new NumberFormatter;
        
        if(showThousands)
        {
            formatter.thousandsSeparatorTo= resourceManager.getString(
                'FormattingValues', 'THOUSANDS_SEPARATOR');
        } else {
            formatter.thousandsSeparatorTo = '';
        }
        formatter.decimalSeparatorTo= resourceManager.getString(
            'FormattingValues', 'DECIMAL_SEPARATOR');
        return formatter;
    } 
    
    /**
     * A <code>DateFormatter</code> instance with localized time formatting. 
     */
    public static function timeFormatter():DateFormatter
    {
        var resourceManager:IResourceManager = ResourceManager.getInstance();
        var formatter:DateFormatter = new DateFormatter;
        
        var format:String = resourceManager.getString('FormattingValues', 
            'TIME_FORMAT');
        formatter.formatString = format
        
        
        //Hack if localization not set up
        if (format == null)
            formatter.formatString = "L:NN A";
        
        return formatter;
    }
}

}