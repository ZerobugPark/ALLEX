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
    
    private let tryButtonEvent = PublishRelay<(ButtonAction, Int)>()
    private let successButtonEvent =  PublishRelay<(ButtonAction, Int)>()
    private let eveButtonEvent =  PublishRelay<(Int)>()
    private let eveHiddenButtonEvent =  PublishRelay<(Int)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.recordView.tableView.register(RecordEntryTableViewCell.self, forCellReuseIdentifier: RecordEntryTableViewCell.id)
        
        mainView.hiddenView.tableView.register(HiddenDifficultyTableViewCell.self, forCellReuseIdentifier: HiddenDifficultyTableViewCell.id)
        
        
        mainView.recordView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
  
        
    }
    
    override func bind() {
        
        
        let input = RecordViewModel.Input(toggleTimerTrigger: mainView.timeRecord.timeButton.rx.tap, tryButtonEvent: tryButtonEvent.asDriver(onErrorJustReturn: (.addButton,0)), successButtonEvent: successButtonEvent.asDriver(onErrorJustReturn: (.addButton,0)), eyeButtonEvent: eveButtonEvent.debounce(.milliseconds(100), scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: 0), eveHiddenButtonEvent: eveHiddenButtonEvent.debounce(.milliseconds(100), scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: 0), saveButtonTapped: mainView.saveButton.rx.tap)
        
        
        
        let output = viewModel.transform(input: input)
        
        output.gymGrade.drive(mainView.recordView.tableView.rx.items(cellIdentifier: RecordEntryTableViewCell.id, cellType: RecordEntryTableViewCell.self)){  [weak self] row, element, cell in
            
            guard let self = self else { return }
            
            cell.setupData(element)
            
            
            
            cell.successButtonEvent.bind(with: self) { owner, type in
                owner.successButtonEvent.accept((type, row))
            }.disposed(by: cell.disposeBag)
            
            cell.tryButtonEvent.bind(with: self) { owner, type in
                owner.tryButtonEvent.accept((type, row))
            }.disposed(by: cell.disposeBag)
            
            
        }.disposed(by: disposeBag)
        
        output.hiddenData.drive(mainView.hiddenView.tableView.rx.items(cellIdentifier: HiddenDifficultyTableViewCell.id, cellType: HiddenDifficultyTableViewCell.self)) { [weak self] row, element, cell in
            
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
        
        output.updateTitle.bind(to: mainView.gymNameLabel.rx.text).disposed(by: disposeBag)
        
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
        
        
        mainView.timeRecord.timeButton.rx.tap.bind(with: self) { owner, _ in
            if owner.mainView.timeRecord.animationImageView.isAnimationPlaying {
                owner.mainView.timeRecord.animationImageView.pause()
            } else {
                owner.mainView.timeRecord.animationImageView.play()
            }
        }.disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    
    deinit {
        print("RecordViewController Deinit")
        
        coordinator = nil
       // print(coordinator)
    }
    
    
}

extension RecordViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 현재 데이터 가져오기
        let element = viewModel.gymGradeList[indexPath.row]
        
        
        // Eye Slash 버튼 액션
        let hideAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            guard let self = self else { return }
            
            
            self.eveButtonEvent.accept(element.gradeLevel)
            self.updateHiddenLayer()
            
            completion(true)
        }
        
        hideAction.image = UIImage(systemName: "eye.slash")?.withTintColor(.setAllexColor(.pirmary), renderingMode: .alwaysOriginal)
        hideAction.backgroundColor = .setAllexColor(.backGroundSecondary)
        
        
        return UISwipeActionsConfiguration(actions: [hideAction])
        
        
        
    }
    
    
}


extension RecordViewController {
    
    private func updateHiddenLayer() {
        
        let isHidden =  mainView.isHiddenViewVisible
        self.mainView.toggleHiddenView(isHidden: isHidden)
        
        
        
    }
}
