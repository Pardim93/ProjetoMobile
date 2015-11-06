//
//  Colors.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 16/10/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

extension UIColor {
    class func newGreenColor() -> UIColor {
        return UIColor(red: 0, green: 199/255, blue: 98/255, alpha: 1)
        //00C762
    }
    
    //    class func newBlueColor() -> UIColor{
    //        return UIColor(red: 0, green: 128/255, blue: 1, alpha: 1.0)
    ////        #0080FF
    //    }
    
    class func newBlueColor() -> UIColor{
        return UIColor(red: 15/255, green: 59/255, blue: 95/255, alpha: 1.0)
        //         #0F3B5F
    }
    
    class func newLightBlueColor() -> UIColor{
//        return UIColor(red: 94/255, green: 157/255, blue: 200/255, alpha: 1.0)
        //         #5E9DC8
        
        return UIColor(red: 0/255, green: 119/255, blue: 187/255, alpha: 1.0)
        //#0077BB
    }
    
    class func newAuxBlueColor() -> UIColor{
        return UIColor(red: 0, green: 14/255, blue: 197/255, alpha: 1.0)
        //000EC5
    }
    
    class func newOrangeColor() -> UIColor{
        return UIColor(red: 204/255, green: 151/255, blue: 82/255, alpha: 1.0)
        //    #CC9752
    }
    
    class func newPearlColor() -> UIColor{
        return UIColor(red: 229/255, green: 219/255, blue: 207/255, alpha: 1.0)
        //    #E5DBCF
    }
    
    class func newGrayColor() -> UIColor{
        return UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        //    #CCCCCC
    }
}

extension UIColor {
    static func colorWithHexString (hex: String, alph: Float) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alph))
    }
}
