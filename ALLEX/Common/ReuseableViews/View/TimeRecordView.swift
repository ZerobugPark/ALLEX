//
//  TimeRecordView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import UIKit

import SnapKit
import Lottie


final class TimeRecordView: BaseView {
    
    

    let timeLabel = TertiaryLabel(title: "")
    let timeButton = TimeButton()
    
    let animationImageView = LottieAnimationView(name: "Run")
    
    
    override func configureHierarchy() {
        self.addSubviews(timeButton, timeLabel, animationImageView)
        
        
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
    }
    
    override func configureView() {
        
        timeLabel.text = "00:00:00"
        timeLabel.textAlignment = .center
        timeLabel.font = .setAllexFont(.regular_16)
        
        
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
