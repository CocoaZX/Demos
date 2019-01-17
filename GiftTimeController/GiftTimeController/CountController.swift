//
//  CountController.swift
//  GiftTimeController
//
//  Created by 张鑫 on 2017/5/19.
//  Copyright © 2017年 CrowForRui. All rights reserved.
//

import UIKit

class CountController: UIViewController,UITextFieldDelegate{
    var password = UITextField.init(frame: CGRect.init(x: 50, y: 250, width: kDeviceWidth - 100, height: 50))
    var countView = UIView.init(frame: CGRect.init(x: 50, y: 100, width: kDeviceWidth - 100, height: 300))
    var allCountLabel = UILabel.init(frame: CGRect.init(x: 0, y: 20, width: kDeviceWidth - 120, height: 100))
    var allCloseLabel = UILabel.init(frame: CGRect.init(x: 0, y: 200, width: kDeviceWidth - 120, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configView(){
        self.view.addSubview(password)
        self.view.addSubview(self.countView)
        self.countView.isHidden = true
        password.layer.borderColor = Utils.colorWithHexString(kLIkeGrayColor).cgColor
        password.layer.borderWidth = 1
        password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.passwordChange()
        return true
    }
    
    func passwordChange(){
        if password.text == "123456" {
            self.showCountView()
        }
    }
    
    func showCountView(){
        password.isHidden = true
        password.isUserInteractionEnabled = false
        self.countView.isHidden = false
        if let allClose = UserDefaults.standard.object(forKey: "allClose") as? String{
            self.allCloseLabel.text = "总共关闭 \(allClose)"
            self.countView.addSubview(self.allCloseLabel)
        }
        
        if let allCount = UserDefaults.standard.object(forKey: "allCount") as? String{
            self.allCountLabel.text = "总共使用完成 \(allCount)"
            self.countView.addSubview(self.allCountLabel)
        }
    }
    

}
