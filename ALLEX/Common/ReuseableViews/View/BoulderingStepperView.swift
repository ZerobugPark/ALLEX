//
//  BoulderingStepperView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/12/25.
//

import UIKit

import SnapKit

final class BoulderingStepperView: BaseView {
    
    // MARK: - Properties
    
    private let stackView = UIStackView()
    
    private let colorIndicatorContainer = CustomView()
    let colorIndicator = CustomView()
    
    private let tryCountContainer = CustomView()
    let tryCountLabel = SubTitleLabel(title: "0")
    let tryCountButton = CustomStepper()
    
    
    private let successCountContainer = CustomView()
    let successCountLabel = SubTitleLabel(title: "0")
    let successCountButton = CustomStepper()
    
    let gradeLabel = TertiaryLabel(title: "")
    
    var test = 0
    var test1 = 0
    
    override func configureHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubviews(colorIndicatorContainer, tryCountContainer, successCountContainer)
        
        colorIndicatorContainer.addSubview(colorIndicator)
        colorIndicator.addSubview(gradeLabel)
        
        
        tryCountContainer.addSubviews(tryCountLabel, tryCountButton)
        
        successCountContainer.addSubviews(successCountLabel, successCountButton)
        
        
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
        tryCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(60)
            make.trailing.equalTo(tryCountButton.snp.leading).offset(-8)
        }
        
        // Try minus button constraints
        tryCountButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)  // 오른쪽 마진 추가
            make.width.equalTo(40)
            make.height.equalTo(70)
        }
        
        
        // Success count container constraints
        successCountContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(70)
        }
        
        // Success count button constraints
        successCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(60)
            make.trailing.equalTo(successCountButton.snp.leading).offset(-8)
        }
        
        // Success minus button constraints
        successCountButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)  // 오른쪽 마진 추가
            make.width.equalTo(40)
            make.height.equalTo(70)
        }
    }
    
    override func configureView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        // Color indicator
        colorIndicator.clipsToBounds = true
        
        gradeLabel.font = .setAllexFont(.bold_12)
        gradeLabel.textAlignment = .center
        
        
        tryCountLabel.backgroundColor = .setAllexColor(.backGroundTertiary)
        tryCountLabel.textAlignment = .center
        tryCountLabel.layer.cornerRadius = 20
        tryCountLabel.clipsToBounds = true
        
        successCountLabel.backgroundColor = .setAllexColor(.backGroundTertiary)
        successCountLabel.textAlignment = .center
        successCountLabel.layer.cornerRadius = 20
        successCountLabel.clipsToBounds = true
        
        
    }
}
    

