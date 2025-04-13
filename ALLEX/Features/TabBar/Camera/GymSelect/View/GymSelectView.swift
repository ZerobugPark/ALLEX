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
    
    let startButton = BaseButton(key: .start)
    
    let subTitle = SubTitleLabel()
    
    let infoLabel = TertiaryLabel(title: "다녀오신 암장 기록이 없어요!")
    
    let tableView = BaseTableView()
    
    
    
    override func configureHierarchy() {
        self.addSubviews(selectedGym, subTitle, tableView, infoLabel, startButton)
        
    }
    
    override func configureLayout() {
        
        selectedGym.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(selectedGym.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            
        }
        
        infoLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(startButton.snp.top).offset(-44)
            
        }
        

        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-44)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
    }
    
    override func configureView() {

        subTitle.text = "최근 방문 기록"
        subTitle.font = .setAllexFont(.bold_14)
        
        
        startButton.isEnabled = false
        
        infoLabel.font = .setAllexFont(.regular_14)
        infoLabel.numberOfLines = 0

        
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        
        
    }
    
    
    

}
