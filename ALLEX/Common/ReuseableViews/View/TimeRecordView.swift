//
//  TimeRecordView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import UIKit

import SnapKit
import Lottie


// 실시간 기록시 시간 기록 뷰
final class TimeRecordView: BaseView {
    
    let timeLabel = TertiaryLabel(title: "")
    let timeButton = TimeButton()
    
    let animationImageView = LottieAnimationView(name: "Run")
    
    // 스와이프 안내 레이블
    private let infoLabel = TertiaryLabel(key: .Info_SwipeGesture, title: "")
    
    
    override func configureHierarchy() {
        self.addSubviews(timeButton, timeLabel, animationImageView, infoLabel)
    }
    
    override func configureLayout() {
 
        animationImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(14)
            make.size.equalTo(48)
        }
        
        timeButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide).offset(-44)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.size.equalTo(28)
            
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(timeButton.snp.trailing).offset(12)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-12)
        }
    }
    
    override func configureView() {
        
        timeLabel.text = "00:00:00"
        timeLabel.textAlignment = .center
        timeLabel.font = .setAllexFont(.regular_16)
        
        infoLabel.font = .setAllexFont(.light_12)
        
        self.backgroundColor = .setAllexColor(.backGround)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        let keypath = AnimationKeypath(keypath: "**.Color")
        let colorValueProvider = ColorValueProvider(UIColor.pirmary.lottieColorValue)
        animationImageView.setValueProvider(colorValueProvider, keypath: keypath)
        
        animationImageView.loopMode = .loop
        animationImageView.play()
        
        
        
    }
    

    
    
    
}
