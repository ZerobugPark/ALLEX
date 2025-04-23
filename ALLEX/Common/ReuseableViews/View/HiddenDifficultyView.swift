//
//  BoulderingHiddenList.swift
//  ALLEX
//
//  Created by youngkyun park on 4/9/25.
//

import UIKit

// 클라이밍 난이도 숨김 (셀에 들어가는 뷰)
final class HiddenDifficultyView: BaseView {
    
    // MARK: - Properties
    private let eyeButtonContainer = CustomView()
    let eyeButton = BaseButton()
    
    private let stackView = UIStackView()
    
    private let colorIndicatorContainer = CustomView()
    let colorIndicator = CustomView()
    
    let tryCountButton = RecordCountButton()
    let successCountButton = RecordCountButton()
    
    let gradeLabel = TertiaryLabel(title: "")
    
    private let containerHeight: CGFloat = 70
    private let indicatorSize: CGFloat = 40
    private let buttonSize: CGFloat = 24
    
    
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
            make.height.equalTo(containerHeight)
        }
        
        
        eyeButtonContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(containerHeight)
        }
        
        // 1. Eye button constraints
        eyeButton.snp.makeConstraints { make in
            make.center.equalTo(eyeButtonContainer)
            make.size.equalTo(buttonSize)
        }
        
        colorIndicatorContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(containerHeight)
        }
        
        
        // 2. Color indicator constraints
        colorIndicator.snp.makeConstraints { make in
            make.center.equalTo(colorIndicatorContainer)
            make.size.equalTo(indicatorSize)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
  
        configureCountLayout(button: tryCountButton)
        configureCountLayout(button: successCountButton)
        
    }
    
    override func configureView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        // Eye button
        eyeButton.setImage(.setAllexSymbol(.eyeSlash), for: .normal)
        eyeButton.tintColor = .systemGray3

        // Color indicator
        colorIndicator.clipsToBounds = true
        colorIndicator.layer.cornerRadius = 20
        
        gradeLabel.font = .setAllexFont(.bold_12)
        gradeLabel.textAlignment = .center
        
    }
        
    private func configureCountLayout(button: RecordCountButton) {
        button.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(containerHeight)
        }
        
   
    }
    
    
    
}
