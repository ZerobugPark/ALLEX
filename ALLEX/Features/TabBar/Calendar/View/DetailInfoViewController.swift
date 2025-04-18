//
//  DetailInfoViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/7/25.
//

import UIKit

class DetailInfoViewController: BaseViewController<ResultView, DetailInfoViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    override func bind() {
        
        let input = DetailInfoViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.setupUI.drive(with: self) { owner, value in
        
        
            owner.mainView.dateLabel.text = value.date
            owner.mainView.spaceDetailButton.title.text = value.space
            owner.mainView.attemptView.valueLabel.text = value.totalTryCount
            owner.mainView.completionView.valueLabel.text = value.totalSuccessCount
            owner.mainView.rateView.valueLabel.text = value.totalSuccessRate
            owner.mainView.maxLevelView.valueLabel.text = value.bestGrade
            
            owner.mainView.exerciseTimeValue.text = value.excersieTime
            
            for i in 0..<owner.mainView.problemViewArray.count {
                
                if i < value.results.count {
                    
                    owner.mainView.problemViewArray[i].levelLabel.text = value.results[i].difficulty
                    owner.mainView.problemViewArray[i].levelCircle.backgroundColor = .setBoulderColor(from: value.results[i].color)
                    owner.mainView.problemViewArray[i].progressView.progress = Float(value.results[i].totalSuccessCount) / Float(value.results[i].totalClimbCount)
                    
                    owner.mainView.problemViewArray[i].countLabel.text =  "\(value.results[i].totalSuccessCount) / \(value.results[i].totalClimbCount)"
                } else {
                    owner.mainView.problemViewArray[i].isHidden = true
                }
            }
                
        }.disposed(by: disposeBag)
        
    }
}
