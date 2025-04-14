//
//  CountButton.swift
//  ALLEX
//
//  Created by youngkyun park on 4/2/25.
//

import UIKit

import SnapKit

final class RecordCountButton: UIButton {

    // 커스텀 이미지 뷰로 버튼의 이미지를 설정
    private let containerView = CustomView(radius: 20, bgColor: .setAllexColor(.backGroundSecondary))
    let countLabel = SubTitleLabel(title: "0")

    
    init() {
        super.init(frame: .zero)
        
        // customImageView 설정
        addSubview(containerView)
        containerView.addSubview(countLabel)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.8)
        }
        
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
                
        countLabel.textAlignment = .center
        countLabel.font = .setAllexFont(.bold_16)
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
