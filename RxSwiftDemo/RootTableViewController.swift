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

        
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(configureCell: { (_, tableView, _, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ExampleCell
            cell.textLabel?.text = "\(item)"
            return cell
        })
        
        dataSource.titleForHeaderInSection = {
            return $0.sectionModels[$1].header
        }
        
        let sections = [
          MySection(header: "First section", items: [
            1,
            2,
            3,
            4,
            5
          ]),
          MySection(header: "Second section", items: [
            6,
            7,
            8,
            9
          ])
        ]
        
        DispatchQueue.main.async {
            Observable.just(sections)
                .bind(to: self.tableView.rx.items(dataSource: dataSource))
                .disposed(by: self.disposeBag)
        }
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
}

