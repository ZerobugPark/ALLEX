//
//  TimeRecordView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import UIKit

import SnapKit


final class TimeRecordView: BaseView {
    
    

    let timeLabel = TertiaryLabel(title: "")
    let timeButton = TimeButton()
    
    override func configureHierarchy() {
        self.addSubviews(timeButton, timeLabel)
        
        
    }
    
    override func configureLayout() {
 
        timeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.size.equalTo(18)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-12)
        }
    }
    
    override func configureView() {
        
        timeLabel.text = "00:00:00"
        timeLabel.textAlignment = .center
        timeLabel.font = .setAllexFont(.regular_16)
        
        
        self.backgroundColor = .setAllexColor(.backGround)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    

    
    
    
}
