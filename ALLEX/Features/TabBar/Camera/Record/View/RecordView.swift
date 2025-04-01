//
//  RecordView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import UIKit

import SnapKit

final class RecordView: BaseView {
    
    let backButton = UIButton()
    let titleLable = TitleLabel()
    let timeRecord = TimeRecordView()
    let recordView = RecordTableView()
    
    
    override func configureHierarchy() {
        self.addSubviews(backButton, titleLable, timeRecord, recordView)
        
    }
    
    override func configureLayout() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.size.equalTo(44)
        }
        
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(44)
            make.centerX.equalTo(self.safeAreaLayoutGuide)

        }
                
        timeRecord.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(16)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        recordView.snp.makeConstraints { make in
            make.top.equalTo(timeRecord.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        backButton.setImage(.setAllexSymbol(.xmark), for: .normal)
        backButton.tintColor = .setAllexColor(.textSecondary)
        
        titleLable.font = .setAllexFont(.bold_14)
        
    }


    
}
