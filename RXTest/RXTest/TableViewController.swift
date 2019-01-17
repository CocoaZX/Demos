//
//  TableViewController.swift
//  RXTest
//
//  Created by 张鑫 on 2017/7/12.
//  Copyright © 2017年 CrowForRui. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

enum RefreshStatus: Int {
    case DropDownSuccess // 下拉成功
    case PullSuccessHasMoreData // 上拉，还有更多数据
    case PullSuccessNoMoreData // 上拉，没有更多数据
    case InvalidData // 无效的数据
}



class TableViewController: UIViewController{
    var refreshStatus = Variable.init(RefreshStatus.InvalidData)

    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)      
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>()
        
        let items = Observable.just([
            SectionModel(model: "First", items:[
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "Second", items:[
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "Third", items:[
                1.0,
                2.0,
                3.0
                ])
            ])
        
        
//        public typealias CellFactory = (TableViewSectionedDataSource<S>, UITableView, IndexPath, I) -> UITableViewCell

        dataSource.configureCell = {
            (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(indexPath.row)"
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }

        items
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { model in
                print("Tapped \(model)")
            })
            .disposed(by: disposeBag)
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
