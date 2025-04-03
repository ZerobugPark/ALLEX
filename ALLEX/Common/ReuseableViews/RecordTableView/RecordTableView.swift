//
//  RecordTableView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import UIKit

import SnapKit

final class RecordTableView: BaseView {

    
    let tableView = BaseTableView()
    
    private let stackView = UIStackView()
    // 나중에 key로 변경
    private let hiddendLabel = SubTitleLabel(title: "숨김")
    private let gradeLabel = SubTitleLabel(title: "난이도")
    private let tryLabel = SubTitleLabel(title: "시도")
    private let successLabel = SubTitleLabel(title: "성공")
    
    
    override func configureHierarchy() {
        self.addSubviews(stackView, tableView)
        self.stackView.addArrangedSubviews(hiddendLabel, gradeLabel, tryLabel, successLabel)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(4)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        hiddendLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.2)  // 너비를 20%로 설정
            make.height.equalTo(50)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.2)  // 너비를 20%로 설정
            make.height.equalTo(50)
        }
        
        tryLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.3)  // 너비를 40%로 설정
            make.height.equalTo(50)
        }
        
        successLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.3)  // 너비를 40%로 설정
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.backgroundColor = .setAllexColor(.backGroundSecondary)  
        
        hiddendLabel.font = .setAllexFont(.bold_16)
        gradeLabel.font = .setAllexFont(.bold_16)
        tryLabel.font = .setAllexFont(.bold_16)
        successLabel.font = .setAllexFont(.bold_16)
        
        hiddendLabel.textAlignment = .center
        gradeLabel.textAlignment = .center
        tryLabel.textAlignment = .center
        successLabel.textAlignment = .center
        
        
//        tableView.backgroundColor = .setAllexColor(.backGround)
//        tableView.separatorStyle = .none
//        tableView.rowHeight = 70
//        tableView.showsVerticalScrollIndicator = false
    }

}
