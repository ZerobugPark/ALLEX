//
//  ResultTableViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import UIKit

struct BowlingLocation {
    let name: String
    let time: String
    let games: [BowlingGame]
}

struct BowlingGame {
    let name: String
    let score: String
    let frames: String
    let percentage: Int
}



final class ResultTableViewCell: BaseTableViewCell {
    
    private let containerView = CustomView(radius: 12, bgColor: .setAllexColor(.backGroundSecondary))
    private let dateLabel = SubTitleLabel()
    private let editButton = UIButton()
    private let viewDetailsButton = UIButton()
    
    private let locationPinIcon = UIImageView()
    private let locationNameLabel = TitleLabel()
    private let timeIcon = UIImageView()
    private let timeLabel = TertiaryLabel()
    
    private let bowlingLabel = TertiaryLabel()
    private let bowlingStatusContainer = UIStackView()
    
    private let separatorLine = CustomView()
    
    
    override func configureHierarchy() {
        
        
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(dateLabel)
        containerView.addSubview(locationPinIcon)
        
        containerView.addSubview(locationNameLabel)
        
        containerView.addSubview(timeIcon)
        containerView.addSubview(timeLabel)
        containerView.addSubview(separatorLine)
        containerView.addSubview(bowlingLabel)
        
        containerView.addSubview(bowlingStatusContainer)
        
        
    }
    
    override func configureLayout() {
        
        containerView.snp.makeConstraints { make in
            
            make.verticalEdges.equalTo(self.contentView.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(self.contentView.safeAreaLayoutGuide).inset(16)
            
        }
        
        
        
        dateLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
        }
        

        
        locationPinIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.width.height.equalTo(24)
        }
        
        
        
        locationNameLabel.snp.makeConstraints { make in
            make.left.equalTo(locationPinIcon.snp.right).offset(6)
            make.centerY.equalTo(locationPinIcon)
        }
        
        
        timeIcon.snp.makeConstraints { make in
            make.trailing.equalTo(timeLabel.snp.leading).offset(-4)
            make.centerY.equalTo(locationPinIcon)
            make.size.equalTo(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(timeIcon)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(locationPinIcon.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        
        bowlingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(separatorLine.snp.bottom).offset(12)
        }
        
        
        bowlingStatusContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(bowlingLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        
    }
    
    override func configureView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        
        // Date and action buttons
        dateLabel.font = .setAllexFont(.bold_14)
        
       
        
        // Location and time info
        locationPinIcon.image = UIImage(systemName: "mappin.circle.fill")
        locationPinIcon.tintColor = .setAllexColor(.pirmary)
        
        locationNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        
        timeIcon.image = UIImage(systemName: "clock")
        timeIcon.tintColor = .darkGray
        
        
        timeLabel.textAlignment = .right
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .setAllexColor(.textSecondary)
        
        
        
        // Separator line
        separatorLine.backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        // Bowling activity info
        bowlingLabel.text = "클라이밍"
        bowlingLabel.textColor = .setAllexColor(.textPirmary)
        bowlingLabel.font = .setAllexFont(.regular_14)
        
        
        bowlingStatusContainer.axis = .vertical
        bowlingStatusContainer.spacing = 8
        bowlingStatusContainer.distribution = .fillEqually
    }

    
}


extension ResultTableViewCell {
    
    
    // MARK: - Configuration
    func configure(with info: ClimbingInfo) {
        dateLabel.text = info.climbDate
        locationNameLabel.text = info.gym
    
        timeLabel.text = info.excersieTime
        
        // Remove existing status views
        bowlingStatusContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let gameView = createGameResultView(game: info)
        bowlingStatusContainer.addArrangedSubview(gameView)
        // Add game results
//        for game in info.routeResults {
//            let gameView = createGameResultView(game: game)
//            bowlingStatusContainer.addArrangedSubview(gameView)
//        }
    }
    
    private func createGameResultView(game: ClimbingInfo) -> UIView {
        let container = CustomView()
        container.backgroundColor = .clear
        
        let grade = UIImageView(image: UIImage(resource: .climbing))
              
        container.addSubview(grade)
        grade.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        
        let scoreLabel = TertiaryLabel()
        scoreLabel.text = "\(game.totalSuccessCount) / \(game.totalClimbCount)"
        scoreLabel.font = .setAllexFont(.bold_14)
        container.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let percentLabel = TertiaryLabel()
    
        let rate = (Double(game.totalSuccessCount) / Double(game.totalClimbCount)) * 100
        
        if rate.isNaN {
            percentLabel.text = "0%"
        } else {
            percentLabel.text = String(format: "%.0f%%", rate)
        }
        
        
        
        percentLabel.font = .setAllexFont(.bold_14)
        container.addSubview(percentLabel)
        percentLabel.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview()
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
        return container
    }
}
