//
//  RecordTableView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import UIKit

import SnapKit

final class RecordTableView: BaseView {

    
    let tableView = UITableView()
    
    private let stackView = UIStackView()
    private let gradeLabel = SubTitleLabel(title: "난이도")
    private let tryLabel = SubTitleLabel(title: "시도")
    
    
    override func configureHierarchy() {
        self.addSubviews(stackView, tableView)
 
        
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
     
        }
        
        
        tableView.snp.makeConstraints { make in
     
            
        }
    
        
    }
    
    override func configureView() {
        
        
       
    }

}
