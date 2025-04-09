//
//  BoulderingHiddenList.swift
//  ALLEX
//
//  Created by youngkyun park on 4/9/25.
//

import UIKit

final class BoulderingHiddenList: BaseView {
    
    // MARK: - Properties
    private let eyeButtonContainer = CustomView()
    let eyeButton = BaseButton()
    
    private let stackView = UIStackView()
    
    
    private let colorIndicatorContainer = CustomView()
    let colorIndicator = CustomView()
    
    let tryCountButton = CountButton()
    let successCountButton = CountButton()
    
    let gradeLabel = TertiaryLabel(title: "")
    
    override func configureHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubviews(eyeButtonContainer, colorIndicatorContainer, tryCountButton, successCountButton)
        
        eyeButtonContainer.addSubview(eyeButton)
        colorIndicatorContainer.addSubview(colorIndicator)
        colorIndicator.addSubview(gradeLabel)
        
    }
    
    override func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
        
        eyeButtonContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(70)
        }
        
        // 1. Eye button constraints
        eyeButton.snp.makeConstraints { make in
            make.center.equalTo(eyeButtonContainer)
            make.size.equalTo(24)
        }
        
        colorIndicatorContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(70)
        }
        
        
        // 2. Color indicator constraints
        colorIndicator.snp.makeConstraints { make in
            
            make.center.equalTo(colorIndicatorContainer)
            make.size.equalTo(40)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tryCountButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(70)
        }
        
        successCountButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(70)
        }
        
    }
    
    override func configureView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        // Eye button
        eyeButton.setImage(.setAllexSymbol(.eyeSlash), for: .normal)
        eyeButton.tintColor = .systemGray3

        // Color indicator
        colorIndicator.clipsToBounds = true
        
        gradeLabel.font = .setAllexFont(.bold_12)
        gradeLabel.textAlignment = .center
        
    }
    
    
    
}
