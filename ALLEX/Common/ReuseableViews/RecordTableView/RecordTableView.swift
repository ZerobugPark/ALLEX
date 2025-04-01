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
    // 나중에 key로 변경
    private let gradeLabel = SubTitleLabel(title: "난이도")
    private let tryLabel = SubTitleLabel(title: "시도")
    private let successLabel = SubTitleLabel(title: "성공")
    
    
    override func configureHierarchy() {
        self.addSubviews(stackView, tableView)
        self.stackView.addArrangedSubviews(gradeLabel, tryLabel, successLabel)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(4)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            //make.height.equalTo(50)  // 각 레이블의 높이에 맞게 스택뷰 높이 설정
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.25)  // 너비를 20%로 설정
            make.height.equalTo(50)
        }
        
        tryLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.375)  // 너비를 40%로 설정
            make.height.equalTo(50)
        }
        
        successLabel.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.375)  // 너비를 40%로 설정
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .setAllexColor(.backGroundSecondary)  // 디버깅용 배경색 추가
        
        gradeLabel.font = .setAllexFont(.bold_16)
        tryLabel.font = .setAllexFont(.bold_16)
        successLabel.font = .setAllexFont(.bold_16)
        
        gradeLabel.textAlignment = .center
        tryLabel.textAlignment = .center
        successLabel.textAlignment = .center
        
//        // 레이블 가시성 확인
//        gradeLabel.backgroundColor = .yellow  // 디버깅용 배경색
//        tryLabel.backgroundColor = .cyan
//        successLabel.backgroundColor = .magenta
        
        tableView.backgroundColor = .setAllexColor(.backGround)
    }

}
