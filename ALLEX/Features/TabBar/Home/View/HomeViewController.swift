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
    
    private let repository: RealmRepository = RealmMonthlyClimbingResultRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setAllexColor(.backGround)
        //tabBarController?.tabBar.isUserInteractionEnabled = false // 탭전환 비활성화
        //mainView.indicator.startAnimating()
        repository.getFileURL()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
  
    override func bind() {
        
        
        let input = HomeViewModel.Input(viewdidLoad: Observable.just(()))
        
        let output = viewModel.transform(input: input)
        
        
        output.setupUI.drive(with: self) { owner, data in
            
            owner.mainView.greetingLabel.text = data.nickName
            owner.mainView.statusLabel.text = data.date
            owner.mainView.problemsCountLabel.text = data.successCount
            owner.mainView.attemptsCountLabel.text = data.tryCount
            owner.mainView.completionRateLabel.text = data.successRate
            
            owner.mainView.timeValueLabel.text = data.totalTime
            owner.mainView.difficultyValueLabel.text = data.latestBestGrade
            

            
        }.disposed(by: disposeBag)
        
        output.setupMonthlyGymList.drive(with: self) { owner, data in
            
            
            owner.mainView.monthlyGymLabel.text = data.gymName.isEmpty ? "" :data.gymName
            
            let visit: String
            let total: String

            if data.mostVisitCount == 0 {
                visit = "-"
                total = "-"
            } else {
                visit = "\(data.mostVisitCount)"
                total = "\(data.totalCount)"
            }

            owner.mainView.monthlyCountLabel.text = "\(visit)/\(total)회 방문함"

            owner.mainView.monthGymProgressView.setProgress(data.rating, animated: true)

            
            
            
        }.disposed(by: disposeBag)
        
//        output.stopIndicator.drive(with: self) { owner, _ in
//            
//            owner.mainView.indicator.stopAnimating()
//            owner.mainView.indicator.isHidden = true
//            owner.tabBarController?.tabBar.isUserInteractionEnabled = true
//            
//        }.disposed(by: disposeBag)
        
        output.isChangedName.drive(with: self) { owner, value in
            owner.mainView.greetingLabel.text = value.0
            owner.mainView.statusLabel.text = value.1
        }.disposed(by: disposeBag)
    }



}
