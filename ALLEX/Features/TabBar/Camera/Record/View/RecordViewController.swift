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
    
    private let tryButtonEvent = PublishRelay<(TryButtonAction, Int)>()
    private let successButtonEvent =  PublishRelay<(SuccessButtonAction, Int)>()
    private let eveButtonEvent =  PublishRelay<(Int)>()
    private let eveHiddenButtonEvent =  PublishRelay<(Int)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.recordView.tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.id)
        
        mainView.hiddenView.tableView.register(HiddenTableViewCell.self, forCellReuseIdentifier: HiddenTableViewCell.id)
        
        
        
    }
    
    override func bind() {
        
        
        let input = RecordViewModel.Input(toggleTimerTrigger: mainView.timeRecord.timeButton.rx.tap, tryButtonEvent: tryButtonEvent.asDriver(onErrorJustReturn: (.tryButtonTap,0)), successButtonEvent: successButtonEvent.asDriver(onErrorJustReturn: (.successButtonTap,0)), eyeButtonEvent: eveButtonEvent.debounce(.milliseconds(100), scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: 0), eveHiddenButtonEvent: eveHiddenButtonEvent.debounce(.milliseconds(100), scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: 0), saveButtonTapped: mainView.saveButton.rx.tap)
        
        
        
        let output = viewModel.transform(input: input)
        
        output.gymGrade.drive(mainView.recordView.tableView.rx.items(cellIdentifier: RecordTableViewCell.id, cellType: RecordTableViewCell.self)){  [weak self] row, element, cell in
            
            guard let self = self else { return }
            
            cell.setupData(element)
            
            
            
            cell.successButtonEvent.bind(with: self) { owner, type in
                owner.successButtonEvent.accept((type, row))
            }.disposed(by: cell.disposeBag)
            
            cell.tryButtonEvent.bind(with: self) { owner, type in
                owner.tryButtonEvent.accept((type, row))
            }.disposed(by: cell.disposeBag)
            
            cell.bouldering.eyeButton.rx.tap.bind(with: self) { owner, _ in
                owner.eveButtonEvent.accept(element.gradeLevel)
                
                owner.updateHiddenLayer()
                
            }.disposed(by: cell.disposeBag)
            
            
        }.disposed(by: disposeBag)
        
        output.hiddenData.drive(mainView.hiddenView.tableView.rx.items(cellIdentifier: HiddenTableViewCell.id, cellType: HiddenTableViewCell.self)) { [weak self] row, element, cell in
            
            guard let self = self else { return }
            cell.setupData(element)
            
            cell.bouldering.eyeButton.rx.tap.bind(with: self) { owner, _ in
                
                
                owner.eveHiddenButtonEvent.accept(element.gradeLevel)
                
            }.disposed(by: cell.disposeBag)
            
            
        }.disposed(by: disposeBag)
        
        
        
        output.buttonStatus.drive(mainView.timeRecord.timeButton.rx.isSelected).disposed(by: disposeBag)
        
        
        output.timerString
            .observe(on:MainScheduler.instance) // UI 업데이트는 메인 스레드에서
            .bind(to: mainView.timeRecord.timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.updateTitle.bind(to: mainView.titleLable.rx.text).disposed(by: disposeBag)
        
        output.updateUI.drive(with: self) { owner, _ in
            
            owner.updateHiddenLayer()
            
        }.disposed(by: disposeBag)
        
        
        output.dismissView.drive(with: self) { owner, _ in
            
            owner.coordinator?.showResult() //dismiss()
            
        }.disposed(by: disposeBag)
        
        
        mainView.backButton.rx.tap.bind(with: self) { owner, _ in
            owner.coordinator?.dismiss()
        }.disposed(by: disposeBag)
        
        mainView.eyeButton.rx.tap.bind(with: self) { owner, _ in
            
            owner.mainView.isHiddenViewVisible.toggle()
            owner.updateHiddenLayer()
        }.disposed(by: disposeBag)
        
    }
    
    deinit {
        print("Deinit")
        
        coordinator = nil
    }
    
    
}


extension RecordViewController {
    
    private func updateHiddenLayer() {
        
        let isHidden =  mainView.isHiddenViewVisible
        self.mainView.toggleHiddenView(isHidden: isHidden)
        
        
        
    }
}
