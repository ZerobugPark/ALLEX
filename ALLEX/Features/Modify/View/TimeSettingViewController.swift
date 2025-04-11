//
//  TimeSettingViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TimeSettingViewController: BaseViewController<TimeSettingView, TimeSettingViewModel> {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    
        configureBindings()
    }

    private func configureBindings() {
        // 버튼 탭 이벤트 처리
        mainView.saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if mainView.startTime == nil {
                    // 시작 시간 설정
                    mainView.startTime = mainView.datePicker.date
                    mainView.saveButton.setTitle("종료 시간 설정", for: .normal)
                    mainView.saveButton.backgroundColor = .systemOrange
                } else if mainView.endTime == nil {
                    // 종료 시간 설정 및 분 계산
                    mainView.endTime = mainView.datePicker.date
                    self.calculateWorkoutTime()
                    mainView.saveButton.setTitle("저장", for: .normal)
                    mainView.saveButton.backgroundColor = .systemGreen
                } else {
                    // 저장 처리
                    self.saveWorkoutData()
                    self.resetUI()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func calculateWorkoutTime() {
        guard let start = mainView.startTime, let end = mainView.endTime else { return }
        
        // 종료 시간이 시작 시간보다 이전인 경우 (다음날까지 운동한 경우)
        var timeInterval = end.timeIntervalSince(start)
        if timeInterval < 0 {
            // 24시간(86400초)을 더해서 다음 날로 계산
            timeInterval += 24 * 60 * 60
        }
        
        // 분 단위로 변환 (소수점 버림)
        mainView.workoutMinutes = Int(timeInterval / 60)
        mainView.minutesLabel.text = "총 운동 시간: \(mainView.workoutMinutes)분"
    }
    
    private func saveWorkoutData() {
        // 여기에 데이터 저장 로직 구현
        // 예: CoreData, UserDefaults, 서버 전송 등
        print("운동 데이터 저장: \(mainView.workoutMinutes)분")
        
        // 저장 성공 알림
        let alert = UIAlertController(title: "저장 완료", message: "운동 시간 \(mainView.workoutMinutes)분이 저장되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func resetUI() {
        // UI 초기화
        mainView.startTime = nil
        mainView.endTime = nil
        mainView.workoutMinutes = 0
        
        mainView.saveButton.setTitle("시작 시간 설정", for: .normal)
        mainView.saveButton.backgroundColor = .systemBlue
        mainView.minutesLabel.text = "총 운동 시간: 0분"
    }
}
