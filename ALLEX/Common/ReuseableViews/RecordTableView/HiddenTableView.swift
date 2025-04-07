//
//  HiddenTableView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/2/25.
//

import UIKit

import SnapKit

final class HiddenTableView: BaseView {

    
    let tableView = BaseTableView()


    override func configureHierarchy() {
        self.addSubviews(tableView)
        
    }
    
    override func configureLayout() {

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func configureView() {
        
//        tableView.separatorStyle = .none
//        tableView.rowHeight = 70
//        tableView.bounces = false
//        tableView.showsVerticalScrollIndicator = false
    }

}
