//
//  ViewController.swift
//  Gift
//
//  Created by 张鑫 on 2017/2/10.
//  Copyright © 2017年 CrowForRui. All rights reserved.
//
import UIKit
import Photos
import SQLite

class ViewController: UIViewController{
    var playBtn = UIButton.init(type: UIButtonType.custom)
    var pauseBtn = UIButton.init(type: UIButtonType.custom)
    var timer : Timer? = nil
    var currentTime = 15 * 60 + 1
    var contentLabel = UILabel.init()
    var isPause = false
    var tap : UITapGestureRecognizer? = nil
    var long : UILongPressGestureRecognizer? = nil
    var countCon : CountController? = nil
    var localNote = UILocalNotification.init()
    var timePic = UIPickerView()
    var allTime = integer_t()
    var changeBtn = UIButton.init()
    @IBOutlet var grayView: UIView!
    @IBOutlet var backImage: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.configView()
        self.addTimePickView()
        self.addNotification()
        self.setSqliteValue()
    }
    
    func addTimePickView() {
        timePic = UIPickerView.init(frame: CGRect(x: 10, y: 100, width: KDeviceWidth - 20, height: 150))
        timePic.delegate = self
        timePic.dataSource = self
        timePic.layer.cornerRadius = 8;
        timePic.layer.masksToBounds = true
        timePic.backgroundColor = Utils.colorWithHexString(kLikeArtGray)
        timePic.selectRow(14, inComponent: 0, animated: true)
        self.view.addSubview(timePic)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @available(iOS 9.0, *)
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }
    
    
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name(rawValue: "applicationDidEnterBackground"), object: nil)
    }

    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func configView(){
        self.playBtn.frame = CGRect.init(x: kDeviceWidth/2 - 40, y: 350, width: 80, height: 50)
        self.playBtn.setTitle("开始", for:UIControlState.normal)
        self.playBtn.backgroundColor = Utils.colorWithHexString(kLIkeBlackColor)
        self.playBtn.layer.masksToBounds = true
        self.playBtn.layer.cornerRadius = 10
        self.playBtn.addTarget(self, action: #selector(beginMethod(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.playBtn)
        self.pauseBtn.frame = CGRect.init(x: kDeviceWidth/2 - 40, y: kDeviceHeight - 150, width: 80, height: 50)
        self.pauseBtn.setTitle("暂停", for: UIControlState.normal)
        self.pauseBtn.backgroundColor = Utils.colorWithHexString(kLIkeBlackColor)
        self.pauseBtn.layer.masksToBounds = true
        self.pauseBtn.layer.cornerRadius = 10
        self.pauseBtn.addTarget(self, action: #selector(pauseMethod(sender:)), for: UIControlEvents.touchUpInside)
        self.pauseBtn.isHidden = true
        self.view.addSubview(self.pauseBtn)
        self.contentLabel.frame = CGRect.init(x: 50, y: 100, width: kDeviceWidth - 100, height: 100)
        self.contentLabel.textAlignment = NSTextAlignment.center
        self.contentLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(self.contentLabel)
        self.contentLabel.textColor = Utils.colorWithHexString(kLikeTextColor)
        self.contentLabel.isHidden = true
        self.tap = UITapGestureRecognizer.init(target: self, action: #selector(tapMethod))
        self.tap?.numberOfTouchesRequired = 3
        self.view.addGestureRecognizer(self.tap!)
        self.long = UILongPressGestureRecognizer.init(target: self, action: #selector(longMethod))
        self.long?.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(self.long!)
        self.changeBtn.frame = CGRect.init(x: kDeviceWidth - 90, y: 15, width: 80, height: 30)
        self.changeBtn.setTitle("修改背景", for: UIControlState.normal)
        self.changeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.changeBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.changeBtn.addTarget(self, action: #selector(chooseImage), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.changeBtn)
        self.grayView.layer.cornerRadius = 5
        self.grayView.layer.masksToBounds = true
    }
    
    func pauseMethod(sender:UIButton){
        if self.isPause {
            self.timer?.fireDate = NSDate.distantFuture
            self.pauseBtn.setTitle("继续", for: UIControlState.normal)
        }else{
            self.timer?.fireDate = NSDate.distantPast
            self.pauseBtn.setTitle("暂停", for: UIControlState.normal)
        }
        self.isPause = !self.isPause
    }
    
    func chooseImage(){
//        let plainCon = PhotoAlbumsTableViewController(style:.plain)
//        plainCon.callBackImage { (image) in
//            self.backImage.frame = CGRect.init(x: 0, y: 0, width: KDeviceWidth, height: image.size.height * KDeviceWidth / image.size.width)
//            self.backImage.center = CGPoint.init(x: KDeviceWidth/2, y: KDeviceHeight/2)
//            self.backImage.image = image
//            self.sqliteUpdate(currentImage: image)
//        }
//        self.navigationController?.pushViewController(plainCon, animated: false)
//        let currentType = PHAssetCollectionSubtype.smartAlbumUserLibrary
//        let results = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype:currentType, options: nil)
//        if results.count > 0 {
//            if let model = self.getModel(collection: results[0]) {
//                if model.count > 0 {
//                    let layout = PhotoCollectionViewController.configCustomCollectionLayout()
//                    let controller = PhotoCollectionViewController(collectionViewLayout: layout)
//                    controller.callBackImage(block: { (image) in

//                    })
//                    controller.fetchResult = model as? PHFetchResult<PHObject>;
//                    self.navigationController?.pushViewController(controller, animated: false)
//                }
//            }
//        }
        
        HsuPhotosManager.share.takePhotos(1, true, true) { (datas) in
            DispatchQueue.main.async {
                let image = UIImage.init(data: datas.first!!)
                self.backImage.frame = CGRect.init(x: 0, y: 0, width: KDeviceWidth, height: (image?.size.height)! * KDeviceWidth / (image?.size.width)!)
                self.backImage.center = CGPoint.init(x: KDeviceWidth/2, y: KDeviceHeight/2)
                self.backImage.image = image
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.sqliteUpdate(currentImage: image!)
                }
            }
        }
    }
    
    func setSqliteValue(){
        //开启数据库
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let db = try? Connection("\(path)/db.sqlite3")
        //建表
        let imageTable = Table("image")
        let image = Expression<Data>("image")
        try! db?.run(imageTable.create(ifNotExists: true, block: { (table) in
            table.column(image, primaryKey: true)
        }))
        for item in (try! db?.prepare(imageTable))! {
            let itemImage = UIImage.init(data: item[image])
            self.backImage.frame = CGRect.init(x: 0, y: 0, width: KDeviceWidth, height: (itemImage?.size.height)! * KDeviceWidth / (itemImage?.size.width)!)
            self.backImage.center = CGPoint.init(x: KDeviceWidth/2, y: KDeviceHeight/2)
            self.backImage.image = itemImage
        }
    }
    
    func sqliteUpdate(currentImage:UIImage){
        //开启数据库
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let db = try? Connection("\(path)/db.sqlite3")
       //建表
        let imageTable = Table("image")
        let image = Expression<Data>("image")
        try! db?.run(imageTable.create(ifNotExists: true, block: { (table) in
            table.column(image, primaryKey: true)
        }))
        
        //删除
        try! db?.run(imageTable.delete())
        
        //插入
        let imageData = UIImagePNGRepresentation(currentImage)//可能失败，无效图片或者位图        
        if (imageData != nil) {
            let insert = imageTable.insert([image <- imageData!])
            _ = try? db?.run(insert)
        }
    }
    
    func beginMethod(sender:UIButton){
        sender.isUserInteractionEnabled = false
        self.pauseBtn.isHidden = false
        sender.isHidden = true
        self.isPause = true
        self.timeAction()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
    }
    
    
//    private func getModel(collection: PHAssetCollection) -> PHFetchResult<PHAsset>?{
//        let fetchResult = PHAsset.fetchAssets(in: collection, options: PhotoFetchOptions.shareInstance)
//        if fetchResult.count > 0 {
//            return fetchResult
//        }
//        return nil
//    }
    
    func timeAction(){
        self.currentTime -= 1
        if self.currentTime != 0 {
            self.contentLabel.isHidden = false
            self.grayView.isHidden = false
            self.formatTimeLabel()
            self.timePic.isHidden = true
        }else{
            self.grayView.isHidden = true
            self.contentLabel.isHidden = true
            self.pauseBtn.isHidden = true
            self.timer?.invalidate()
            self.playBtn.isHidden = false
            self.timer = nil
            self.playBtn.setTitle("再来吧", for: UIControlState.normal)
            self.playBtn.isUserInteractionEnabled = true
            if var allCount = UserDefaults.standard.object(forKey: "allCount") as? String{
                allCount = "\((allCount as NSString).intValue + 1)"
                UserDefaults.standard.set(allCount, forKey: "allCount")
            }else{
                let allCount = "1"
                UserDefaults.standard.set(allCount, forKey: "allCount")
            }
            UserDefaults.standard.synchronize()
            ShowMessage.showMessage(con: self, message: "奖励时间")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                let game = GameViewController.init()
                self.navigationController?.pushViewController(game, animated: true)
            })
        }
    }
    
    func formatTimeLabel(){
        self.contentLabel.text = "\(self.currentTime/60)分\(self.currentTime % 60)秒"
    }
    
    func tapMethod(){
        ShowMessage.showMessage(con: self, message: "miss me !!")
    }
    
    func longMethod(){
        if self.countCon == nil {
            self.countCon = CountController.init()
            self.navigationController?.pushViewController(countCon!, animated: true)
        }
    }
    
    func applicationWillEnterForeground(){
        self.isPause = false
        self.tapMethod()
    }
    
    func applicationDidEnterBackground(){
        self.isPause = true
        self.tapMethod()
        if var allClose = UserDefaults.standard.object(forKey: "allClose") as? String{
            allClose = "\((allClose as NSString).intValue + 1)"
            UserDefaults.standard.set(allClose, forKey: "allClose")
        }else{
            let allClose = "1"
            UserDefaults.standard.set(allClose, forKey: "allClose")
        }
        UserDefaults.standard.synchronize()
        self.localNote.fireDate = Date.init(timeIntervalSinceNow: 5)
        self.localNote.alertBody = "别玩手机乖"
        self.localNote.alertLaunchImage = "2x_06"
        UIApplication.shared.scheduleLocalNotification(self.localNote)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }

}

extension ViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentTime = row * 60 + 60
        contentLabel.text = "开始\(currentTime/60)分钟的专心吧~"
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1) min"
    }

}





