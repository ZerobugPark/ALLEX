//
//  BoulderingStepperView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/12/25.
//

import UIKit

import SnapKit

// 클라이밍 수동 기록 (셀에 들어가는 뷰)
final class ClimbLogUnitView: BaseView {
    
    // MARK: - Properties
    
    private let stackView = UIStackView()
    
    private let colorIndicatorContainer = CustomView()
    let colorIndicator = CustomView()
    
    private let tryCountContainer = CustomView()
    let tryCountLabel = SubTitleLabel(title: "0")
    let tryCountButton = StepperControl()
    
    
    private let successCountContainer = CustomView()
    let successCountLabel = SubTitleLabel(title: "0")
    let successCountButton = StepperControl()
    
    let gradeLabel = TertiaryLabel(title: "")
    
    private let containerHeight: CGFloat = 70
    private let indicatorSize: CGFloat = 40
    private let buttonWidth: CGFloat = 40
    private let buttonHeight: CGFloat = 60
    private let buttonOffset: CGFloat = -8
    
    
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
            make.height.equalTo(containerHeight)
        }
        
        // Color indicator constraints
        colorIndicator.snp.makeConstraints { make in
            make.center.equalTo(colorIndicatorContainer)
            make.size.equalTo(indicatorSize)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        configureContainerLayouts()
        
        
        configureCountLayout(label: tryCountLabel, button: tryCountButton, inContainer: tryCountContainer)
        configureCountLayout(label: successCountLabel, button: successCountButton, inContainer: successCountContainer)
    }
    
    override func configureView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        // Color indicator
        colorIndicator.clipsToBounds = true
        
        gradeLabel.font = .setAllexFont(.bold_12)
        gradeLabel.textAlignment = .center
        
        [tryCountLabel, successCountLabel].forEach {
            $0.backgroundColor = .setAllexColor(.backGroundTertiary)
            $0.textAlignment = .center
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            
        }
        
    }
    
    private func configureContainerLayouts() {
        colorIndicatorContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(containerHeight)
        }
        
        tryCountContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(containerHeight)
        }
        
        successCountContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(containerHeight)
        }
    }
    
    private func configureCountLayout(label: SubTitleLabel, button: StepperControl, inContainer container: UIView) {
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(buttonHeight)
            make.trailing.equalTo(button.snp.leading).offset(buttonOffset)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(buttonOffset)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(containerHeight)
        }
    }
}


