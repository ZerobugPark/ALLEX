//
//  RecordViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import RxSwift
import RxCocoa

final class RecordViewController: BaseViewController<RecordView, RecordViewModel> {

    
    var coordinator: CameraCoordinator?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.backButton.addTarget(self, action: #selector(test), for: .touchUpInside)
    }
    
    override func bind() {
        
       
        let input = RecordViewModel.Input(toggleTimerTrigger: mainView.timeRecord.timeButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
    
        output.buttonStatus.drive(mainView.timeRecord.timeButton.rx.isSelected).disposed(by: disposeBag)
        
        
        output.timerString
            .observe(on:MainScheduler.instance) // UI 업데이트는 메인 스레드에서
            .bind(to: mainView.timeRecord.timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.updateTitle.bind(to: mainView.titleLable.rx.text).disposed(by: disposeBag)
        
        
    }
    

    
    

    @objc private func test() {
        coordinator?.dismiss()
    }

}
