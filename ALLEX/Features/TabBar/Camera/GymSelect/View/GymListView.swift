//
//  GymListView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

final class GymListView: BaseView {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()

    
    override func configureHierarchy() {
        self.addSubviews(searchBar, tableView)
 
        
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
            
        }
    
        
    }
    
    override func configureView() {
        
        
        searchBar.backgroundImage = UIImage() // 배경제거 , searchBarStyle을 minial로 사용하면 배경이 제거되지만, 텍스트필드 색상 변경이 안됨
        let placeholder = "Climbing Search?"
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.textTertiary])
        
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.layer.borderColor = UIColor.borderLight.cgColor
        searchBar.searchTextField.font = .systemFont(ofSize: 14)
        
        searchBar.searchTextField.clipsToBounds = true
        
        searchBar.searchTextField.backgroundColor = .setAllexColor(.backGroundSecondary)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
    }
}
