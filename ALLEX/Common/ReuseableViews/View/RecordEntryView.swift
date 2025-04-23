//
//  BoulderingAttemptView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import UIKit


// 실시간 클라이밍 기록  (셀에 들어가는 뷰)
final class RecordEntryView: BaseView {
        
    private let stackView = UIStackView()
    
    private let colorIndicatorContainer = CustomView()
    let colorIndicator = CustomView()
    
    private let tryCountContainer = CustomView()
    let tryCountButton = RecordCountButton()
    let tryMinusButton = UIButton()
    
    
    private let successCountContainer = CustomView()
    let successCountButton = RecordCountButton()
    let successMinusButton = UIButton()
    
    let gradeLabel = TertiaryLabel(title: "")
    
    private let containerHeight: CGFloat = 70
    private let indicatorSize: CGFloat = 40
    private let buttonSize: CGFloat = 24
    private let buttonOffset: CGFloat = -8
    
    
    override func configureHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubviews(colorIndicatorContainer, tryCountContainer, successCountContainer)

        colorIndicatorContainer.addSubview(colorIndicator)
        colorIndicator.addSubview(gradeLabel)
        
        tryCountContainer.addSubviews(tryCountButton, tryMinusButton)
        successCountContainer.addSubviews(successCountButton, successMinusButton)
                
    }
    
    override func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(containerHeight)
        }
        
        colorIndicatorContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
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
        
        // Try count container constraints
        tryCountContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(containerHeight)
        }
        
        // Try count button constraints
        tryCountButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(tryMinusButton.snp.leading)
        }
        
        // Try minus button constraints
        tryMinusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(buttonOffset)
            make.size.equalTo(buttonSize)
        }
        
        // Success count container constraints
        successCountContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(containerHeight)
        }
        
        // Success count button constraints
        successCountButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(successMinusButton.snp.leading)
        }
        
        // Success minus button constraints
        successMinusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(buttonOffset)
            make.size.equalTo(buttonSize)
        }
    }
    
    override func configureView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fill

        // Color indicator
        colorIndicator.clipsToBounds = true
        colorIndicator.layer.cornerRadius = indicatorSize / 2
        
        gradeLabel.font = .setAllexFont(.bold_12)
        gradeLabel.textAlignment = .center
        
        // Configure minus buttons
        configureMinusButton(tryMinusButton)
        configureMinusButton(successMinusButton)
    }
    
    private func configureMinusButton(_ button: UIButton) {
        button.setImage(.setAllexSymbol(.minusCircleFill), for: .normal)
        button.tintColor = .systemRed
    }
    
}
