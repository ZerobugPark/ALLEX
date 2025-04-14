//
//  ProgressView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//

import UIKit

import SnapKit

final class ProgressView: UIView {
    
    private let containerView = BaseView()

    
    // 원형 난이도 표시기
    let levelCircle = CustomView()
    let levelLabel = TertiaryLabel()

    let progressView = UIProgressView(progressViewStyle: .default)

    // 진행률 텍스트
    let countLabel = UILabel()

    init() {
        super.init(frame: .zero)
 

        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        self.addSubview(containerView)
        levelCircle.addSubview(levelLabel)
        containerView.addSubviews(levelCircle, progressView, countLabel)
      
    }
    
    func configureLayout() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        levelLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 제약 조건 설정
        levelCircle.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(levelCircle.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(countLabel.snp.leading).offset(-15)
        }
        
        countLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }

    
    private func configureView() {
        
        containerView.backgroundColor = .clear
        
        levelLabel.font = .setAllexFont(.bold_14)
        levelLabel.textAlignment = .center
        levelCircle.layer.cornerRadius = 18
        
    
        progressView.progressTintColor = .setAllexColor(.pirmary)
        progressView.trackTintColor = UIColor(red: 0.95, green: 0.75, blue: 0.75, alpha: 1.0)
        progressView.layer.cornerRadius = 6
        progressView.clipsToBounds = true
        progressView.transform = CGAffineTransform(scaleX: 1, y: 2) // 높이 조정
        
        countLabel.font = .setAllexFont(.bold_14)
        countLabel.textAlignment = .right
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


