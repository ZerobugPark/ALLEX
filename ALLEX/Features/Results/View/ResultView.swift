//
//  ResultView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//

import UIKit
import SnapKit

final class ResultView: BaseView {

  
    // MARK: - Properties
     private let scrollView = UIScrollView()
       
    private let contentView =  CustomView()
    
    let dateLabel = TitleLabel()
    
    let spaceDetailButton = SpaceDetialButton()
    
    private let statisticsLabel = SubTitleLabel(title: "통계")
    
    
    // 통계 지표 컨테이너
    private let statsContainerView =  CustomView()
        
    
    // 상단 통계 영역 - 2x2 그리드
    let attemptView = StatView(title: "시도")
    let completionView = StatView(title: "성공")
    let rateView = StatView(title: "완등률")
    let maxLevelView = StatView(title: "최고난이도")
    
    
    private let exerciseTimeLabel = TertiaryLabel(title: "운동시간")
    let exerciseTimeValue =  SubTitleLabel()
    private let problemsLabel =  SubTitleLabel(title: "문제")
    private let problemsStackView = UIStackView()
    
    
    let problemViewArray: [ProgressView] = (0..<10).map { _ in ProgressView() }
  
    override func configureHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(dateLabel, spaceDetailButton, statisticsLabel, statsContainerView)

        statsContainerView.addSubviews(attemptView, completionView, rateView, maxLevelView)
        contentView.addSubviews(exerciseTimeLabel, exerciseTimeValue)
    
        contentView.addSubviews(problemsLabel, problemsStackView)
        
        problemViewArray.forEach {
            problemsStackView.addArrangedSubview($0)
        }
   
        
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView) // 세로 스크롤 유지시 명시
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(20)
        }
        
        spaceDetailButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
 
        
        statisticsLabel.snp.makeConstraints { make in
            make.top.equalTo(spaceDetailButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        // 통계 컨테이너 레이아웃
        statsContainerView.snp.makeConstraints { make in
            make.top.equalTo(statisticsLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(130)
        }
        
  
        attemptView.snp.makeConstraints { make in
            make.top.leading.equalTo(statsContainerView)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-10)
            make.height.equalTo(60)
        }
        
        completionView.snp.makeConstraints { make in
            make.top.equalTo(statsContainerView)
            make.trailing.equalTo(statsContainerView)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-10)
            make.height.equalTo(60)
        }
        
        rateView.snp.makeConstraints { make in
            make.top.equalTo(attemptView.snp.bottom).offset(10)
            make.leading.equalTo(statsContainerView)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-10)
            make.height.equalTo(60)
        }
        
        maxLevelView.snp.makeConstraints { make in
            make.top.equalTo(completionView.snp.bottom).offset(10)
            make.trailing.equalTo(statsContainerView)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-10)
            make.height.equalTo(60)
        }
        
        exerciseTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(statsContainerView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        exerciseTimeValue.snp.makeConstraints { make in
            make.top.equalTo(exerciseTimeLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
 
        
        problemsLabel.snp.makeConstraints { make in
            make.top.equalTo(exerciseTimeValue.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
        
        problemsStackView.snp.makeConstraints { make in
            make.top.equalTo(problemsLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(contentView).offset(-30)
        }

    }
    
    override func configureView() {
        scrollView.showsVerticalScrollIndicator = false
    
    
        dateLabel.font = .setAllexFont(.bold_20)
        statisticsLabel.font = .setAllexFont(.bold_16)
        
        exerciseTimeLabel.font = .setAllexFont(.bold_20)
        exerciseTimeValue.font = .setAllexFont(.bold_20)
        
        problemsLabel.font = .setAllexFont(.bold_16)
        
        problemsStackView.axis = .vertical
        problemsStackView.spacing = 15
        problemsStackView.distribution = .fillEqually
    }


}



 
 



 

 
