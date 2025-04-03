//
//  SearchView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import UIKit

import SnapKit

final class SearchView: BaseView {
    
    
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
    
    override func configureView() {
        

        tableView.separatorStyle = .none
        tableView.rowHeight = 70
    }

    
}
