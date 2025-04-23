//
//  GymSelectView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import SnapKit

final class GymSelectionView: BaseView {

    
    let selectedGym = GymSelectButton()
    
    let startButton = BaseButton(key: .Button_Start_Login)
    
    let recentLabel = SubTitleLabel(key: .Info_Recent_Gym_Label, title: "")
    
    let infoLabel = TertiaryLabel(key: .Info_Recent_Gym_History, title: "")
    
    let tableView = BaseTableView()
    
    
    
    override func configureHierarchy() {
        self.addSubviews(selectedGym, recentLabel, tableView, infoLabel, startButton)
        
    }
    
    override func configureLayout() {
        
        selectedGym.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedGym.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            
        }
        
        infoLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(startButton.snp.top).offset(-44)
            
        }
        

        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-44)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
    }
    
    override func configureView() {

        
        recentLabel.font = .setAllexFont(.bold_14)
        
        
        startButton.isEnabled = false
        
        infoLabel.font = .setAllexFont(.regular_14)
        infoLabel.numberOfLines = 0

        
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        
        
    }
    
    
    

}
