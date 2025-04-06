//
//  HomeViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import RxCocoa
import RxSwift


final class HomeViewController: BaseViewController<HomeView, HomeViewModel> {

    weak var coordinator: HomeCoordinator?
    
    private let repository: RealmRepository = RealmClimbingResultRepository()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setAllexColor(.backGround)
        tabBarController?.tabBar.isUserInteractionEnabled = false // 탭전환 비활성화
        mainView.indicator.startAnimating()
        repository.getFileURL()
    }
    
    override func bind() {
        
        
        let input = HomeViewModel.Input(viewdidLoad: Observable.just(()))
        
        let output = viewModel.transform(input: input)
        
        
        output.setupUI.drive(with: self) { owner, data in
            
            owner.mainView.greetingLabel.text = "안녕하세요" + data.nickName
            owner.mainView.statusLabel.text = data.date
            owner.mainView.problemsCountLabel.text = data.successCount
            owner.mainView.attemptsCountLabel.text = data.tryCount
            owner.mainView.completionRateLabel.text = data.successRate
            
            owner.mainView.timeValueLabel.text = data.totalTime
            owner.mainView.difficultyValueLabel.text = data.bestGrade
            

            
        }.disposed(by: disposeBag)
        
        output.stopIndicator.drive(with: self) { owner, _ in
            
            owner.mainView.indicator.stopAnimating()
            owner.mainView.indicator.isHidden = true
            owner.tabBarController?.tabBar.isUserInteractionEnabled = true
            
        }.disposed(by: disposeBag)
        
        output.isChangedName.drive(with: self) { owner, name in
            owner.mainView.greetingLabel.text = "안녕하세요" + name
        }.disposed(by: disposeBag)
    }



}
