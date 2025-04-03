//
//  SearchListView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import UIKit

import SnapKit

final class SearchListView: BaseView {
    
    let tableView = BaseTableView()
    
    let infoLabel = SubTitleLabel(title: "Not Found")
        
    override func configureHierarchy() {
        self.addSubviews(tableView, infoLabel)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        

    }
    
    override func configureView() {
        
        infoLabel.font = .setAllexFont(.bold_20)
        
        // 컨텐츠가 네비게이션바와 서치바에 가려지지 않도록 자동 조정
        tableView.contentInsetAdjustmentBehavior = .automatic
    }
    

}
