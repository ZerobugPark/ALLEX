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
    
    let containerView = UIView()
    let dateLabel = UILabel()
    let actionButtonsContainer = UIView()
    let editButton = UIButton()
    let viewDetailsButton = UIButton()
    
    let locationPinIcon = UIImageView()
    let locationNameLabel = UILabel()
    let timeIcon = UIImageView()
    let timeLabel = UILabel()
    
    let bowlingLabel = UILabel()
    let bowlingStatusContainer = UIStackView()
    
    let separatorLine = UIView()
    let colorIndicator = UIView()
    
    
    
    override func configureHierarchy() {
        
        setupUI()
    }
    
    override func configureLayout() {
        
        
        
    }
    
    override func configureView() {
        
    }
    
    
    func setupData(_ data: BoulderingAttempt) {
        
    }
    
    override func layoutSubviews() {
        
        
        
    }
    
}


extension ResultTableViewCell {
    
    
    // MARK: - UI Setup
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Color indicator on the left
        colorIndicator.backgroundColor = .systemMint
        contentView.addSubview(colorIndicator)
        colorIndicator.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(4)
        }
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalTo(colorIndicator.snp.right)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalToSuperview().offset(-16)
        }
        
        // Date and action buttons
        dateLabel.text = "25/04/03"
        dateLabel.textColor = .darkGray
        dateLabel.font = .systemFont(ofSize: 14)
        containerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
        }
        
        actionButtonsContainer.backgroundColor = .clear
        containerView.addSubview(actionButtonsContainer)
        actionButtonsContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(20)
        }
        
        let editButtonText = UILabel()
        editButtonText.text = "편집"
        editButtonText.textColor = .darkGray
        editButtonText.font = .systemFont(ofSize: 14)
        actionButtonsContainer.addSubview(editButtonText)
        editButtonText.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let separatorText = UILabel()
        separatorText.text = " | "
        separatorText.textColor = .darkGray
        separatorText.font = .systemFont(ofSize: 14)
        actionButtonsContainer.addSubview(separatorText)
        separatorText.snp.makeConstraints { make in
            make.right.equalTo(editButtonText.snp.left)
            make.centerY.equalToSuperview()
        }
        
        let viewText = UILabel()
        viewText.text = "자세히보기"
        viewText.textColor = .darkGray
        viewText.font = .systemFont(ofSize: 14)
        actionButtonsContainer.addSubview(viewText)
        viewText.snp.makeConstraints { make in
            make.right.equalTo(separatorText.snp.left)
            make.centerY.equalToSuperview()
        }
        
        // Location and time info
        locationPinIcon.image = UIImage(systemName: "mappin.circle.fill")
        locationPinIcon.tintColor = .red
        containerView.addSubview(locationPinIcon)
        locationPinIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.width.height.equalTo(24)
        }
        
        locationNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        containerView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.left.equalTo(locationPinIcon.snp.right).offset(6)
            make.centerY.equalTo(locationPinIcon)
        }
        
        timeIcon.image = UIImage(systemName: "clock")
        timeIcon.tintColor = .darkGray
        containerView.addSubview(timeIcon)
        timeIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(locationPinIcon)
            make.width.height.equalTo(20)
        }
        
        timeLabel.textAlignment = .right
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .darkGray
        containerView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.right.equalTo(timeIcon.snp.left).offset(-4)
            make.centerY.equalTo(timeIcon)
        }
        
        // Separator line
        separatorLine.backgroundColor = .lightGray.withAlphaComponent(0.3)
        containerView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(locationPinIcon.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        
        // Bowling activity info
        bowlingLabel.text = "볼링"
        bowlingLabel.textColor = .systemGreen
        bowlingLabel.font = .systemFont(ofSize: 14, weight: .medium)
        containerView.addSubview(bowlingLabel)
        bowlingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(separatorLine.snp.bottom).offset(12)
        }
        
        bowlingStatusContainer.axis = .vertical
        bowlingStatusContainer.spacing = 8
        bowlingStatusContainer.distribution = .fillEqually
        containerView.addSubview(bowlingStatusContainer)
        bowlingStatusContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(bowlingLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    // MARK: - Configuration
    func configure(with location: BowlingLocation) {
        locationNameLabel.text = location.name
        timeLabel.text = location.time
        
        // Remove existing status views
        bowlingStatusContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add game results
        for game in location.games {
            let gameView = createGameResultView(game: game)
            bowlingStatusContainer.addArrangedSubview(gameView)
        }
    }
    
    private func createGameResultView(game: BowlingGame) -> UIView {
        let container = UIView()
        
        let gameLabel = UILabel()
        gameLabel.text = game.name
        gameLabel.font = .systemFont(ofSize: 14)
        gameLabel.textColor = .darkGray
        container.addSubview(gameLabel)
        gameLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        
        let scoreLabel = UILabel()
        scoreLabel.text = "\(game.score) / \(game.frames)프레임"
        scoreLabel.font = .systemFont(ofSize: 14)
        scoreLabel.textColor = .darkGray
        container.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        let percentLabel = UILabel()
        percentLabel.text = "\(game.percentage)%"
        percentLabel.font = .systemFont(ofSize: 14, weight: .bold)
        percentLabel.textColor = game.percentage > 0 ? .black : .lightGray
        container.addSubview(percentLabel)
        percentLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
        return container
    }
}
