//
//  GymListView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import SnapKit

final class GymListView: BaseView {
    
    let searchBar = BaseSearchBar()
    let tableView = BaseTableView()
        
    override func configureHierarchy() {
        self.addSubviews(searchBar, tableView)
    }
    
    override func configureLayout() {

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
            
        }

    }
    

}
