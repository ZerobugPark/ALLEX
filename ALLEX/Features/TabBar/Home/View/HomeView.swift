//
//  HomeView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

//final class HomeView: BaseView {
//
//
//
//}

import UIKit
import SnapKit

class HomeView: BaseView {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = CustomView()
    let indicator = UIActivityIndicatorView()
    
    let greetingLabel = TitleLabel()
    let statusLabel = SubTitleLabel()
    
    private let statsContainerView = CustomView(radius: 12, bgColor: .setAllexColor(.backGroundSecondary))
    private let problemsView = CustomView(radius: 0, bgColor: .setAllexColor(.backGroundSecondary))
    private let attemptsView = CustomView(radius: 0, bgColor: .setAllexColor(.backGroundSecondary))
    private let completionRateView = CustomView(radius: 0, bgColor: .setAllexColor(.backGroundSecondary))
    
    private let problemsIcon = UIImageView()
    private let problemsLabel = TertiaryLabel()
    let problemsCountLabel = TertiaryLabel()
    
    private let attemptsIcon = UIImageView()
    private let attemptsLabel = TertiaryLabel()
    let attemptsCountLabel = TertiaryLabel()
    
    private let completionIcon = UIImageView()
    private let completionLabel = TertiaryLabel()
    let completionRateLabel = TertiaryLabel()
    
    private let timeContainerView = CustomView(radius: 12, bgColor: .setAllexColor(.backGroundSecondary))
    private let timeView = CustomView(radius: 0, bgColor: .setAllexColor(.backGroundSecondary))
    private let difficultyView = CustomView(radius: 0, bgColor: .setAllexColor(.backGroundSecondary))
    
    private let timeIcon = UIImageView()
    private let timeLabel = TertiaryLabel()
    let timeValueLabel = TertiaryLabel()
    
    private let difficultyIcon = UIImageView()
    private let difficultyLabel = TertiaryLabel()
    let difficultyValueLabel = TertiaryLabel()
    
    
    /// Montly 정보
    private let monthlyTitleLabel = SubTitleLabel()
    private let monthlyGymContainerView = CustomView(radius: 12, bgColor: .setAllexColor(.backGroundSecondary))
    let monthlyGymLabel = TertiaryLabel()
    let monthlyCountLabel = TertiaryLabel()
    let monthGymProgressView = UIProgressView(progressViewStyle: .bar)
    
    
    

    
    override func configureHierarchy() {
        
        self.addSubviews(scrollView, indicator)
        scrollView.addSubview(contentView)
        
        
        contentView.addSubviews(greetingLabel, statusLabel, statsContainerView)
        
        // 문제 뷰 계층 구조 설정
        problemsView.addSubviews(problemsIcon, problemsLabel, problemsCountLabel)
        attemptsView.addSubviews(attemptsIcon, attemptsLabel, attemptsCountLabel)
        completionRateView.addSubviews(completionIcon, completionLabel, completionRateLabel)
        
        statsContainerView.addSubviews(problemsView, attemptsView, completionRateView)
        
        // 시간 컨테이너 계층 구조 설정
        timeContainerView.addSubviews(timeView, difficultyView)
        
        timeView.addSubviews(timeIcon, timeLabel, timeValueLabel)
        difficultyView.addSubviews(difficultyIcon, difficultyLabel, difficultyValueLabel)
        
        contentView.addSubview(timeContainerView)
        
        // 이번달 자주 가는 암장 리스트
        contentView.addSubview(monthlyTitleLabel)
        monthlyGymContainerView.addSubviews(monthlyGymLabel, monthlyCountLabel,monthGymProgressView)
        contentView.addSubview(monthlyGymContainerView)
        
    }
    
 
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        
        // Greeting
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        // Status
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        

        // Stats Container
        statsContainerView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(120)
        }
        
        // Stats Items
        problemsView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.33)
        }
        
        attemptsView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(problemsView.snp.trailing)
            make.width.equalToSuperview().multipliedBy(0.33)
        }
        
        completionRateView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(attemptsView.snp.trailing)
        }
        
        // Stat Items Internal Layout
        [problemsIcon, attemptsIcon, completionIcon].forEach { icon in
            icon.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.centerX.equalToSuperview()
                make.size.equalTo(24)
            }
        }
        
        [problemsLabel, attemptsLabel, completionLabel].forEach { label in
            label.snp.makeConstraints { make in
                make.top.equalTo(problemsIcon.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
            }
        }
        
        [problemsCountLabel, attemptsCountLabel, completionRateLabel].forEach { label in
            label.snp.makeConstraints { make in
                make.top.equalTo(problemsLabel.snp.bottom).offset(4)
                make.centerX.equalToSuperview()
            }
        }
        
        // Time Container
        timeContainerView.snp.makeConstraints { make in
            make.top.equalTo(statsContainerView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(120)
        }
        
        // Time View
        timeView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        timeIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(32)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeIcon.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        timeValueLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // Difficulty View
        difficultyIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(32)
        }
        
        difficultyView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(timeView.snp.trailing)
        }
        
        difficultyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        
        difficultyValueLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        monthlyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeContainerView.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        monthlyGymContainerView.snp.makeConstraints { make in
            make.top.equalTo(monthlyTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(100)
        }
        
        
        monthlyGymLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(8)
        }
        
        monthlyCountLabel.snp.makeConstraints { make in
            make.top.equalTo(monthlyGymLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(8)
        }
        
        monthGymProgressView.snp.makeConstraints { make in
            make.top.equalTo(monthlyCountLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        
                
    }
    
    override func configureView() {
        
        // Scroll View
        scrollView.showsVerticalScrollIndicator = false
  
        
        // Greeting
        greetingLabel.textColor = .setAllexColor(.pirmary)
        greetingLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        
        // Status
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        
        // Problems View
        setupStatView(iconView: problemsIcon, iconName: "pin.fill",
                     titleLabel: problemsLabel, title: "푼 문제",
                     valueLabel: problemsCountLabel, value: "",
                     containerView: problemsView, color: UIColor(red: 0.4, green: 0.5, blue: 0.9, alpha: 1.0))
        
        // Attempts View
        setupStatView(iconView: attemptsIcon, iconName: "hand.thumbsup",
                     titleLabel: attemptsLabel, title: "시도 횟수",
                     valueLabel: attemptsCountLabel, value: "",
                     containerView: attemptsView, color: UIColor(red: 0.9, green: 0.4, blue: 0.4, alpha: 1.0))
        
        // Completion Rate View
        setupStatView(iconView: completionIcon, iconName: "flag.pattern.checkered",
                     titleLabel: completionLabel, title: "완등률",
                     valueLabel: completionRateLabel, value: "",
                     containerView: completionRateView, color: UIColor(red: 0.7, green: 0.9, blue: 0.4, alpha: 1.0))
        
        // Time Section
        timeIcon.image = UIImage(systemName: "stopwatch.fill")
        timeIcon.tintColor = .setAllexColor(.textSecondary)
        timeIcon.contentMode = .scaleAspectFit
        
        timeLabel.text = "이번달 운동 시간"
        timeLabel.font = .setAllexFont(.regular_12)
        
        timeValueLabel.font = .setAllexFont(.bold_16)
        
        // Difficulty Section
        
        difficultyIcon.image = UIImage(systemName: "figure.climbing")
        difficultyIcon.tintColor = .setAllexColor(.textSecondary)
        difficultyIcon.contentMode = .scaleAspectFit
        
        difficultyLabel.text = "최근 최고 난이도"
        difficultyLabel.font = .setAllexFont(.regular_12)
        
       
        difficultyValueLabel.font = .setAllexFont(.bold_16)
        

        makeMonthlyGymView()
    }
    
    
    private func setupStatView(iconView: UIImageView, iconName: String,
                              titleLabel: UILabel, title: String,
                              valueLabel: UILabel, value: String,
                              containerView: UIView, color: UIColor) {
       
        iconView.image = UIImage(systemName: iconName)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        
        titleLabel.text = title
        titleLabel.font = .setAllexFont(.regular_14)
        
        valueLabel.text = value
        valueLabel.font = .setAllexFont(.bold_24)
        
        containerView.addSubviews(iconView, titleLabel, valueLabel)
        
    }
    
}


extension HomeView {
    
    
    
    // MARK: 이번 달 가장 많이 가는 암장
    private func makeMonthlyGymView() {
        monthlyTitleLabel.text = "이번달 가장 많이 방문한 곳"
        monthlyTitleLabel.font = .setAllexFont(.bold_16)
        
        monthlyGymLabel.text = "데이터 없음"
        monthlyGymLabel.font = .setAllexFont(.bold_14)
        
        monthlyCountLabel.text = "-/-회 방문함"
        monthlyCountLabel.font = .setAllexFont(.bold_14)
        
        monthGymProgressView.setProgress(0.0, animated: true)
        monthGymProgressView.progressTintColor = .pirmary
        monthGymProgressView.trackTintColor = .lightGray
        monthGymProgressView.transform = CGAffineTransform(scaleX: 1, y: 3)
        
        // 둥글게 만들기
        monthGymProgressView.layer.cornerRadius = 3     // 두께의 절반 정도
        monthGymProgressView.clipsToBounds = true

        // 내부 바도 둥글게
        if let sublayer = monthGymProgressView.subviews.first {
            sublayer.layer.cornerRadius = 3
            sublayer.clipsToBounds = true
        }
    }
}
