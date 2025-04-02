//
//  RecordView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import UIKit

import SnapKit

final class RecordView: BaseView {
    
    let backButton = BaseButton()
    let titleLable = TitleLabel()
    let timeRecord = TimeRecordView()
    let recordView = RecordTableView()
    
    let saveButton = BaseButton(key: .start)
    
    var isHiddenViewVisible = false
    let hiddenView = UIView()
    var hiddenViewHeightConstraint: Constraint?
    
    override func configureHierarchy() {
        self.addSubviews(backButton, titleLable, timeRecord, recordView, saveButton)
        
//        hiddenView.backgroundColor = .darkGray
//        hiddenView.layer.cornerRadius = 10
//        hiddenView.clipsToBounds = true
//        hiddenView.isHidden = true
//        self.addSubview(hiddenView)
//        
//        // Add content to hidden view (예: 레이블)
//        let label = UILabel()
//        label.text = "숨긴 난이도 (3)"
//        label.textColor = .white
//        label.textAlignment = .center
//        hiddenView.addSubview(label)
//        
//        label.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
        
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
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.saveButton.snp.top).offset(-16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
//        hiddenView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalTo(self.safeAreaLayoutGuide)
//            hiddenViewHeightConstraint = make.height.equalTo(0).constraint
//        }
    }
    
    override func configureView() {
        backButton.setImage(.setAllexSymbol(.xmark), for: .normal)
        backButton.tintColor = .setAllexColor(.textSecondary)
        
        titleLable.font = .setAllexFont(.bold_14)
        
    }
    
    // MARK: - Public Methods
//    func toggleHiddenView(isHidden: Bool) {
//        // 히든 뷰의 상태 업데이트
//        hiddenView.isHidden = !isHidden
//        
//        // 높이 변경 애니메이션
//        UIView.animate(withDuration: 0.3) {
//            // 높이 제약 업데이트
//            self.hiddenViewHeightConstraint?.update(offset: isHidden ? 60 : 0)
//            self.layoutIfNeeded()  // 이 부분이 중요합니다
//        }
//    }
//    
    
    
}
