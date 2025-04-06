//
//  ProfileView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/5/25.
//

import UIKit
import SnapKit


final class ProfileView: BaseView {
    
    // MARK: - Properties
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let profileButton = ProfileButton()
    
        
    override func configureHierarchy() {
        self.addSubviews(profileButton, tableView)
    }
    
    override func configureLayout() {
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(70)

        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
  

    }
    
    override func configureView() {
        tableView.separatorStyle = .singleLine
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .setAllexColor(.backGround)
    

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.darkGray.withAlphaComponent(0.5)
            
    
    }
    
    
    
    
}
