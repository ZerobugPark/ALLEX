//
//  GymListView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import SnapKit

final class GymListView: BaseView {
    
    let gymList = SearchView()
        
    override func configureHierarchy() {
        self.addSubview(gymList)
 
        
    }
    
    override func configureLayout() {
        gymList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        

    }
    

}
