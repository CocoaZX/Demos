//
//  ViewController.swift
//  DrogDemo
//
//  Created by 张鑫 on 2017/6/1.
//  Copyright © 2017年 CrowForRui. All rights reserved.
//

import UIKit

let kDeviceWidth = UIScreen.main.bounds.width
let kDeviceHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {

    var myBtns = NSMutableArray.init()//按钮
    var hotBtns = NSMutableArray.init()
    var startP = CGPoint.init()
    var buttonP = CGPoint.init()
    var myTags = NSMutableArray.init()//tags
    var hotTags = NSMutableArray.init()
    var hotTagsView = UIView.init()
    var myTitleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 50))
    var hotTitleView = UIView.init()
    var myTagsView = UIView.init()
    var scrollView = CustomScrollerView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //仿今日头条拖拽,数据格式不同自行修改
        self.view.addSubview(self.scrollView)
        self.configView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configView(){
        self.myTags .add(["name": Optional("推荐") ?? "","id":"0"] as NSDictionary)
        self.myTags.add(["name": Optional("1") ?? "","id":"1"] as NSDictionary)
        self.myTags.add(["name": Optional("2") ?? "","id":"2"] as NSDictionary)
        self.myTags.add(["name": Optional("3") ?? "","id":"3"] as NSDictionary)
        self.myTags.add(["name": Optional("4") ?? "","id":"4"] as NSDictionary)
        self.myTags.add(["name": Optional("5") ?? "","id":"5"] as NSDictionary)
        self.myTags.add(["name": Optional("6") ?? "","id":"6"] as NSDictionary)
        self.hotTags.add(["name": Optional("7") ?? "","id":"7"] as NSDictionary)
        self.hotTags.add(["name": Optional("8") ?? "","id":"8"] as NSDictionary)
        self.hotTags.add(["name": Optional("9") ?? "","id":"9"] as NSDictionary)
        self.hotTags.add(["name": Optional("10") ?? "","id":"10"] as NSDictionary)
        self.hotTags.add(["name": Optional("11") ?? "","id":"11"] as NSDictionary)
        self.hotTags.add(["name": Optional("12") ?? "","id":"12"] as NSDictionary)
        self.scrollView.showsVerticalScrollIndicator = false
        
        let myLabel = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: 100, height: 50))
        myLabel.text = "我的频道"
        myLabel.font = UIFont.italicSystemFont(ofSize: 22)
        self.myTitleView.addSubview(myLabel)
        let dropLabel = UILabel.init(frame: CGRect.init(x: myLabel.frame.size.width, y: 17, width: 100, height: 30))
        dropLabel.font = UIFont.systemFont(ofSize: 12)
        dropLabel.text = "长按拖拽可以排序"
        self.myTitleView.addSubview(dropLabel)
        self.scrollView.addSubview(self.myTitleView)
        self.myTagsView.frame = CGRect.init(x: 0, y: self.myTitleView.frame.size.height, width: kDeviceWidth, height: self.getMyTags(array: self.myTags))
        self.scrollView.addSubview(self.myTagsView)
        self.setMyTags()
        let hotLabel = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: 100, height: 50))
        hotLabel.text = "热门频道"
        hotLabel.font = UIFont.italicSystemFont(ofSize: 22)
        self.hotTitleView.addSubview(hotLabel)
        self.hotTitleView.frame = CGRect.init(x: 0, y: self.myTagsView.frame.origin.y + self.myTagsView.frame.size.height + 100, width: kDeviceWidth, height: 50)
        let addLabel = UILabel.init(frame: CGRect.init(x: myLabel.frame.size.width, y: 17, width: 100, height: 30))
        addLabel.font = UIFont.systemFont(ofSize: 12)
        addLabel.text = "点击添加频道"
        self.hotTitleView.addSubview(addLabel)
        self.scrollView.addSubview(self.hotTitleView)
        self.hotTagsView.frame = CGRect.init(x: 0, y: self.hotTitleView.frame.origin.y + self.hotTitleView.frame.size.height, width: kDeviceWidth, height: self.getMyTags(array: self.hotTags) * 3)
        self.scrollView.addSubview(self.hotTagsView)
        self.setHotTags()
    }
    
    func setHotTags(){
        for item in self.hotBtns {
            if let btn = item as? UIButton {
                btn.removeFromSuperview()
            }
        }
        self.hotBtns.removeAllObjects()
        var i = 0
        for item in self.hotTags {
            if let bigItem = item as? NSDictionary{
                let btn = UIButton.init(frame: CGRect.init(x: 10 + (i % 4) * Int((kDeviceWidth) / 4), y: (i / 4) * 110, width: Int((kDeviceWidth - 60) / 4), height: 80))
                btn.setImage(UIImage.init(named: "addSytebom"), for: UIControlState.normal)
                let titleStr = bigItem["name"] as! String!
                btn.setTitle(titleStr!, for: UIControlState.normal)
                btn.setTitleColor(UIColor.black, for: UIControlState.normal)
                btn.backgroundColor = UIColor.red
                btn.layer.masksToBounds = true
                btn.tag = Int((bigItem["id"] as? String)!)!
                btn.addTarget(self, action: #selector(addToMyTags(sender:)), for: UIControlEvents.touchUpInside)
                btn.layer.cornerRadius = 5
                self.hotBtns.add(btn)
                self.hotTagsView.addSubview(btn)
            }
            i = i + 1
        }
    }

    
    func addToMyTags(sender:UIButton){
        self.myBtns.add(sender)
        sender.removeFromSuperview()
        let array = NSMutableArray.init(capacity: 10)
        var canAdd = false
        for item in self.hotTags {
            if let bigItem = item as? NSDictionary{
                if canAdd {
                    array.add(bigItem)
                }
                if Int((bigItem["id"] as? String)!)! == sender.tag{
                    canAdd = true
                    self.myTags.add(bigItem)
                }
            }
        }
        self.resetNextBtn(sender: sender, allBtn: array,view: self.hotTagsView)
        self.setMyTags()
    }

    
    func finishMethod(sender:UIButton){
        if sender.title(for: UIControlState.normal) == "编辑" {
            var i = 0
            for item in self.myBtns {
                if i != 0 {
                    if let btn = item as? UIButton{
                        btn.setImage(UIImage.init(named: "deleteTag"), for: UIControlState.normal)
                    }
                }
                i = i + 1
            }
            sender.setTitle("完成", for: UIControlState.normal)
        }else{
            UserDefaults.standard.set(self.myTags, forKey: "customTags")
            UserDefaults.standard.synchronize()
            self.navigationController?.popViewController(animated: true)
        }
    }

    func getMyTags(array:NSArray) -> CGFloat{
        var lineheight = 0
        if array.count % 4 > 0 {
            lineheight = 40
        }
        return CGFloat((array.count) / 4 * 40 + lineheight)
    }
    
    func setMyTags(){
        for item in self.myBtns {
            if let btn = item as? UIButton {
                btn.removeFromSuperview()
            }
        }
        self.myBtns.removeAllObjects()
        var i  = 0
        for item in self.myTags {
            let btn = UIButton.init(frame: CGRect.init(x: 10 + CGFloat((i % 4)) * (kDeviceWidth / 4 - 3), y: 40 * CGFloat((i / 4)), width: (kDeviceWidth - 60) / 4, height: 35))
            if let itemDic = item as? NSDictionary {
                btn.setTitle(itemDic["name"]! as? String, for: UIControlState.normal)
                btn.tag = Int((itemDic["id"] as? String)!)!
                btn.layer.masksToBounds = false
                btn.setTitleColor(UIColor.black, for: UIControlState.normal)
                btn.backgroundColor = UIColor.gray
                btn.layer.cornerRadius = 5
                btn.addTarget(self, action: #selector(deleteMyBtn(sender:)), for: UIControlEvents.touchUpInside)
                let longGes = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressClick(sender:)))
                btn.addGestureRecognizer(longGes)
                self.myBtns.add(btn)
                self.myTagsView.addSubview(btn)
            }
            i = i + 1
        }
        self.myTagsView.frame.size.height = self.getMyTags(array: self.myTags)
        self.setBtnAnimalted()
    }
    
    func setBtnAnimalted(){
//        UIView.animate(withDuration: 0.2) {
//            self.hotTitleView.frame. = self.myTagsView.bottom + 5
//            self.hotTagsView.top = self.hotTitleView.bottom + 5
//            self.otherTitleView.top = self.hotTagsView.bottom
//            self.otherTagsView.top = self.otherTitleView.bottom + 5
//        }
    }
    
    func longPressClick(sender:UILongPressGestureRecognizer){
        let btn = sender.view as? UIButton
        if sender.state == UIGestureRecognizerState.began {
            UIView.animate(withDuration: 0.2) {
                btn?.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.5)
                btn?.alpha = 0.7
                self.startP = sender.location(in: btn)
                self.buttonP = (btn?.center)!
            }
        }
        
        if sender.state == UIGestureRecognizerState.changed {
            let newP = sender.location(in: btn)
            let movedX = newP.x - self.startP.x
            let movedY = newP.y - self.startP.y
            btn?.center = CGPoint.init(x: (btn?.center.x)! + movedX, y: (btn?.center.y)! + movedY)
            let fromIndex = self.myBtns.index(of: btn!)
            let toIndex = self.getMovedIndexByCurrentButton(sender: btn!)
            if toIndex < 1 {
                return
            }else{
                var i = fromIndex
                if fromIndex < toIndex {
                    while i < toIndex {
                        let nextBtn = self.myBtns[i + 1] as? UIButton
                        let tempP = nextBtn?.center
                        UIView.animate(withDuration: 0.5, animations: {
                            nextBtn?.center = self.buttonP
                        })
                        self.buttonP = tempP!
                        i = i + 1
                    }
                }else{
                    while i > toIndex {
                        let nextBtn = self.myBtns[i - 1] as? UIButton
                        let tempP = nextBtn?.center
                        UIView.animate(withDuration: 0.5, animations: {
                            nextBtn?.center = self.buttonP
                        })
                        self.buttonP = tempP!
                        i = i - 1
                    }
                }
                self.resetMyTagsArrayWithIndex(fromeIndex: fromIndex, toIndex: toIndex)
            }
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.2, animations: {
                btn?.transform = CGAffineTransform.identity
                btn?.alpha = 1.0
                btn?.center = self.buttonP
            })
        }
    }
    
    func resetMyTagsArrayWithIndex(fromeIndex:Int,toIndex:Int){
        let btn = self.myBtns.object(at: fromeIndex)
        self.myBtns.remove(btn)
        let obj = self.myTags.object(at: fromeIndex)
        self.myTags.remove(obj)
        self.myBtns.insert(btn, at: toIndex)
        self.myTags.insert(obj, at: toIndex)
    }

    func deleteMyBtn(sender:UIButton){
        if sender.tag == 0 {
            return
        }
        var itemTemp = NSDictionary()
        let allMyBtns = NSMutableArray.init()
        var canAdd = false
        for item in self.myTags {
            if let itemDic = item as? NSDictionary{
                if canAdd {
                    allMyBtns.add(itemDic)
                }
                if Int(String(describing: (itemDic["id"])!)) == sender.tag {
                    canAdd = true
                    sender.removeFromSuperview()
                    itemTemp = itemDic
                }
            }
        }
        if self.myTags.contains(itemTemp) {
            self.hotTags.add(itemTemp)
            self.myTags.remove(itemTemp)
        }
        self.myBtns.remove(sender)
        self.resetNextBtn(sender: sender, allBtn: allMyBtns, view: self.myTagsView)
        self.setHotTags()
        self.setBtnAnimalted()
    }

    func getMovedIndexByCurrentButton(sender:UIButton) -> Int{
        var i = 0
        for item in self.myBtns {
            if let currentBtn = item as? UIButton{
                if  currentBtn != sender{
                    if currentBtn.frame.contains(sender.center){
                        return i
                    }
                }
            }
            i = i + 1
        }
        return -1
    }


    func resetNextBtn(sender:UIButton,allBtn:NSArray,view:UIView){
        if allBtn.count == 0 {
            return
        }
        var tempCen = sender.center
        var tempTwo = sender.center
        var i = 0
        for item in allBtn {
            if let itemDic = item as? NSDictionary{
                if let btn = view.viewWithTag(Int(itemDic["id"] as! String)!){
                    tempTwo = btn.center
                    UIView.animate(withDuration: 0.3, animations: {
                        if i == 0{
                            btn.center = sender.center
                        }else{
                            btn.center = tempCen
                        }
                        tempCen = tempTwo
                    })
                }
                i = i + 1
            }
        }
    }

    

}

