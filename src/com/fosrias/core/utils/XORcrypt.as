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
 
import mx.utils.Base64Decoder;
import mx.utils.Base64Encoder;
 
public class XORcrypt 
{
 
    public static var KEY:String = 
        "eVBHOulunx8A6spikeRQ9UEgyaXINTyzpn3SJ7FSzmwSlewTWI3";
 
    private static function xor(source:String):String {
        var key:String = KEY;
        var result:String = new String();
        for(var i:Number = 0; i < source.length; i++) {
            if(i > (key.length - 1)) {
                key += key;
            }
            result += String.fromCharCode(source.charCodeAt(i) ^ 
                key.charCodeAt(i));
        }
        return result;
    }
 
    public static function encode(source:String):String {
        var encoder:Base64Encoder = new Base64Encoder();
        encoder.encode(XORcrypt.xor(source));
        
        //Hack for Firefox which chokes on value strings containing \n
        var regExp:RegExp = new RegExp("\n", "gi");
        return encoder.flush().replace(regExp,"--");
    }
 
    public static function decode(source:String):String {
        var encoder:Base64Decoder = new Base64Decoder();
        
        //Hack for Firefox which chokes on value strings containing \n
        var regExp:RegExp = new RegExp("--", "gi");
        encoder.decode(source.replace(regExp,"\n"));
        return XORcrypt.xor(encoder.flush().toString());
    }
}
 
}