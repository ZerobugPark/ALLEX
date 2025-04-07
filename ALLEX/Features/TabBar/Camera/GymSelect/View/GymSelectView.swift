//
//  GymSelectView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import SnapKit

final class GymSelectionView: BaseView {

  
    private let mainImage = UIImageView(image: UIImage(resource: .launchScreen))
    private let imageView = UIImageView(image: .setAllexSymbol(.location))
    
    let spaceLabel = TitleLabel(key: .gymTitle, title: "")

    let startButton = BaseButton(key: .start)
    
    
    
    override func configureHierarchy() {
        self.addSubviews(mainImage, imageView, spaceLabel, startButton)
 
        
    }
    
    override func configureLayout() {
        mainImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.size.equalTo(100)
        }
        
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(24)
            make.trailing.equalTo(spaceLabel.snp.leading).offset(-4)
            make.size.equalTo(24)
        }
        
        spaceLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-120)
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
