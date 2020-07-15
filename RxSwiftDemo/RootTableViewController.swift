//
//  RootTableViewController.swift
//  RxSwiftDemo
//
//  Created by Sun on 2020/7/15.
//  Copyright © 2020 Sun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


struct MySection {
    var header: String
    var items: [Item]
}

extension MySection: AnimatableSectionModelType {
    
    typealias Item = Int
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}



class RootTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ExampleCell.self, forCellReuseIdentifier: "cell")
        
        let animatedDataSource = RxTableViewSectionedAnimatedDataSource<MySection>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ExampleCell
            cell.textLabel?.text = "\(item)"
            return cell
        })
        
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(configureCell: { (_, tableView, _, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ExampleCell
            cell.textLabel?.text = "\(item)"
            return cell
        })
        
        animatedDataSource.titleForHeaderInSection = {
            return $0.sectionModels[$1].header
        }
        
        let sections = [
          MySection(header: "First section", items: [
            1,
            2
          ]),
          MySection(header: "Second section", items: [
            3,
            4
          ])
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: animatedDataSource))
            .disposed(by: disposeBag)
        
    }


}

