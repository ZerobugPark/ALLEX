//
//  ModifyView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/10/25.
//

import UIKit

import SnapKit

final class ModifyView: BaseView {
    
    let timePicker = UIDatePicker()

    
    private let dateLabel = TitleLabel(title: "날짜")
    let dateTextField = DateTextField()
    
    private let spaceLabel = TitleLabel(title: "장소")
    let spaceTextField = UITextField()
    let tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: 0, height: 400))
    
    private let excersiseTimeLabel = TitleLabel(title: "운동시간")
    let timeTxetFiled = UITextField()
    
    
    let doneButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: nil)
    
    private let gradeLabel = TitleLabel(title: "난이도")
    
    override func configureHierarchy() {
    
        self.addSubviews(dateLabel, dateTextField, spaceLabel, spaceTextField, excersiseTimeLabel, timeTxetFiled, gradeLabel)
    
    
    }
    
    override func configureLayout() {
    
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
        }
    
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
    
        spaceLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
        }
    
        spaceTextField.snp.makeConstraints { make in
            make.top.equalTo(spaceLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
    
        excersiseTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(spaceTextField.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
        }
    
        timeTxetFiled.snp.makeConstraints { make in
            make.top.equalTo(excersiseTimeLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeTxetFiled.snp.bottom).offset(32)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
        }
    
    }
    
    override func configureView() {
    
        timePicker.datePickerMode = .countDownTimer
        spaceTextField.inputView = tableView
        spaceTextField.setupPaddingTextField()
    
        tableView.rowHeight = 70
         
        timeTxetFiled.inputView = timePicker
        timeTxetFiled.setupPaddingTextField()
        
        // ✅ 툴바 추가
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // ✅ 완료 버튼을 오른쪽으로 밀기 위해 flexibleSpace 추가
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        // ✅ 툴바를 UITextField의 inputAccessoryView로 설정
        timeTxetFiled.inputAccessoryView = toolbar
        
        toolbar.backgroundColor = .setAllexColor(.backGroundSecondary)
        toolbar.tintColor = .setAllexColor(.textSecondary)
        
        
        timePicker.backgroundColor = .setAllexColor(.backGroundSecondary)
        timePicker.tintColor = .setAllexColor(.textSecondary)
    
    }
    

    
}
