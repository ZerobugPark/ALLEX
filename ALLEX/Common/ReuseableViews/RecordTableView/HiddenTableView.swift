//
//  HiddenTableView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/2/25.
//

import UIKit

import SnapKit

// 실시간 클라이밍 기록 중 히든 테이블 뷰
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

}
