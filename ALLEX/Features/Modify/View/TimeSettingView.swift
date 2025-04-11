//
//  TimeSettingView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/11/25.
//

import UIKit

import SnapKit

final class TimeSettingView: BaseView {
    
    // UI 요소
    let timeLabel = UILabel()
    let datePicker = UIDatePicker()
    let minutesLabel = UILabel()
    let saveButton = UIButton(type: .system)
    
    // 시작 시간과 종료 시간 저장
    var startTime: Date?
    var endTime: Date?
    var workoutMinutes: Int = 0
    
    
    
    
    
    override func configureHierarchy() {
        
        self.addSubviews(timeLabel, datePicker, minutesLabel, saveButton)
        
    }
    
    override func configureLayout() {
        
        // SnapKit을 사용한 레이아웃 설정
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        minutesLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(minutesLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        
        // 시간 선택 레이블
        timeLabel.text = "운동 시간 선택"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        // 분 표시 레이블
        minutesLabel.text = "총 운동 시간: 0분"
        minutesLabel.font = UIFont.systemFont(ofSize: 16)
        
        // 날짜 피커 설정
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 5
        datePicker.preferredDatePickerStyle = .wheels
        
        
        
        // 시작/종료/저장 버튼
        saveButton.setTitle("시작 시간 설정", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        
        self.backgroundColor = .setAllexColor(.backGroundSecondary)
        
    }
    
    
    
}
