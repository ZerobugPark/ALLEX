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
    let gymNameLabel = TitleLabel()
    let timeRecord = TimeRecordView()
    let recordView = RecordEntryTableView()
    
    
    let saveButton = BaseButton(key: .saveRecord)
    let eyeButton = BaseButton()
    
    
    var isHiddenViewVisible = false
    let hiddenView = HiddenTableView()
    var hiddenViewHeightConstraint: Constraint?
    
    override func configureHierarchy() {
        self.addSubviews(backButton, gymNameLabel, timeRecord, recordView, eyeButton, saveButton, hiddenView)
    }
    
    override func configureLayout() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.size.equalTo(44)
        }
        
        gymNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(44)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            
        }
        
        timeRecord.snp.makeConstraints { make in
            make.top.equalTo(gymNameLabel.snp.bottom).offset(16)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalToSuperview()
            make.height.equalTo(70)
        }
                
        recordView.snp.makeConstraints { make in
            make.top.equalTo(timeRecord.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.saveButton.snp.top).offset(-16)
        }
        
        eyeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.size.equalTo(44)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
        hiddenView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            hiddenViewHeightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    override func configureView() {
        backButton.setImage(.setAllexSymbol(.xmark), for: .normal)
        backButton.tintColor = .setAllexColor(.textSecondary)
        
        gymNameLabel.font = .setAllexFont(.bold_16)
        
        hiddenView.layer.cornerRadius = 10
        hiddenView.layer.masksToBounds = false
        hiddenView.isHidden = true
        
        hiddenView.layer.shadowColor = UIColor.setAllexColor(.textTertiary).cgColor
        hiddenView.layer.shadowOpacity = 0.3
        hiddenView.layer.shadowOffset = CGSize(width: 0, height: 4)
        hiddenView.layer.shadowRadius = 10
        hiddenView.layer.masksToBounds = false
        
        
        
        eyeButton.setImage(.setAllexSymbol(.eye), for: .normal)
        eyeButton.tintColor = .systemGray2
    
    }
    
    // MARK: - Public Methods
    func toggleHiddenView(isHidden: Bool) {
        // 히든 뷰의 상태 업데이트
        hiddenView.isHidden = !isHidden
        
        let rowCount = hiddenView.tableView.numberOfRows(inSection: 0)
        
        var height = rowCount * 70
 
        if rowCount >= 5 {
            height = 350
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [.curveEaseInOut]) {
            self.hiddenView.transform = isHidden ? .identity : CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.hiddenView.alpha = isHidden ? 1 : 0
            self.hiddenViewHeightConstraint?.update(offset: isHidden ? height : 0)
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.hiddenView.transform = .identity
            }
        }
        
    }
}
                       
                       
                       
