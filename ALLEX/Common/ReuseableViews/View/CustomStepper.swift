//
//  CustomStepper.swift
//  ALLEX
//
//  Created by youngkyun park on 4/13/25.
//

import UIKit
import SnapKit

class CustomStepper: BaseView {
    
    // MARK: - Properties
    private let buttonContainer = UIView()
    let minusButton = UIButton()
    let plusButton = UIButton()


    override func configureHierarchy() {
        
        
        self.addSubview(buttonContainer)
        buttonContainer.addSubviews(plusButton, minusButton)
        
    }
    
    override func configureLayout() {
        
        buttonContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()            
        }
        

        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-16)
            make.width.equalTo(40)
            make.height.equalTo(25)
        }
        

        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(16)
            make.width.equalTo(40)
            make.height.equalTo(25)
            
        }
    }
    
    override func configureView() {
        
        // 버튼 컨테이너 설정
        buttonContainer.backgroundColor = .clear

        // 플러스 버튼 설정 (위)
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        plusButton.backgroundColor = .darkGray
        
        plusButton.layer.cornerRadius = 12
      
        
        // 마이너스 버튼 설정 (아래)
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        minusButton.backgroundColor = .darkGray
        minusButton.layer.cornerRadius = 12
      
    }
    

  
}
