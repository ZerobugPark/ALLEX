//
//  BoulderingAttemptView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import UIKit

final class BoulderingAttemptView: BaseView {
    
    // MARK: - Properties
    private let eyeButtonContainer = CustomView()
    let eyeButton = BaseButton()
    
    private let stackView = UIStackView()
    
    
    private let colorIndicatorContainer = CustomView()
    let colorIndicator = CustomView()
    
    private let tryCountContainer = CustomView()
    let tryCountButton = CountButton()
    let tryMinusButton = UIButton()
    
    
    private let successCountContainer = CustomView()
    let successCountButton = CountButton()
    let successMinusButton = UIButton()
    
    let gradeLabel = TertiaryLabel(title: "")
    
    override func configureHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubviews(colorIndicatorContainer, tryCountContainer, successCountContainer)
        
        eyeButtonContainer.addSubview(eyeButton)
        colorIndicatorContainer.addSubview(colorIndicator)
        colorIndicator.addSubview(gradeLabel)
        
        
        tryCountContainer.addSubviews(tryCountButton, tryMinusButton)
        
        successCountContainer.addSubviews(successCountButton, successMinusButton)
        
        
    }
    
    override func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
        
        colorIndicatorContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(70)
        }
        
        // Color indicator constraints
        colorIndicator.snp.makeConstraints { make in
            make.center.equalTo(colorIndicatorContainer)
            make.size.equalTo(40)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Try count container constraints
        tryCountContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(70)
        }
        
        // Try count button constraints
        tryCountButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(tryMinusButton.snp.leading)
        }
        
        // Try minus button constraints
        tryMinusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(24)
        }
        
        // Success count container constraints
        successCountContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(70)
        }
        
        // Success count button constraints
        successCountButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(successMinusButton.snp.leading)
        }
        
        // Success minus button constraints
        successMinusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(24)
        }
    }
    
    override func configureView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fill

        // Color indicator
        colorIndicator.clipsToBounds = true
        
        gradeLabel.font = .setAllexFont(.bold_12)
        gradeLabel.textAlignment = .center
        
        // Configure minus buttons
        tryMinusButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        successMinusButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        
        tryMinusButton.tintColor = .systemRed
        successMinusButton.tintColor = .systemRed
    }
    
    
    
}
