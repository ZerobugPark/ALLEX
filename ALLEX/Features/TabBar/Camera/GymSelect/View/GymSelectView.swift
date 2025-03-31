//
//  GymSelectView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import SnapKit

final class GymSelectionView: BaseView {

  
    
    // 나중에 Lottie로 변경
    private let lottie = UIImageView(image: UIImage(systemName: "tortoise"))
    private let imageView = UIImageView(image: .setAllexSymbol(.location))
    
    let spaceLabel = TitleLabel(key: .gymTitle, title: "")

    let startButton = BaseButton(key: .start)
    
    
    
    override func configureHierarchy() {
        self.addSubviews(lottie, imageView, spaceLabel, startButton)
 
        
    }
    
    override func configureLayout() {
        lottie.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.size.equalTo(100)
        }
        
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(lottie.snp.bottom).offset(12)
            make.trailing.equalTo(spaceLabel.snp.leading).offset(-4)
            make.size.equalTo(24)
        }
        
        spaceLabel.snp.makeConstraints { make in
            make.top.equalTo(lottie.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(spaceLabel.snp.bottom).offset(44)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
    }
    
    override func configureView() {
        spaceLabel.isUserInteractionEnabled = true
        spaceLabel.font = .setAllexFont(.bold_16)
        
        imageView.tintColor = .setAllexColor(.textPirmary)
        startButton.isEnabled = false
    }
    
    
    

}
