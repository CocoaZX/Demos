//
//  Utils.swift
//  Gift
//
//  Created by 张鑫 on 2017/2/11.
//  Copyright © 2017年 CrowForRui. All rights reserved.
//


import UIKit

var KDeviceWidth = UIScreen.main.bounds.size.width
var KDeviceHeight = UIScreen.main.bounds.size.height
let kLikeGrayColor : NSString = "#a7a7a7"
let kLikeArtGray : NSString = "#efefef"
let kLIkeBlackBase : NSString = "#363636"
class Utils: NSObject {

    class func colorWithHexString(_ colorStr:NSString) -> UIColor {
        var cString = "\(colorStr.uppercased)"
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if cString.lengthOfBytes(using: String.Encoding.utf8) != 6 {  
            return UIColor.black
        }
        
        let rStr = cString.subString(0, to: 2)
        let gStr = cString.subString(2, to: 4)
        let bStr = cString.subString(4, to: 6)
        var r = CUnsignedInt()
        var g = CUnsignedInt()
        var b = CUnsignedInt()
        
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string:gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)
        
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }

    class func getStringWidthWithStr(text:String) -> CGFloat{
        return 150
    }
    
}



