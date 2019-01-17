//
//  ShowMessage.swift
//  GiftTimeController
//
//  Created by 张鑫 on 2017/5/19.
//  Copyright © 2017年 CrowForRui. All rights reserved.
//

import UIKit

class ShowMessage: UIView{
    class func showMessage(con:UIViewController,message:String){
        let labelWidth = Utils.getStringWidthWithStr(text: message)
        let baseView = UIView.init(frame: CGRect.init(x:(kDeviceWidth - labelWidth)/2 , y: kDeviceHeight/2 - 30, width: labelWidth, height: 50))
        let contentLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: labelWidth, height: 50))
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = Utils.colorWithHexString(kLikeTextColor)
        contentLabel.text = message
        contentLabel.textAlignment = NSTextAlignment.center
        baseView.addSubview(contentLabel)
        con.view.addSubview(baseView)
        //延时1秒执行
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            baseView.removeFromSuperview()
        }
    }
    


}
