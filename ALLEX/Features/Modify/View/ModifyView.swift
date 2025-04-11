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
    //let testButton = UIButton()
    
    
    override func configureHierarchy() {
    
        self.addSubviews(dateLabel, dateTextField, spaceLabel, spaceTextField, excersiseTimeLabel, timeTxetFiled)
    
    
    }
    
    override func configureLayout() {
    
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(44)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
        }
    
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
    
        spaceLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
    
        spaceTextField.snp.makeConstraints { make in
            make.top.equalTo(spaceLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
    
        excersiseTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(spaceTextField.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
    
        timeTxetFiled.snp.makeConstraints { make in
            make.top.equalTo(excersiseTimeLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
    
    }
    
    override func configureView() {
    
        timePicker.datePickerMode = .countDownTimer
        spaceTextField.inputView = tableView
        spaceTextField.setupPaddingTextField()
    
        tableView.rowHeight = 70
        
        timeTxetFiled.inputView = timePicker
        timeTxetFiled.setupPaddingTextField()
        
       // testButton.setTitle("dddddddd", for: .normal)
    
    }
    

    
}
