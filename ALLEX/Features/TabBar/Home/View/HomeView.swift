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
    
    private let challengesContainerView = CustomView()
    private let challengeTitleLabel = TertiaryLabel()
    private let challengeLocationLabel = TertiaryLabel()
    private let challengeDescriptionLabel = TertiaryLabel()
    
    private let thumbnailsView = CustomView()
    private let thumbnailImageView1 = UIImageView()
    private let thumbnailImageView2 = UIImageView()
    
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
        
        // 챌린지 컨테이너 계층 구조 설정
//        challengesContainerView.addSubviews(challengeTitleLabel, challengeLocationLabel, challengeDescriptionLabel, thumbnailsView)
//        
//        thumbnailsView.addSubviews(thumbnailImageView1, thumbnailImageView2)
//        
//        contentView.addSubview(challengesContainerView)
        
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
        
        // Challenges Container
//        challengesContainerView.snp.makeConstraints { make in
//            make.top.equalTo(timeContainerView.snp.bottom).offset(16)
//            make.leading.trailing.equalTo(contentView).inset(16)
//            make.height.equalTo(240)
//            make.bottom.equalTo(contentView).offset(-16)
//        }
//        
//        challengeTitleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(20)
//            make.leading.trailing.equalToSuperview().inset(16)
//        }
//        
//        challengeLocationLabel.snp.makeConstraints { make in
//            make.top.equalTo(challengeTitleLabel.snp.bottom).offset(16)
//            make.leading.trailing.equalToSuperview().inset(16)
//        }
//        
//        
//        challengeDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(challengeLocationLabel.snp.bottom).offset(8)
//            make.leading.trailing.equalToSuperview().inset(16)
//        }
//        
//        // Thumbnails
//        thumbnailsView.snp.makeConstraints { make in
//            make.top.equalTo(challengeDescriptionLabel.snp.bottom).offset(16)
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview().offset(-16)
//            make.height.equalTo(120)
//        }
//        
//        thumbnailImageView1.snp.makeConstraints { make in
//            make.leading.top.bottom.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.48)
//        }
//        
//        thumbnailImageView2.snp.makeConstraints { make in
//            make.trailing.top.bottom.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.48)
//        }
        
    }
    
    override func configureView() {
        
        // Scroll View
        scrollView.showsVerticalScrollIndicator = false
  
        
        // Greeting
        greetingLabel.text = "차밍별님,"
        greetingLabel.textColor = .setAllexColor(.pirmary)
        greetingLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        
        // Status
        statusLabel.text = "최근 3개월동안 6일 클라이밍했어요"
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        
        // Problems View
        setupStatView(iconView: problemsIcon, iconName: "key.fill",
                     titleLabel: problemsLabel, title: "푼 문제",
                     valueLabel: problemsCountLabel, value: "5",
                     containerView: problemsView, color: UIColor(red: 0.4, green: 0.5, blue: 0.9, alpha: 1.0))
        
        // Attempts View
        setupStatView(iconView: attemptsIcon, iconName: "lock.fill",
                     titleLabel: attemptsLabel, title: "시도 횟수",
                     valueLabel: attemptsCountLabel, value: "6",
                     containerView: attemptsView, color: UIColor(red: 0.9, green: 0.4, blue: 0.4, alpha: 1.0))
        
        // Completion Rate View
        setupStatView(iconView: completionIcon, iconName: "chart.bar.fill",
                     titleLabel: completionLabel, title: "완등률",
                     valueLabel: completionRateLabel, value: "83%",
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
        
        // Challenges Container
        challengesContainerView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1.0)
        challengesContainerView.layer.cornerRadius = 12
       
        
        challengeTitleLabel.text = "차밍별님의 가장 뿌듯했던 도전"
        challengeTitleLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)
        challengeTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        challengeLocationLabel.text = "더클라임 성수점에서"
        challengeLocationLabel.textColor = .white
        challengeLocationLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        challengeDescriptionLabel.text = "파랑 문제를 2번 도전해 완등했네요!"
        challengeDescriptionLabel.textColor = UIColor(red: 0.6, green: 0.9, blue: 0.3, alpha: 1.0)
        challengeDescriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
      
        
        // Thumbnails
        thumbnailsView.backgroundColor = .clear
        thumbnailImageView1.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1.0)
        thumbnailImageView1.layer.cornerRadius = 8
        thumbnailImageView1.clipsToBounds = true
        thumbnailImageView1.contentMode = .scaleAspectFill
        
        thumbnailImageView2.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1.0)
        thumbnailImageView2.layer.cornerRadius = 8
        thumbnailImageView2.clipsToBounds = true
        thumbnailImageView2.contentMode = .scaleAspectFill
        

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
