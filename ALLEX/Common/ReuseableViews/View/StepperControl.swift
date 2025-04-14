//
//  CustomStepper.swift
//  ALLEX
//
//  Created by youngkyun park on 4/13/25.
//

import UIKit
import SnapKit

// 수동 기록 입력시, 횟수 입력 버튼
final class StepperControl: BaseView {
    
    // MARK: - Properties
    private let buttonContainer = UIView()
    let minusButton = UIButton()
    let plusButton = UIButton()

    private let buttonWidht = 40
    private let buttonHeigth = 25
    private let buttonOffset = 16

    override func configureHierarchy() {

        self.addSubview(buttonContainer)
        buttonContainer.addSubviews(plusButton, minusButton)
    }
    
    override func configureLayout() {
        
        buttonContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()            
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-buttonOffset)
            make.width.equalTo(buttonWidht)
            make.height.equalTo(buttonHeigth)
        }
        
        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(buttonOffset)
            make.width.equalTo(buttonWidht)
            make.height.equalTo(buttonHeigth)
            
        }
    }
    
    override func configureView() {
        
        // 버튼 컨테이너 설정
        buttonContainer.backgroundColor = .clear

        // 플러스 버튼 설정 (위)
        plusButton.setTitle("+", for: .normal)
        
        // 마이너스 버튼 설정 (아래)
        minusButton.setTitle("-", for: .normal)
        
        [plusButton, minusButton].forEach {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.backgroundColor = .darkGray
            $0.layer.cornerRadius = 12
        }


    }

  
}
