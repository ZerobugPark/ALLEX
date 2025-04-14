//
//  RecordTableView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import UIKit

import SnapKit

// 실시간 클라이밍 기록 중 타이틀 및 테이블 뷰
final class RecordEntryTableView: BaseView {

    
    let tableView = BaseTableView()
    
    private let stackView = UIStackView()
    // 나중에 key로 변경
    private let gradeLabel = SubTitleLabel(key: .Record_Grade, title: "")
    private let tryLabel = SubTitleLabel(key: .Record_Try, title: "")
    private let successLabel = SubTitleLabel(key: .Record_Success, title: "")
    
    
    override func configureHierarchy() {
        self.addSubviews(stackView, tableView)
        self.stackView.addArrangedSubviews(gradeLabel, tryLabel, successLabel)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(4)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.2)  // 너비를 20%로 설정
            make.height.equalTo(50)
        }
        
        tryLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.4)  // 너비를 40%로 설정
            make.height.equalTo(50)
        }
        
        successLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.4)  // 너비를 40%로 설정
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            
        }
    }

    override func configureView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .setAllexColor(.backGroundSecondary)
                
        [gradeLabel, tryLabel, successLabel].forEach {
            $0.font = .setAllexFont(.bold_16)
            $0.textAlignment = .center
        }
            
    }

}
